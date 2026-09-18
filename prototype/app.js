const $ = (selector, root = document) => root.querySelector(selector);
const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];

const state = {
  languages: [],
  languageCode: "de",
  bundle: null,
  currentLevel: null,
  currentLesson: null,
  activityIndex: 0,
  terms: [],
};

const progressKey = () => `nova-prototype-progress:${state.languageCode}`;

function loadProgress() {
  try {
    return JSON.parse(localStorage.getItem(progressKey())) || { lessons: {} };
  } catch {
    return { lessons: {} };
  }
}

function saveProgress(progress) {
  localStorage.setItem(progressKey(), JSON.stringify(progress));
}

function lessonProgress(lessonId) {
  return loadProgress().lessons?.[lessonId] || { completed: false, activities: {} };
}

function markActivity(lessonId, activityId) {
  const progress = loadProgress();
  progress.lessons ||= {};
  progress.lessons[lessonId] ||= { completed: false, activities: {} };
  progress.lessons[lessonId].activities ||= {};
  progress.lessons[lessonId].activities[activityId] = true;
  saveProgress(progress);
}

function markLessonComplete(lessonId) {
  const progress = loadProgress();
  progress.lessons ||= {};
  progress.lessons[lessonId] ||= { completed: false, activities: {} };
  progress.lessons[lessonId].completed = true;
  saveProgress(progress);
}

