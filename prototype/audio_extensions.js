// Real audio playback for generated repository assets.
(() => {
  let currentAudio = null;

  const style = document.createElement("style");
  style.textContent = `
    .audio-inline{display:flex;align-items:center;gap:8px;margin-top:8px;flex-wrap:wrap}
    .audio-play-btn{border:1px solid #d9dced;background:#fff;color:#5d6578;border-radius:10px;padding:7px 10px;font:inherit;font-size:12px;font-weight:700}
    .audio-play-btn:hover{border-color:#aaa1e8;background:#f7f5ff}
    .audio-play-btn:disabled{opacity:.55;cursor:wait}
    .audio-source-note{font-size:11px;color:#9298a7}
    .audio-source-note.stale{color:#9a6b35}
    .lexeme-audio{margin-top:12px;display:flex;gap:8px;align-items:center}
    .audio-summary{margin-top:10px;color:#7d8494;font-size:12px}
  `;
  document.head.append(style);

  function synthesize(text, button, note) {
    if (!text || !("speechSynthesis" in window)) {
      if (note) note.textContent = "فایل صوتی در دسترس نیست.";
      return;
    }
    window.speechSynthesis.cancel();
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = state?.languageCode === "de" ? "de-DE" : (state?.languageCode || "de-DE");
    utterance.rate = 0.9;
    if (button) button.disabled = true;
    if (note) note.textContent = "پخش جایگزین مرورگر…";
    utterance.onend = () => {
      if (button) button.disabled = false;
      if (note) note.textContent = "پخش شد.";
    };
    utterance.onerror = () => {
      if (button) button.disabled = false;
      if (note) note.textContent = "پخش صدا انجام نشد.";
    };
    window.speechSynthesis.speak(utterance);
  }

  function playAudio(url, text, button, note) {
    if (currentAudio) {
      currentAudio.pause();
      currentAudio = null;
    }
    if ("speechSynthesis" in window) window.speechSynthesis.cancel();

    if (!url) {
      synthesize(text, button, note);
      return;
    }

    const audio = new Audio(url);
    currentAudio = audio;
    button.disabled = true;
    if (note) note.textContent = "در حال پخش فایل اصلی…";
    audio.onended = () => {
      button.disabled = false;
      if (note) note.textContent = "پخش شد.";
      if (currentAudio === audio) currentAudio = null;
    };
    audio.onerror = () => {
      button.disabled = false;
      if (note) note.textContent = "فایل اصلی باز نشد؛ fallback مرورگر.";
      if (currentAudio === audio) currentAudio = null;
      synthesize(text, button, note);
    };
    audio.play().catch(() => {
      button.disabled = false;
      if (note) note.textContent = "مرورگر پخش خودکار را نپذیرفت؛ دوباره بزن.";
    });
  }

  function rawAsset(ownerType, ownerKey) {
    if (!ownerKey) return null;
    return state.bundle?.audioAssets?.[`${ownerType}:${ownerKey}`] || null;
  }

  function resolvedAsset(ownerType, ownerKey, fallbackItem = null) {
    const asset = rawAsset(ownerType, ownerKey);
    if (!asset) {
      return {
        url: fallbackItem?.audioUrl || null,
        voiceName: fallbackItem?.audioVoiceName || "",
        available: !!fallbackItem?.audioAvailable,
        stale: false,
      };
    }

    const current = asset.audioStatus === "ready" && asset.audioIsCurrent !== false;
    const available = current && asset.available !== false && !!(asset.localUrl || asset.effectiveUrl || asset.audioUrl || asset.publicUrl);
    return {
      url: available ? (asset.localUrl || asset.effectiveUrl || asset.audioUrl || asset.publicUrl) : null,
      voiceName: asset.voiceName || fallbackItem?.audioVoiceName || "",
      available,
      stale: !current && (asset.audioStatus === "stale" || asset.audioIsCurrent === false),
    };
  }

  function makePlayButton({ url, text, label = "🔊 پخش", voiceName = "", available = false, stale = false }) {
    const wrap = document.createElement("div");
    wrap.className = "audio-inline";
    const button = document.createElement("button");
    button.type = "button";
    button.className = "audio-play-btn";
    button.textContent = label;
    const note = document.createElement("span");
    note.className = `audio-source-note${stale ? " stale" : ""}`;
    note.textContent = available
      ? (voiceName ? `ElevenLabs · ${voiceName}` : "فایل صوتی اصلی")
      : stale
        ? "فایل فعلی stale است · fallback مرورگر"
        : "fallback مرورگر";
    button.addEventListener("click", () => playAudio(url, text, button, note));
    wrap.append(button, note);
    return wrap;
  }

  const oldRenderConversation = window.renderConversation;
  if (typeof oldRenderConversation === "function") {
    window.renderConversation = function(activity, complete) {
      oldRenderConversation(activity, complete);
      const dialogue = state.currentLevel?.dialogues?.[activity.dialogueRef];
      const rows = [...document.querySelectorAll("#activityBody .conversation .turn")];
      (dialogue?.turns || []).forEach((turn, index) => {
        const row = rows[index];
        const bubble = row?.querySelector(".bubble");
        if (!bubble || bubble.querySelector(".audio-inline")) return;
        const audio = resolvedAsset("dialogue_turn", turn.id, turn);
        bubble.append(makePlayButton({
          ...audio,
          text: turn.textTarget,
          label: turn.learnerTurn ? "🔊 نمونه تلفظ" : "🔊 پخش جمله",
        }));
      });
    };
  }

  const oldOpenLexeme = window.openLexeme;
  if (typeof oldOpenLexeme === "function") {
    window.openLexeme = function(lexemeId, formId = null) {
      oldOpenLexeme(lexemeId, formId);
      const lexeme = state.bundle?.lexemes?.[lexemeId];
      const head = document.querySelector("#modalContent .lexeme-head");
      if (!lexeme || !head || head.querySelector(".lexeme-audio")) return;

      const audio = resolvedAsset("lexeme", lexemeId, lexeme);
      const holder = document.createElement("div");
      holder.className = "lexeme-audio";
      holder.append(makePlayButton({
        ...audio,
        text: lexeme.surface || lexeme.lemma,
        label: "🔊 تلفظ واژه",
      }));
      head.append(holder);
    };
  }

  function addAudioSummary() {
    const hero = document.querySelector(".hero-card");
    if (!hero || hero.querySelector(".audio-summary")) return;

    const assets = Object.values(state.bundle?.audioAssets || {});
    const total = Number(state.bundle?.meta?.audioAssetCount || assets.length || 0);
    if (!total) return;

    const ready = assets.filter((asset) => asset?.audioStatus === "ready" && asset?.audioIsCurrent !== false && asset?.available !== false).length;
    const stale = assets.filter((asset) => asset?.audioStatus === "stale" || asset?.audioIsCurrent === false).length;

    const summary = document.createElement("div");
    summary.className = "audio-summary";
    summary.textContent = stale
      ? `${ready} از ${total} فایل صوتی current است؛ ${stale} فایل stale فعلاً با صدای مرورگر پخش می‌شود.`
      : `${ready} از ${total} فایل صوتی current و در دسترس پروتوتایپ است.`;
    hero.append(summary);
  }

  const observer = new MutationObserver(() => addAudioSummary());
  observer.observe(document.documentElement, { childList: true, subtree: true });
  window.addEventListener("DOMContentLoaded", addAudioSummary);
})();
