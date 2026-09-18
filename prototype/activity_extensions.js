// Interactive activity renderers for newer lesson content.
// This file is loaded after app.js and extends the prototype without changing content JSON.
(() => {
  const oldUnknown = window.renderUnknownActivity;
  const oldChoice = window.renderChoice;
  const oldLabel = window.activityLabel;

  const labelsFa = {
    conversation_speaking: "مکالمه و گفتن",
    listen_choose: "گوش کن و انتخاب کن",
    multiple_choice: "چندگزینه‌ای",
    choose_response: "انتخاب پاسخ",
    word_order: "چیدن کلمات",
    fill_blank: "جای خالی",
    matching: "وصل‌کردنی",
    listen_repeat: "گوش کن و تکرار کن",
    pronunciation_read: "تمرین تلفظ",
    grammar_focus: "نکتهٔ دستوری",
    comprehension: "درک مطلب",
    true_false: "درست یا غلط",
    review: "مرور و تمرین",
  };

  if (typeof oldLabel === "function") {
    window.activityLabel = (type) => labelsFa[type] || oldLabel(type);
  }

  const style = document.createElement("style");
  style.textContent = `
    .ext-stack{display:grid;gap:14px;margin-top:16px}
    .ext-target{direction:ltr;text-align:left;border:1px solid #e3e5ed;background:#fbfcff;border-radius:16px;padding:16px;font-size:22px;font-weight:750;line-height:1.65}
    .ext-muted{color:#858b9a;font-size:13px;line-height:1.8}
    .ext-row{display:flex;gap:10px;flex-wrap:wrap;align-items:center}
    .ext-audio{display:flex;align-items:center;justify-content:space-between;gap:12px;background:#f7f5ff;border:1px solid #e3defd;border-radius:16px;padding:14px 16px}
    .ext-audio-copy{display:grid;gap:3px}.ext-audio-copy strong{font-size:14px}.ext-audio-copy small{color:#7d7992}
    .ext-input{width:100%;border:1px solid #dfe2ea;border-radius:14px;padding:13px 14px;font:inherit;background:white;outline:none}
    .ext-input:focus{border-color:#8a7ee1;box-shadow:0 0 0 3px rgba(113,100,216,.10)}
    .ext-choice-grid{display:grid;gap:10px;margin-top:12px}
    .ext-option{width:100%;border:1px solid #dfe2ea;border-radius:15px;background:#fff;padding:14px 16px;text-align:right;display:grid;gap:5px;font:inherit}
    .ext-option:hover{border-color:#bbb3ef;background:#fbfaff}.ext-option:disabled{cursor:default;opacity:.7}
    .ext-option.good{border-color:#75c79a;background:#effaf4}.ext-option.bad{border-color:#e59a9a;background:#fff3f3}
    .ext-option-target{direction:ltr;text-align:left;font-size:17px;font-weight:750}.ext-option-fa{font-size:16px;font-weight:700}.ext-option-sub{color:#858b9a;font-size:12px}
    .ext-match{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-top:18px}.ext-match-col{display:grid;gap:9px;align-content:start}
    .ext-match-title{font-size:12px;color:#858b9a;margin-bottom:2px}.ext-match-card{border:1px solid #dfe2ea;border-radius:14px;background:#fff;padding:13px;text-align:center;font:inherit;direction:ltr}
    .ext-match-card.selected{border-color:#8d82df;background:#f2efff}.ext-match-card.matched{border-color:#7bc59b;background:#edf9f2;color:#27784f}.ext-match-card.wrong{border-color:#e39b9b;background:#fff2f2}
    .ext-progress{display:flex;justify-content:space-between;align-items:center;color:#858b9a;font-size:12px;margin-bottom:8px}
    .ext-form{display:grid;gap:14px}.ext-field{border:1px solid #e5e7ef;border-radius:16px;padding:15px;background:#fbfcff}.ext-field label{display:block;font-weight:800;margin-bottom:6px}.ext-field .ext-target{margin:8px 0;padding:11px 13px;font-size:17px;background:white}.ext-field small{display:block;color:#858b9a;margin-bottom:9px;line-height:1.7}
    .ext-example{border-right:3px solid #d6d0fa;background:#faf9ff;border-radius:10px;padding:10px 12px;margin-top:8px}.ext-example-fa{color:#6e7485;margin-bottom:5px}.ext-example-target{direction:ltr;text-align:left;font-weight:700}
    .ext-blank{font-size:23px;font-weight:780;direction:ltr;text-align:left;border:1px dashed #cfd3df;background:#fbfcff;border-radius:16px;padding:18px;line-height:1.8}
    .ext-chip{border:1px solid #dfe2ea;background:#fff;border-radius:999px;padding:9px 13px;font:inherit}.ext-chip:hover{border-color:#aaa1e8;background:#f7f5ff}.ext-chip.correct{border-color:#75c79a;background:#effaf4}.ext-chip.wrong{border-color:#e59a9a;background:#fff3f3}
    .ext-speech-result{min-height:24px;color:#72798b;font-size:13px;line-height:1.7}
    .ext-success{color:#27784f}.ext-danger{color:#a24747}
    @media(max-width:600px){.ext-match{grid-template-columns:1fr}.ext-audio{align-items:flex-start;flex-direction:column}.ext-option{padding:13px}}
  `;
  document.head.append(style);

  function feedback(message, kind = "good") {
    if (typeof setFeedback === "function") setFeedback(message, kind);
  }

  function finish(complete, message = "عالیه، انجام شد.") {
    complete();
    feedback(message, "good");
  }

  function faText(...values) {
    return values.find((value) => typeof value === "string" && value.trim()) || "";
  }

  function targetTextOf(item) {
    if (typeof item === "string") return item;
    if (!item || typeof item !== "object") return "";
    return faText(item.textTarget, item.targetText, item.sourceText, item.text, item.value);
  }

  function persianTextOf(item) {
    if (!item || typeof item !== "object") return "";
    return faText(item.textFa, item.labelFa, item.translationFa, item.promptFa, item.questionFa, item.instructionFa);
  }

  function normalizeAnswer(value) {
    return String(value ?? "")
      .trim()
      .toLocaleLowerCase("de-DE")
      .replace(/[.!?،؛,:]+$/g, "")
      .replace(/\s+/g, " ");
  }

  function appendTarget(container, text, className = "") {
    if (!text) return;
    const wrap = document.createElement("div");
    if (className) wrap.className = className;
    if (typeof makeTargetText === "function") wrap.append(makeTargetText(text));
    else wrap.textContent = text;
    container.append(wrap);
  }

  function appendPersian(container, text, className = "context-box") {
    if (!text) return;
    const node = document.createElement("div");
    node.className = className;
    node.textContent = text;
    container.append(node);
  }

  function renderCommonContext(activity, body) {
    const data = activity.data || {};
    appendPersian(body, faText(data.contextFa, data.promptFa, data.descriptionFa));
    const target = faText(data.promptTarget, data.questionTarget);
    if (target) appendTarget(body, target, "ext-target");
  }

  function optionCorrect(option, index, answer) {
    if (option && typeof option === "object" && typeof option.correct === "boolean") return option.correct;
    if (Array.isArray(answer)) return answer.map(normalizeAnswer).includes(normalizeAnswer(targetTextOf(option)));
    if (typeof answer === "number") return index === answer;
    if (typeof answer === "string") return normalizeAnswer(targetTextOf(option)) === normalizeAnswer(answer);
    return false;
  }

  function renderOptionButton(option, index, options, answer, onCorrect, onWrong) {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "ext-option";
    const fa = persianTextOf(option);
    const target = targetTextOf(option);

    if (fa) {
      const faNode = document.createElement("div");
      faNode.className = "ext-option-fa";
      faNode.textContent = fa;
      button.append(faNode);
    }
    if (target && (!fa || normalizeAnswer(target) !== normalizeAnswer(fa))) {
      const targetNode = document.createElement("div");
      targetNode.className = "ext-option-target";
      if (typeof makeTargetText === "function") targetNode.append(makeTargetText(target));
      else targetNode.textContent = target;
      button.append(targetNode);
    }
    if (!fa && !target) button.textContent = String(option ?? "");

    button.addEventListener("click", () => {
      const correct = optionCorrect(option, index, answer);
      if (correct) {
        button.classList.add("good");
        options.querySelectorAll("button").forEach((node) => { node.disabled = true; });
        onCorrect?.(button);
      } else {
        button.classList.add("bad");
        onWrong?.(button);
        setTimeout(() => button.classList.remove("bad"), 700);
      }
    });
    return button;
  }

  // Persian-first renderer for the existing multiple-choice / choose-response activities.
  window.renderChoice = function(activity, complete, alreadyDone) {
    const body = document.querySelector("#activityBody");
    if (!body) return oldChoice?.(activity, complete, alreadyDone);
    const data = activity.data || {};
    renderCommonContext(activity, body);

    const options = document.createElement("div");
    options.className = "ext-choice-grid";
    const list = data.options || [];
    const answer = data.answer ?? data.correctAnswer;
    list.forEach((option, index) => {
      options.append(renderOptionButton(option, index, options, answer,
        () => finish(complete, "درسته! می‌تونی ادامه بدی."),
        () => feedback("این گزینه درست نیست؛ دوباره امتحان کن.", "bad")));
    });
    body.append(options);
    if (!list.length && typeof oldChoice === "function") return oldChoice(activity, complete, alreadyDone);
    if (alreadyDone) feedback("این تمرین قبلاً انجام شده؛ برای مرور می‌تونی دوباره امتحانش کنی.", "good");
  };

  function getAudioText(activity) {
    const data = activity.data || {};
    return faText(activity.audioTextTarget, data.audioTextTarget, data.textTarget, data.sourceText, data.promptTarget);
  }

  function getAudioUrl(activity) {
    const data = activity.data || {};
    return faText(data.audioUrl, data.audioURL, activity.audioUrl, activity.audioURL);
  }

  function playActivityAudio(activity, button, status) {
    const url = getAudioUrl(activity);
    const text = getAudioText(activity);
    if (url) {
      try {
        const audio = new Audio(url);
        button.disabled = true;
        status.textContent = "در حال پخش…";
        audio.onended = () => { button.disabled = false; status.textContent = "صدا پخش شد."; };
        audio.onerror = () => {
          button.disabled = false;
          status.textContent = "فایل صوتی در دسترس نبود؛ از صدای مرورگر استفاده می‌کنم.";
          speakText(text, status);
        };
        audio.play();
        return;
      } catch (_) { /* fall through */ }
    }
    speakText(text, status);
  }

  function speakText(text, status) {
    if (!text) {
      status.textContent = "برای این تمرین هنوز متن صوتی ثبت نشده است.";
      return;
    }
    if (!("speechSynthesis" in window)) {
      status.textContent = `پخش صوت در این مرورگر در دسترس نیست. متن تمرین: ${text}`;
      return;
    }
    window.speechSynthesis.cancel();
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = state?.languageCode === "de" ? "de-DE" : state?.languageCode || "de-DE";
    utterance.rate = 0.88;
    status.textContent = "در حال پخش…";
    utterance.onend = () => { status.textContent = "صدا پخش شد."; };
    utterance.onerror = () => { status.textContent = "پخش صدا انجام نشد؛ می‌تونی متن هدف را بخوانی."; };
    window.speechSynthesis.speak(utterance);
  }

  function audioPanel(activity, body, { revealTarget = false } = {}) {
    const panel = document.createElement("div");
    panel.className = "ext-audio";
    const copy = document.createElement("div");
    copy.className = "ext-audio-copy";
    copy.innerHTML = `<strong>فایل شنیداری</strong><small>${activity.audioStatus === "ready" ? "صدای آماده" : "پخش آزمایشی از متن ثبت‌شده"}</small>`;
    const button = document.createElement("button");
    button.type = "button";
    button.className = "secondary-btn";
    button.textContent = "🔊 پخش صدا";
    const status = document.createElement("div");
    status.className = "ext-muted";
    status.textContent = "برای شروع، صدا را پخش کن.";
    button.addEventListener("click", () => playActivityAudio(activity, button, status));
    panel.append(copy, button);
    body.append(panel, status);
    if (revealTarget && getAudioText(activity)) appendTarget(body, getAudioText(activity), "ext-target");
    return { button, status };
  }

  function renderListenChoose(activity, complete, alreadyDone) {
    const body = document.querySelector("#activityBody");
    renderCommonContext(activity, body);
    const { status } = audioPanel(activity, body);
    const options = document.createElement("div");
    options.className = "ext-choice-grid";
    const list = activity.data?.options || [];
    list.forEach((option, index) => {
      options.append(renderOptionButton(option, index, options, activity.data?.answer,
        () => {
          finish(complete, "درسته! چیزی که شنیدی با این گزینه تطبیق داشت.");
          const target = getAudioText(activity);
          if (target) {
            status.textContent = "متن شنیده‌شده:";
            appendTarget(body, target, "ext-target");
          }
        },
        () => feedback("این گزینه با چیزی که شنیدی جور نیست؛ دوباره پخش کن.", "bad")));
    });
    body.append(options);
    if (alreadyDone) feedback("این تمرین شنیداری قبلاً انجام شده؛ برای مرور دوباره پخشش کن.", "good");
  }

  function speechCheck(expected, complete, result, button, { requirePass = true } = {}) {
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SpeechRecognition) {
      result.textContent = "تشخیص گفتار در این مرورگر فعال نیست؛ از دکمهٔ «تمرین کردم» استفاده کن.";
      return;
    }
    if (!expected) {
      result.textContent = "متن هدف برای بررسی تلفظ ثبت نشده است.";
      return;
    }
    const recognition = new SpeechRecognition();
    recognition.lang = state?.languageCode === "de" ? "de-DE" : state?.languageCode || "de-DE";
    recognition.interimResults = false;
    recognition.maxAlternatives = 1;
    button.disabled = true;
    button.textContent = "دارم گوش می‌دم…";
    result.textContent = "عبارت را بگو.";
    recognition.onresult = (event) => {
      const actual = event.results?.[0]?.[0]?.transcript || "";
      const score = typeof speechSimilarity === "function" ? speechSimilarity(actual, expected) : (normalizeAnswer(actual) === normalizeAnswer(expected) ? 1 : 0);
      if (score >= 0.72) {
        result.textContent = `شنیدم: «${actual}» — خوب بود.`;
        result.className = "ext-speech-result ext-success";
        finish(complete, "تلفظت قابل قبول بود؛ می‌تونی ادامه بدی.");
      } else {
        result.textContent = `شنیدم: «${actual}» — با عبارت هدف مقایسه کن و دوباره امتحان کن.`;
        result.className = "ext-speech-result ext-danger";
        if (!requirePass) complete();
      }
    };
    recognition.onerror = () => {
      result.textContent = "تشخیص صدا انجام نشد. دوباره امتحان کن یا تمرین را دستی ثبت کن.";
      result.className = "ext-speech-result";
    };
    recognition.onend = () => {
      button.disabled = false;
      button.textContent = "🎙 دوباره بررسی کن";
    };
    recognition.start();
  }

  function renderSpeakingPractice(activity, complete, alreadyDone, mode) {
    const body = document.querySelector("#activityBody");
    renderCommonContext(activity, body);
    const expected = getAudioText(activity) || faText(activity.data?.answer, activity.data?.targetText, activity.data?.sourceText);
    if (mode === "listen_repeat") audioPanel(activity, body);
    if (expected) appendTarget(body, expected, "ext-target");

    const controls = document.createElement("div");
    controls.className = "ext-row";
    const check = document.createElement("button");
    check.type = "button";
    check.className = "primary-btn";
    check.textContent = "🎙 تلفظم را بررسی کن";
    const practiced = document.createElement("button");
    practiced.type = "button";
    practiced.className = "secondary-btn";
    practiced.textContent = "تمرین کردم";
    const result = document.createElement("div");
    result.className = "ext-speech-result";
    result.textContent = mode === "listen_repeat" ? "صدا را گوش کن و همان عبارت را تکرار کن." : "عبارت روی صفحه را با صدای بلند بخوان.";
    check.addEventListener("click", () => speechCheck(expected, complete, result, check));
    practiced.addEventListener("click", () => {
      practiced.disabled = true;
      practiced.textContent = "انجام شد ✓";
      finish(complete, "تمرین تلفظ ثبت شد.");
    });
    controls.append(check, practiced);
    body.append(controls, result);
    if (alreadyDone) feedback("این تمرین قبلاً انجام شده؛ می‌تونی دوباره تلفظت را بررسی کنی.", "good");
  }

  function renderFillBlank(activity, complete, alreadyDone) {
    const body = document.querySelector("#activityBody");
    const data = activity.data || {};
    renderCommonContext(activity, body);
    const blanked = faText(data.blankedText, data.promptTarget, data.sourceText);
    if (blanked) appendTarget(body, blanked, "ext-blank");
    const answer = data.answer ?? data.correctAnswer ?? (Array.isArray(data.answers) ? data.answers[0] : "");

    const choices = data.choices || data.options || [];
    if (choices.length) {
      const row = document.createElement("div");
      row.className = "ext-row";
      choices.forEach((choice) => {
        const value = typeof choice === "object" ? faText(choice.value, choice.textTarget, choice.text, choice.textFa) : String(choice);
        const button = document.createElement("button");
        button.type = "button";
        button.className = "ext-chip";
        button.textContent = persianTextOf(choice) || value;
        button.addEventListener("click", () => {
          if (normalizeAnswer(value) === normalizeAnswer(answer)) {
            button.classList.add("correct");
            finish(complete, "درسته؛ جای خالی درست کامل شد.");
          } else {
            button.classList.add("wrong");
            feedback("این گزینه درست نیست.", "bad");
            setTimeout(() => button.classList.remove("wrong"), 650);
          }
        });
        row.append(button);
      });
      body.append(row);
    }

    const input = document.createElement("input");
    input.className = "ext-input";
    input.dir = "ltr";
    input.placeholder = "پاسخ را بنویس";
    const check = document.createElement("button");
    check.type = "button";
    check.className = "primary-btn";
    check.textContent = "بررسی پاسخ";
    const checkTyped = () => {
      const accepted = Array.isArray(data.answers) ? data.answers : [answer];
      if (accepted.some((item) => normalizeAnswer(item) === normalizeAnswer(input.value))) finish(complete, "درسته؛ جمله کامل شد.");
      else feedback("پاسخ هنوز درست نیست؛ دوباره امتحان کن.", "bad");
    };
    check.addEventListener("click", checkTyped);
    input.addEventListener("keydown", (event) => { if (event.key === "Enter") checkTyped(); });
    const stack = document.createElement("div");
    stack.className = "ext-stack";
    stack.append(input, check);
    body.append(stack);
    if (alreadyDone) feedback("این جای‌خالی قبلاً حل شده؛ برای مرور دوباره امتحانش کن.", "good");
  }

  function shuffled(items) {
    const copy = [...items];
    for (let i = copy.length - 1; i > 0; i -= 1) {
      const j = Math.floor(Math.random() * (i + 1));
      [copy[i], copy[j]] = [copy[j], copy[i]];
    }
    return copy;
  }

  function renderMatching(activity, complete, alreadyDone) {
    const body = document.querySelector("#activityBody");
    renderCommonContext(activity, body);
    const pairs = (activity.data?.pairs || []).map((pair, index) => ({ ...pair, __id: index }));
    if (!pairs.length) return false;

    const grid = document.createElement("div");
    grid.className = "ext-match";
    const leftCol = document.createElement("div");
    const rightCol = document.createElement("div");
    leftCol.className = rightCol.className = "ext-match-col";
    leftCol.innerHTML = `<div class="ext-match-title">عبارت</div>`;
    rightCol.innerHTML = `<div class="ext-match-title">پاسخ مناسب</div>`;
    let leftSelected = null;
    let rightSelected = null;
    const matched = new Set();

    const tryMatch = () => {
      if (!leftSelected || !rightSelected) return;
      if (leftSelected.dataset.id === rightSelected.dataset.id) {
        matched.add(leftSelected.dataset.id);
        [leftSelected, rightSelected].forEach((node) => {
          node.classList.remove("selected");
          node.classList.add("matched");
          node.disabled = true;
        });
        feedback("جفت درست پیدا شد.", "good");
        leftSelected = rightSelected = null;
        if (matched.size === pairs.length) finish(complete, "همهٔ جفت‌ها درست وصل شدند.");
      } else {
        const a = leftSelected;
        const b = rightSelected;
        a.classList.add("wrong");
        b.classList.add("wrong");
        feedback("این دو با هم جفت نیستند؛ دوباره امتحان کن.", "bad");
        leftSelected = rightSelected = null;
        setTimeout(() => {
          [a, b].forEach((node) => node.classList.remove("wrong", "selected"));
        }, 650);
      }
    };

    const makeCard = (pair, side) => {
      const button = document.createElement("button");
      button.type = "button";
      button.className = "ext-match-card";
      button.dataset.id = String(pair.__id);
      const text = pair[side] || "";
      if (typeof makeTargetText === "function") button.append(makeTargetText(text));
      else button.textContent = text;
      button.addEventListener("click", () => {
        const current = side === "left" ? leftSelected : rightSelected;
        if (current) current.classList.remove("selected");
        button.classList.add("selected");
        if (side === "left") leftSelected = button;
        else rightSelected = button;
        tryMatch();
      });
      return button;
    };

    shuffled(pairs).forEach((pair) => leftCol.append(makeCard(pair, "left")));
    shuffled(pairs).forEach((pair) => rightCol.append(makeCard(pair, "right")));
    grid.append(leftCol, rightCol);
    body.append(grid);
    if (alreadyDone) feedback("این تطبیق قبلاً کامل شده؛ برای مرور می‌تونی دوباره انجامش بدی.", "good");
    return true;
  }

  function renderGrammarFocus(activity, complete, alreadyDone) {
    const body = document.querySelector("#activityBody");
    const data = activity.data || {};
    renderCommonContext(activity, body);
    appendPersian(body, faText(data.explanationFa, data.ruleFa, data.noteFa), "context-box");

    const examples = data.examples || data.exampleItems || [];
    examples.forEach((example) => {
      const box = document.createElement("div");
      box.className = "ext-example";
      const fa = persianTextOf(example);
      const target = targetTextOf(example);
      if (fa) {
        const faNode = document.createElement("div");
        faNode.className = "ext-example-fa";
        faNode.textContent = fa;
        box.append(faNode);
      }
      if (target) {
        const targetNode = document.createElement("div");
        targetNode.className = "ext-example-target";
        if (typeof makeTargetText === "function") targetNode.append(makeTargetText(target));
        else targetNode.textContent = target;
        box.append(targetNode);
      }
      body.append(box);
    });

    const singleTarget = faText(data.exampleTarget, data.sourceText);
    if (singleTarget) appendTarget(body, singleTarget, "ext-target");
    const done = document.createElement("button");
    done.type = "button";
    done.className = "primary-btn";
    done.textContent = "متوجه شدم";
    done.addEventListener("click", () => finish(complete, "نکتهٔ دستوری مرور شد."));
    body.append(done);
    if (alreadyDone) feedback("این نکته قبلاً مرور شده.", "good");
  }

  function renderTrueFalse(activity, complete, alreadyDone) {
    const body = document.querySelector("#activityBody");
    const data = activity.data || {};
    renderCommonContext(activity, body);
    appendPersian(body, faText(data.statementFa, data.questionFa), "context-box");
    const target = faText(data.statementTarget, data.textTarget, data.sourceText);
    if (target) appendTarget(body, target, "ext-target");
    let correct = data.correct ?? data.answer ?? data.correctAnswer;
    if (typeof correct === "string") correct = correct.toLowerCase() === "true" || correct === "درست";
    correct = !!correct;

    const row = document.createElement("div");
    row.className = "ext-row";
    [[true, "درست"], [false, "غلط"]].forEach(([value, label]) => {
      const button = document.createElement("button");
      button.type = "button";
      button.className = "ext-option";
      button.textContent = label;
      button.addEventListener("click", () => {
        if (value === correct) {
          button.classList.add("good");
          finish(complete, "درسته.");
        } else {
          button.classList.add("bad");
          feedback("این پاسخ درست نیست.", "bad");
          setTimeout(() => button.classList.remove("bad"), 650);
        }
      });
      row.append(button);
    });
    body.append(row);
    if (alreadyDone) feedback("این تمرین قبلاً انجام شده.", "good");
  }

  function renderComprehension(activity, complete, alreadyDone) {
    const body = document.querySelector("#activityBody");
    const data = activity.data || {};
    renderCommonContext(activity, body);
    if (data.passageFa) appendPersian(body, data.passageFa, "context-box");
    if (data.passageTarget) appendTarget(body, data.passageTarget, "ext-target");
    const questions = data.questions?.length ? data.questions : [data];
    let index = 0;
    const host = document.createElement("div");
    host.className = "ext-stack";
    body.append(host);

    const draw = () => {
      const q = questions[index] || {};
      host.innerHTML = "";
      const progress = document.createElement("div");
      progress.className = "ext-progress";
      progress.innerHTML = `<span>سؤال ${index + 1}</span><span>${index + 1} از ${questions.length}</span>`;
      host.append(progress);
      appendPersian(host, faText(q.questionFa, q.promptFa, q.textFa), "context-box");
      const qTarget = faText(q.questionTarget, q.promptTarget, q.textTarget);
      if (qTarget) appendTarget(host, qTarget, "ext-target");
      const options = document.createElement("div");
      options.className = "ext-choice-grid";
      const list = q.options || [];
      const answer = q.answer ?? q.correctAnswer;
      list.forEach((option, optionIndex) => {
        options.append(renderOptionButton(option, optionIndex, options, answer,
          () => {
            if (index < questions.length - 1) {
              feedback("درسته؛ بریم سؤال بعدی.", "good");
              setTimeout(() => { index += 1; draw(); }, 350);
            } else {
              finish(complete, "همهٔ سؤال‌های درک مطلب درست پاسخ داده شدند.");
            }
          },
          () => feedback("یک بار دیگر متن را بررسی کن.", "bad")));
      });
      host.append(options);
      if (!list.length) {
        const manual = document.createElement("button");
        manual.type = "button";
        manual.className = "primary-btn";
        manual.textContent = index < questions.length - 1 ? "سؤال بعدی" : "تمام شد";
        manual.onclick = () => index < questions.length - 1 ? (index += 1, draw()) : finish(complete, "مرور درک مطلب ثبت شد.");
        host.append(manual);
      }
    };
    draw();
    if (alreadyDone) feedback("این درک مطلب قبلاً کامل شده؛ برای مرور دوباره پاسخ بده.", "good");
  }

  function renderReview(activity, complete, alreadyDone) {
    const body = document.querySelector("#activityBody");
    const data = activity.data || {};
    renderCommonContext(activity, body);
    const fields = data.fields || [];
    if (!fields.length) {
      const done = document.createElement("button");
      done.type = "button";
      done.className = "primary-btn";
      done.textContent = "مرور کردم";
      done.onclick = () => finish(complete, "مرور ثبت شد.");
      body.append(done);
      return;
    }

    const form = document.createElement("form");
    form.className = "ext-form";
    const inputs = [];
    fields.forEach((field, index) => {
      const wrap = document.createElement("div");
      wrap.className = "ext-field";
      const label = document.createElement("label");
      label.textContent = field.labelFa || `مورد ${index + 1}`;
      wrap.append(label);
      if (field.instructionFa) {
        const help = document.createElement("small");
        help.textContent = field.instructionFa;
        wrap.append(help);
      }
      if (field.patternTarget) appendTarget(wrap, field.patternTarget, "ext-target");
      if (field.exampleSourceText) {
        const example = document.createElement("div");
        example.className = "ext-example";
        example.innerHTML = `<div class="ext-muted">نمونه</div>`;
        appendTarget(example, field.exampleSourceText, "ext-example-target");
        wrap.append(example);
      }
      const input = document.createElement("input");
      input.className = "ext-input";
      input.dir = "auto";
      input.placeholder = field.labelFa ? `${field.labelFa} را وارد کن` : "پاسخ را وارد کن";
      const optional = field.optional === true || /اگر می‌خواهی|اختیاری/.test(field.instructionFa || "");
      inputs.push({ input, optional, label: field.labelFa || `مورد ${index + 1}` });
      wrap.append(input);
      form.append(wrap);
    });
    const submit = document.createElement("button");
    submit.type = "submit";
    submit.className = "primary-btn";
    submit.textContent = "ثبت تمرین";
    form.append(submit);
    form.addEventListener("submit", (event) => {
      event.preventDefault();
      const missing = inputs.find(({ input, optional }) => !optional && !input.value.trim());
      if (missing) {
        missing.input.focus();
        feedback(`«${missing.label}» را برای ادامه کامل کن.`, "bad");
        return;
      }
      finish(complete, "فرم تمرینی کامل شد. اطلاعات فقط داخل همین مرورگر استفاده می‌شود.");
    });
    body.append(form);
    if (alreadyDone) feedback("این مرور قبلاً ثبت شده؛ برای تمرین می‌تونی دوباره فرم را پر کنی.", "good");
  }

  function renderExtended(activity, complete, alreadyDone) {
    switch (activity.type) {
      case "listen_choose": return renderListenChoose(activity, complete, alreadyDone), true;
      case "listen_repeat": return renderSpeakingPractice(activity, complete, alreadyDone, "listen_repeat"), true;
      case "pronunciation_read": return renderSpeakingPractice(activity, complete, alreadyDone, "pronunciation_read"), true;
      case "fill_blank": return renderFillBlank(activity, complete, alreadyDone), true;
      case "matching": return renderMatching(activity, complete, alreadyDone);
      case "grammar_focus": return renderGrammarFocus(activity, complete, alreadyDone), true;
      case "comprehension": return renderComprehension(activity, complete, alreadyDone), true;
      case "true_false": return renderTrueFalse(activity, complete, alreadyDone), true;
      case "review": return renderReview(activity, complete, alreadyDone), true;
      default: return false;
    }
  }

  window.renderUnknownActivity = function(activity, complete, alreadyDone) {
    if (renderExtended(activity, complete, alreadyDone)) return;
    if (typeof oldUnknown === "function") oldUnknown(activity, complete, alreadyDone);
  };
})();