function escapeHtml(value = "") {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function faNumber(value) {
  return new Intl.NumberFormat("fa-IR").format(value);
}

function showToast(message) {
  const toast = $("#toast");
  toast.textContent = message;
  toast.classList.add("show");
  clearTimeout(showToast.timer);
  showToast.timer = setTimeout(() => toast.classList.remove("show"), 1900);
}

function buildTerms() {
  const byKey = new Map();
  const lexemes = state.bundle?.lexemes || {};
  const forms = state.bundle?.lexemeForms || {};

  Object.values(lexemes).forEach((lexeme) => {
    [lexeme.surface, lexeme.lemma].filter(Boolean).forEach((surface) => {
      const key = surface.toLocaleLowerCase("de-DE");
      if (!byKey.has(key)) byKey.set(key, { surface, lexemeId: lexeme.id, formId: null });
    });
  });

  Object.values(forms).forEach((form) => {
    if (!form.surface || !form.lexemeId) return;
    const key = form.surface.toLocaleLowerCase("de-DE");
    byKey.set(key, { surface: form.surface, lexemeId: form.lexemeId, formId: form.id });
  });

  state.terms = [...byKey.values()].sort((a, b) => b.surface.length - a.surface.length);
}

function isLetter(char) {
  return !!char && /\p{L}/u.test(char);
}

function validBoundary(text, start, length) {
  const before = text[start - 1];
  const after = text[start + length];
  return !isLetter(before) && !isLetter(after);
}

function makeTargetText(text, explicit = null) {
  const root = document.createElement("span");
  root.className = "target-text";
  const source = String(text || "");
  const lower = source.toLocaleLowerCase("de-DE");
  let cursor = 0;

  while (cursor < source.length) {
    let best = null;
    for (const term of state.terms) {
      const needle = term.surface.toLocaleLowerCase("de-DE");
      let index = lower.indexOf(needle, cursor);
      while (index !== -1 && !validBoundary(source, index, needle.length)) {
        index = lower.indexOf(needle, index + 1);
      }
      if (index === -1) continue;
      if (!best || index < best.index || (index === best.index && needle.length > best.length)) {
        best = { ...term, index, length: needle.length };
      }
    }

    if (!best) {
      root.append(document.createTextNode(source.slice(cursor)));
      break;
    }

    if (best.index > cursor) root.append(document.createTextNode(source.slice(cursor, best.index)));
    const button = document.createElement("button");
    button.type = "button";
    button.className = "lexeme-link";
    button.textContent = source.slice(best.index, best.index + best.length);
    button.dataset.lexemeId = best.lexemeId;
    if (best.formId) button.dataset.formId = best.formId;
    button.addEventListener("click", (event) => {
      event.preventDefault();
      event.stopPropagation();
      openLexeme(best.lexemeId, best.formId);
    });
    root.append(button);
    cursor = best.index + best.length;
  }

  if (!source) root.textContent = "";
  return root;
}

function partOfSpeechFa(value) {
  const map = {
    verb: "فعل",
    noun: "اسم",
    adjective: "صفت",
    adverb: "قید",
    phrase: "عبارت",
    particle: "ذره / واژهٔ نقشی",
    interjection: "حرف ندا",
  };
  return map[value] || value || "—";
}

function featureFa(key, value) {
  const keys = { tense: "زمان", mood: "وجه", person: "شخص", number: "شمار", case: "حالت", gender: "جنس" };
  const values = {
    present: "حال", indicative: "اخباری", singular: "مفرد", plural: "جمع",
    "1": "اول", "2": "دوم", "3": "سوم",
  };
  return `${keys[key] || key}: ${values[value] || value}`;
}

function openLexeme(lexemeId, formId = null) {
  const lexeme = state.bundle?.lexemes?.[lexemeId];
  if (!lexeme) return;
  const selectedForm = formId ? state.bundle?.lexemeForms?.[formId] : null;
  const forms = Object.values(state.bundle?.lexemeForms || {}).filter((form) => form.lexemeId === lexemeId);
  const content = $("#modalContent");

  content.innerHTML = `
    <div class="lexeme-head">
      <div class="eyebrow">${selectedForm ? "شکل صرف‌شده" : lexeme.type === "phrase" ? "عبارت" : "واژه"}</div>
      <h2 id="modalTitle" class="lexeme-surface">${escapeHtml(selectedForm?.surface || lexeme.surface || lexeme.lemma || "")}</h2>
      <div class="lexeme-translation">${escapeHtml(lexeme.translationFa || "بدون ترجمه")}</div>
    </div>
    <div class="lexeme-grid">
      <div class="detail"><small>شکل پایه</small><strong dir="ltr">${escapeHtml(lexeme.lemma || lexeme.surface || "—")}</strong></div>
      <div class="detail"><small>نوع</small><strong>${escapeHtml(partOfSpeechFa(lexeme.partOfSpeech || lexeme.type))}</strong></div>
      ${selectedForm ? `<div class="detail"><small>نوع فرم</small><strong>${escapeHtml(selectedForm.formType || "—")}</strong></div>` : ""}
      ${lexeme.level ? `<div class="detail"><small>سطح</small><strong>${escapeHtml(lexeme.level)}</strong></div>` : ""}
    </div>
    ${lexeme.usageNoteFa ? `<div class="context-box" style="margin-top:18px">${escapeHtml(lexeme.usageNoteFa)}</div>` : ""}
    ${selectedForm?.notes ? `<div class="context-box" style="margin-top:18px">${escapeHtml(selectedForm.notes)}</div>` : ""}
    ${selectedForm?.features && Object.keys(selectedForm.features).length ? `<div class="feature-chips">${Object.entries(selectedForm.features).map(([key, value]) => `<span class="feature-chip">${escapeHtml(featureFa(key, value))}</span>`).join("")}</div>` : ""}
    ${forms.length ? `
      <div class="forms">
        <h3>شکل‌های ثبت‌شده</h3>
        ${forms.map((form) => `
          <div class="form-row">
            <div class="form-surface">${escapeHtml(form.surface)}</div>
            <div class="feature-chips">${Object.entries(form.features || {}).map(([key, value]) => `<span class="feature-chip">${escapeHtml(featureFa(key, value))}</span>`).join("")}</div>
          </div>
        `).join("")}
      </div>` : ""}
  `;

  const modal = $("#lexemeModal");
  modal.classList.add("open");
  modal.setAttribute("aria-hidden", "false");
}

function closeModal() {
  const modal = $("#lexemeModal");
  modal.classList.remove("open");
  modal.setAttribute("aria-hidden", "true");
}

function flattenLessons() {
  const rows = [];
  (state.bundle?.levels || []).forEach((level) => {
    level.units.forEach((unitGroup) => {
      unitGroup.lessons.forEach((lesson) => rows.push({ level, unit: unitGroup.unit, lesson }));
    });
  });
  return rows;
}

function renderHome() {
  state.currentLesson = null;
  state.currentLevel = null;
  const main = $("#main");
  const bundle = state.bundle;
  if (!bundle) return;
  const allLessons = flattenLessons();
  const doneCount = allLessons.filter(({ lesson }) => lessonProgress(lesson.id).completed).length;
  const activityCount = allLessons.reduce((sum, row) => sum + (row.lesson.activities?.length || 0), 0);

  main.innerHTML = `
    <section class="hero">
      <div class="hero-card">
        <div class="eyebrow">${escapeHtml(bundle.language.nameNative || bundle.language.code)} · ${escapeHtml(bundle.language.status || "")}</div>
        <h1>${escapeHtml(bundle.language.nameFa || bundle.language.nameNative || "زبان")}</h1>
        <p>این نسخه مستقیماً محتوای فعلی مخزن را می‌خواند. تعداد یونیت، درس و اکتیویتی ثابت نیست و هر چیزی که در ساختار محتوا اضافه شود در اینجا نمایش داده می‌شود.</p>
      </div>
      <div class="summary-card">
        <div class="metric"><strong>${faNumber(bundle.levels.length)}</strong><span>سطح</span></div>
        <div class="metric"><strong>${faNumber(allLessons.length)}</strong><span>درس</span></div>
        <div class="metric"><strong>${faNumber(activityCount)}</strong><span>اکتیویتی</span></div>
      </div>
    </section>
    <div class="section-head">
      <div><h2>مسیر یادگیری</h2><p>${faNumber(doneCount)} از ${faNumber(allLessons.length)} درس کامل شده</p></div>
    </div>
    <div id="levels"></div>
  `;

  const levelsRoot = $("#levels", main);
  bundle.levels.forEach((level) => {
    const section = document.createElement("section");
    section.className = "level-section";
    section.innerHTML = `
      <div class="section-head">
        <div><span class="eyebrow">${escapeHtml(level.manifest.level || level.manifest.id)}</span><h2>${escapeHtml(level.manifest.level || "")}</h2></div>
        <p>${escapeHtml(level.manifest.status || "")}</p>
      </div>
    `;

    level.units.forEach((group, unitIndex) => {
      const card = document.createElement("article");
      card.className = "unit-card";
      card.innerHTML = `
        <div class="unit-title">
          <span class="unit-index">${faNumber(unitIndex + 1)}</span>
          <div><h3 style="margin:0">${escapeHtml(group.unit.titleFa || group.unit.id)}</h3></div>
        </div>
        <div class="lesson-list"></div>
      `;
      const list = $(".lesson-list", card);
      group.lessons.forEach((lesson, lessonIndex) => {
        const info = lessonProgress(lesson.id);
        const row = document.createElement("button");
        row.type = "button";
        row.className = `lesson-row ${info.completed ? "done" : ""}`;
        row.innerHTML = `
          <span class="lesson-status">${info.completed ? "✓" : faNumber(lessonIndex + 1)}</span>
          <span class="lesson-copy"><strong>${escapeHtml(lesson.titleFa || lesson.id)}</strong><small>${escapeHtml(lesson.sourceTitle || "")}</small></span>
          <span class="lesson-count">${faNumber(lesson.activities?.length || 0)} اکتیویتی</span>
        `;
        row.addEventListener("click", () => openLesson(level, lesson));
        list.append(row);
      });
      section.append(card);
    });
    levelsRoot.append(section);
  });

  if (!allLessons.length) {
    levelsRoot.innerHTML = `<div class="empty-state">هنوز در این زبان درسی برای نمایش وجود ندارد.</div>`;
  }
}

function openLesson(level, lesson) {
  state.currentLevel = level;
  state.currentLesson = lesson;
  const stored = lessonProgress(lesson.id);
  const firstIncomplete = (lesson.activities || []).findIndex((activity) => !stored.activities?.[activity.id]);
  state.activityIndex = firstIncomplete === -1 ? 0 : firstIncomplete;
  renderLesson();
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function activityLabel(type) {
  const map = {
    conversation_speaking: "مکالمه و گفتن",
    multiple_choice: "چندگزینه‌ای",
    choose_response: "انتخاب پاسخ",
    word_order: "چیدن کلمات",
  };
  return map[type] || type.replaceAll("_", " ");
}

function renderLesson() {
  const lesson = state.currentLesson;
  if (!lesson) return renderHome();
  const total = lesson.activities?.length || 0;
  const main = $("#main");
  const percent = total ? Math.min(100, (state.activityIndex / total) * 100) : 100;
  const lessonJson = JSON.stringify(lesson, null, 2);

  main.innerHTML = `
    <div class="lesson-layout">
      <aside class="lesson-sidebar">
        <button class="back-btn" id="backToLessons" type="button">→ برگشت به درس‌ها</button>
        <div class="eyebrow">${escapeHtml(lesson.level || state.currentLevel?.manifest?.level || "")}</div>
        <h2>${escapeHtml(lesson.titleFa || lesson.id)}</h2>
        <div class="source-title">${escapeHtml(lesson.sourceTitle || "")}</div>
        <div class="progress-track"><div class="progress-fill" style="width:${percent}%"></div></div>
        <div class="progress-label"><span>پیشرفت</span><span>${faNumber(Math.min(state.activityIndex, total))}/${faNumber(total)}</span></div>
        ${lesson.learningTargets?.length ? `<ul class="target-list">${lesson.learningTargets.map((target) => `<li>${escapeHtml(target)}</li>`).join("")}</ul>` : ""}
      </aside>
      <section id="activityRoot"></section>
    </div>
    <details class="lesson-json-panel">
      <summary>مشاهده JSON درس</summary>
      <div class="lesson-json-toolbar">
        <span>دادهٔ خام همین درس</span>
        <button id="copyLessonJson" class="secondary-btn" type="button">کپی JSON</button>
      </div>
      <pre class="lesson-json-code" dir="ltr">${escapeHtml(lessonJson)}</pre>
    </details>
  `;
  $("#backToLessons").addEventListener("click", renderHome);
  $("#copyLessonJson")?.addEventListener("click", async () => {
    try {
      await navigator.clipboard.writeText(lessonJson);
      showToast("JSON درس کپی شد.");
    } catch {
      const textarea = document.createElement("textarea");
      textarea.value = lessonJson;
      textarea.style.position = "fixed";
      textarea.style.opacity = "0";
      document.body.append(textarea);
      textarea.select();
      document.execCommand("copy");
      textarea.remove();
      showToast("JSON درس کپی شد.");
    }
  });
  renderCurrentActivity();
}

function renderCurrentActivity() {
  const lesson = state.currentLesson;
  const activities = lesson.activities || [];
  if (state.activityIndex >= activities.length) return renderLessonFinish();

  const activity = activities[state.activityIndex];
  const root = $("#activityRoot");
  root.innerHTML = `
    <article class="activity-card">
      <div class="activity-top">
        <span class="activity-type">${escapeHtml(activityLabel(activity.type))}</span>
        <span class="activity-number">${faNumber(state.activityIndex + 1)} از ${faNumber(activities.length)}</span>
      </div>
      <h2 class="instruction">${escapeHtml(activity.instructionFa || "")}</h2>
      <div id="activityBody" class="activity-body"></div>
      <div id="activityFeedback" class="feedback"></div>
      <div class="activity-actions">
        <button id="prevActivity" class="secondary-btn" type="button" ${state.activityIndex === 0 ? "disabled" : ""}>قبلی</button>
        <button id="nextActivity" class="primary-btn" type="button">${state.activityIndex === activities.length - 1 ? "پایان درس" : "ادامه"}</button>
      </div>
    </article>
  `;

  const alreadyDone = !!lessonProgress(lesson.id).activities?.[activity.id];
  const next = $("#nextActivity");
  next.disabled = !alreadyDone;
  $("#prevActivity").addEventListener("click", () => {
    if (state.activityIndex > 0) {
      state.activityIndex -= 1;
      renderLesson();
    }
  });
  next.addEventListener("click", () => {
    state.activityIndex += 1;
    renderLesson();
    window.scrollTo({ top: 0, behavior: "smooth" });
  });

  const complete = () => {
    markActivity(lesson.id, activity.id);
    next.disabled = false;
  };

  switch (activity.type) {
    case "conversation_speaking":
      renderConversation(activity, complete);
      break;
    case "multiple_choice":
    case "choose_response":
      renderChoice(activity, complete, alreadyDone);
      break;
    case "word_order":
      renderWordOrder(activity, complete, alreadyDone);
      break;
    default:
      renderUnknownActivity(activity, complete, alreadyDone);
  }
}

function setFeedback(message, kind) {
  const box = $("#activityFeedback");
  box.textContent = message;
  box.className = `feedback show ${kind}`;
}

function renderConversation(activity, complete) {
  const body = $("#activityBody");
  const dialogue = state.currentLevel?.dialogues?.[activity.dialogueRef];
  if (activity.data?.contextFa) {
    const context = document.createElement("div");
    context.className = "context-box";
    context.textContent = activity.data.contextFa;
    body.append(context);
  }

  if (!dialogue) {
    body.innerHTML += `<div class="empty-state">Dialogue پیدا نشد: ${escapeHtml(activity.dialogueRef || "—")}</div>`;
    return renderReviewButton(body, complete);
  }

  const conversation = document.createElement("div");
  conversation.className = "conversation";
  const learnerTurns = [];

  dialogue.turns?.forEach((turn) => {
    const character = state.bundle.characters?.[turn.speakerCharacterId];
    const isLearner = !!turn.learnerTurn;
    if (isLearner) learnerTurns.push(turn);
    const row = document.createElement("div");
    row.className = `turn ${isLearner ? "learner" : ""}`;
    const initial = isLearner ? "تو" : (character?.name || "?").slice(0, 1).toUpperCase();
    row.innerHTML = `<div class="avatar">${escapeHtml(initial)}</div><div class="bubble"><span class="speaker">${escapeHtml(isLearner ? "نوبت تو" : character?.name || turn.speakerCharacterId || "")}</span><div class="bubble-target"></div>${turn.translationFa ? `<div class="translation">${escapeHtml(turn.translationFa)}</div>` : ""}</div>`;
    $(".bubble-target", row).append(makeTargetText(turn.textTarget));
    conversation.append(row);
  });
  body.append(conversation);

  if (learnerTurns.length) {
    const tools = document.createElement("div");
    tools.className = "speaking-tools";
    const speechButton = document.createElement("button");
    speechButton.type = "button";
    speechButton.className = "secondary-btn";
    speechButton.textContent = "🎙 گفتنم را بررسی کن";
    const practicedButton = document.createElement("button");
    practicedButton.type = "button";
    practicedButton.className = "primary-btn";
    practicedButton.textContent = "تمرین کردم";
    const result = document.createElement("div");
    result.className = "recognition-result";
    result.textContent = "می‌توانی عبارت نوبت خودت را با صدای بلند بخوانی.";

    speechButton.addEventListener("click", () => startSpeechCheck(learnerTurns[0].textTarget, speechButton, result));
    practicedButton.addEventListener("click", () => {
      complete();
      practicedButton.textContent = "انجام شد ✓";
      practicedButton.disabled = true;
      setFeedback("تمرین مکالمه ثبت شد. می‌تونی ادامه بدی.", "good");
    });
    tools.append(speechButton, practicedButton, result);
    body.append(tools);
  } else {
    renderReviewButton(body, complete);
  }
}

function normalizeSpeech(text) {
  return String(text || "").toLocaleLowerCase("de-DE").replace(/[^\p{L}\p{N}\s]/gu, "").replace(/\s+/g, " ").trim();
}

function levenshtein(a, b) {
  const rows = Array.from({ length: b.length + 1 }, (_, i) => [i]);
  rows[0] = Array.from({ length: a.length + 1 }, (_, i) => i);
  for (let i = 1; i <= b.length; i += 1) {
    for (let j = 1; j <= a.length; j += 1) {
      rows[i][j] = b[i - 1] === a[j - 1]
        ? rows[i - 1][j - 1]
        : Math.min(rows[i - 1][j - 1] + 1, rows[i][j - 1] + 1, rows[i - 1][j] + 1);
    }
  }
  return rows[b.length][a.length];
}

function speechSimilarity(actual, expected) {
  const a = normalizeSpeech(actual);
  const b = normalizeSpeech(expected);
  if (!a || !b) return 0;
  return 1 - (levenshtein(a, b) / Math.max(a.length, b.length));
}

function startSpeechCheck(expected, button, result) {
  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (!SpeechRecognition) {
    result.textContent = "مرورگر Speech Recognition را پشتیبانی نمی‌کند؛ از دکمه «تمرین کردم» استفاده کن.";
    return;
  }
  const recognition = new SpeechRecognition();
  recognition.lang = "de-DE";
  recognition.interimResults = false;
  recognition.maxAlternatives = 1;
  button.disabled = true;
  button.textContent = "دارم گوش می‌دم…";
  result.textContent = "عبارت را بگو.";

  recognition.onresult = (event) => {
    const actual = event.results?.[0]?.[0]?.transcript || "";
    const score = speechSimilarity(actual, expected);
    result.textContent = score >= 0.72
      ? `شنیدم: “${actual}” — خوب بود.`
      : `شنیدم: “${actual}” — یک بار دیگر با عبارت روی صفحه مقایسه کن.`;
  };
  recognition.onerror = () => {
    result.textContent = "تشخیص صدا انجام نشد. می‌تونی دوباره امتحان کنی یا تمرین را دستی ثبت کنی.";
  };
  recognition.onend = () => {
    button.disabled = false;
    button.textContent = "🎙 دوباره بررسی کن";
  };
  recognition.start();
}

function renderChoice(activity, complete, alreadyDone) {
  const body = $("#activityBody");
  if (activity.data?.contextFa) {
    const context = document.createElement("div");
    context.className = "context-box";
    context.textContent = activity.data.contextFa;
    body.append(context);
  }
  if (activity.data?.promptFa) {
    const prompt = document.createElement("p");
    prompt.textContent = activity.data.promptFa;
    body.append(prompt);
  }
  if (activity.data?.promptTarget) {
    const prompt = document.createElement("div");
    prompt.style.cssText = "font-size:24px;font-weight:800;margin:18px 0";
    prompt.append(makeTargetText(activity.data.promptTarget));
    body.append(prompt);
  }

  const options = document.createElement("div");
  options.className = "options";
  (activity.data?.options || []).forEach((option) => {
    const row = document.createElement("div");
    row.className = "option";
    row.setAttribute("role", "button");
    row.setAttribute("tabindex", "0");
    const target = option.textTarget || option.textFa || option.text || "";
    row.append(makeTargetText(target));

    const choose = () => {
      if (option.correct) {
        row.classList.add("correct");
        complete();
        setFeedback("درسته! این پاسخ با موقعیت جور درمیاد.", "good");
        $$(".option", options).forEach((item) => item.style.pointerEvents = "none");
      } else {
        row.classList.add("wrong");
        setFeedback("این یکی نه. دوباره گزینه‌ها رو نگاه کن.", "bad");
        setTimeout(() => row.classList.remove("wrong"), 650);
      }
    };
    row.addEventListener("click", choose);
    row.addEventListener("keydown", (event) => {
      if (event.key === "Enter" || event.key === " ") choose();
    });
    options.append(row);
  });
  body.append(options);

  if (alreadyDone) setFeedback("این اکتیویتی قبلاً انجام شده؛ می‌تونی ادامه بدی یا دوباره امتحانش کنی.", "good");
}

function shuffled(items) {
  const copy = [...items];
  for (let i = copy.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  if (copy.length > 1 && copy.every((value, index) => value === items[index])) {
    [copy[0], copy[1]] = [copy[1], copy[0]];
  }
  return copy;
}

function tokenLexeme(activity, tokenText) {
  const mapping = (activity.data?.tokenLexemeMappings || []).find((item) => item.token === tokenText);
  if (mapping) return { lexemeId: mapping.lexemeId, formId: mapping.lexemeFormId || null };
  const normalized = tokenText.replace(/[^\p{L}]/gu, "").toLocaleLowerCase("de-DE");
  const term = state.terms.find((item) => item.surface.toLocaleLowerCase("de-DE") === normalized);
  return term ? { lexemeId: term.lexemeId, formId: term.formId } : null;
}

function renderWordOrder(activity, complete, alreadyDone) {
  const body = $("#activityBody");
  const source = activity.data?.tokens || [];
  const expected = activity.data?.answer || source;
  const tokens = shuffled(source.map((text, index) => ({ id: `${index}-${text}`, text })));
  const selected = [];

  const wrapper = document.createElement("div");
  wrapper.className = "word-order";
  wrapper.innerHTML = `<div class="answer-zone empty"></div><div class="token-bank"></div><div style="display:flex;gap:9px;flex-wrap:wrap"><button class="primary-btn check-order" type="button">بررسی</button><button class="secondary-btn reset-order" type="button">از نو</button></div>`;
  body.append(wrapper);
  const answerZone = $(".answer-zone", wrapper);
  const bank = $(".token-bank", wrapper);

  function tokenNode(token, selectedMode) {
    const node = document.createElement("div");
    node.className = `token ${selectedMode ? "selected" : ""}`;
    node.setAttribute("role", "button");
    node.setAttribute("tabindex", "0");
    node.append(document.createTextNode(token.text));
    const info = tokenLexeme(activity, token.text);
    if (info?.lexemeId) {
      const infoButton = document.createElement("button");
      infoButton.type = "button";
      infoButton.className = "token-info";
      infoButton.textContent = "i";
      infoButton.title = "توضیح واژه";
      infoButton.addEventListener("click", (event) => {
        event.stopPropagation();
        openLexeme(info.lexemeId, info.formId);
      });
      node.append(infoButton);
    }
    const move = () => {
      if (selectedMode) {
        const index = selected.findIndex((item) => item.id === token.id);
        if (index !== -1) selected.splice(index, 1);
      } else {
        selected.push(token);
      }
      draw();
    };
    node.addEventListener("click", move);
    node.addEventListener("keydown", (event) => {
      if (event.key === "Enter" || event.key === " ") move();
    });
    return node;
  }

  function draw() {
    answerZone.innerHTML = "";
    answerZone.classList.toggle("empty", selected.length === 0);
    selected.forEach((token) => answerZone.append(tokenNode(token, true)));
    bank.innerHTML = "";
    tokens.filter((token) => !selected.some((item) => item.id === token.id)).forEach((token) => bank.append(tokenNode(token, false)));
  }

  $(".check-order", wrapper).addEventListener("click", () => {
    const actual = selected.map((item) => item.text);
    const correct = actual.length === expected.length && actual.every((value, index) => value === expected[index]);
    if (correct) {
      complete();
      setFeedback("عالیه؛ ترتیب جمله درسته.", "good");
    } else {
      setFeedback("ترتیب هنوز درست نیست. کلمه‌ها رو جابه‌جا کن.", "bad");
    }
  });
  $(".reset-order", wrapper).addEventListener("click", () => {
    selected.splice(0, selected.length);
    draw();
  });
  draw();
  if (alreadyDone) setFeedback("این اکتیویتی قبلاً کامل شده؛ برای مرور می‌تونی دوباره جمله رو بچینی.", "good");
}

function renderReviewButton(body, complete) {
  const button = document.createElement("button");
  button.type = "button";
  button.className = "primary-btn";
  button.textContent = "دیدم و انجام دادم";
  button.addEventListener("click", () => {
    complete();
    button.disabled = true;
    button.textContent = "انجام شد ✓";
    setFeedback("ثبت شد. می‌تونی ادامه بدی.", "good");
  });
  body.append(button);
}

function renderUnknownActivity(activity, complete, alreadyDone) {
  const body = $("#activityBody");
  body.innerHTML = `<div class="empty-state"><h3>نوع جدید: ${escapeHtml(activity.type)}</h3><p>برای این نوع هنوز renderer اختصاصی نداریم. دادهٔ خام حذف نشده و می‌تونی فعلاً آن را به‌عنوان مرورشده ثبت کنی.</p><pre style="direction:ltr;text-align:left;white-space:pre-wrap">${escapeHtml(JSON.stringify(activity.data || {}, null, 2))}</pre></div>`;
  renderReviewButton(body, complete);
  if (alreadyDone) setFeedback("این اکتیویتی قبلاً مرور شده.", "good");
}

function renderLessonFinish() {
  const lesson = state.currentLesson;
  markLessonComplete(lesson.id);
  const root = $("#activityRoot");
  root.innerHTML = `
    <section class="lesson-finish">
      <div>
        <div class="finish-icon">✓</div>
        <div class="eyebrow">درس کامل شد</div>
        <h2 style="font-size:32px;margin:8px 0">${escapeHtml(lesson.titleFa || lesson.id)}</h2>
        <p style="color:#747b8d">همهٔ اکتیویتی‌های فعلی این درس رو گذروندی.</p>
        <button id="finishHome" class="primary-btn" type="button">برگشت به مسیر یادگیری</button>
      </div>
    </section>
  `;
  $("#finishHome").addEventListener("click", renderHome);
  const fill = $(".progress-fill");
  if (fill) fill.style.width = "100%";
  const label = $(".progress-label span:last-child");
  if (label) label.textContent = `${faNumber(lesson.activities?.length || 0)}/${faNumber(lesson.activities?.length || 0)}`;
}

async function loadContent(languageCode) {
  const main = $("#main");
  main.innerHTML = `<div class="empty-state">در حال خواندن محتوای ${escapeHtml(languageCode)}…</div>`;
  const response = await fetch(`/api/content?language=${encodeURIComponent(languageCode)}`, { cache: "no-store" });
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  state.bundle = await response.json();
  state.languageCode = languageCode;
  buildTerms();
  renderHome();
}

async function init() {
  $$('[data-close-modal]').forEach((node) => node.addEventListener("click", closeModal));
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") closeModal();
  });
  $("#homeBtn").addEventListener("click", renderHome);
  $("#resetBtn").addEventListener("click", () => {
    if (!confirm("پیشرفت ذخیره‌شدهٔ این زبان پاک شود؟")) return;
    localStorage.removeItem(progressKey());
    renderHome();
    showToast("پیشرفت پاک شد");
  });

  try {
    const response = await fetch("/api/languages", { cache: "no-store" });
    const payload = await response.json();
    state.languages = payload.languages || [];
    const select = $("#languageSelect");
    state.languages.forEach((language) => {
      const option = document.createElement("option");
      option.value = language.code || language.id;
      option.textContent = `${language.nameFa || language.nameNative} · ${language.nameNative || language.code}`;
      select.append(option);
    });
    if (state.languages.some((item) => (item.code || item.id) === "de")) select.value = "de";
    state.languageCode = select.value || state.languages[0]?.code || "de";
    select.addEventListener("change", async () => {
      try {
        await loadContent(select.value);
      } catch (error) {
        $("#main").innerHTML = `<div class="empty-state">خواندن محتوا ناموفق بود: ${escapeHtml(error.message)}</div>`;
      }
    });
    await loadContent(state.languageCode);
  } catch (error) {
    $("#main").innerHTML = `<div class="empty-state"><h2>پروتوتایپ نتونست محتوا رو بخونه</h2><p>${escapeHtml(error.message)}</p></div>`;
  }
}

init();
