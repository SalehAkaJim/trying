-- Frontend-safe Persian localization views
-- Raw taxonomy codes remain stable for API/database logic, but learner-facing UI
-- must render the paired *_fa label from these views rather than the raw code.

CREATE OR REPLACE VIEW v_frontend_lexemes AS
SELECT
  l.id,
  l.lexeme_key,
  l.language_id,
  l.lexeme_type,
  lexeme_type_label.label_fa AS lexeme_type_fa,
  l.surface,
  l.normalized_surface,
  l.lemma,
  l.part_of_speech,
  COALESCE(l.part_of_speech_fa, pos_label.label_fa) AS part_of_speech_fa,
  l.cefr_level,
  cefr_label.label_fa AS cefr_level_fa,
  l.translation_fa,
  l.usage_note_fa,
  l.flashcard_eligible,
  l.audio_status,
  audio_status_label.label_fa AS audio_status_fa,
  l.audio_url
FROM lexemes l
JOIN taxonomy_labels lexeme_type_label
  ON lexeme_type_label.domain_code='lexeme_type'
 AND lexeme_type_label.value_code=l.lexeme_type
LEFT JOIN taxonomy_labels pos_label
  ON pos_label.domain_code='part_of_speech'
 AND pos_label.value_code=l.part_of_speech
LEFT JOIN taxonomy_labels cefr_label
  ON cefr_label.domain_code='cefr_level'
 AND cefr_label.value_code=l.cefr_level
JOIN taxonomy_labels audio_status_label
  ON audio_status_label.domain_code='audio_status'
 AND audio_status_label.value_code=l.audio_status;

CREATE OR REPLACE VIEW v_frontend_lexeme_forms AS
SELECT
  lf.id,
  lf.lexeme_form_key,
  lf.lexeme_id,
  lf.surface,
  lf.normalized_surface,
  lf.form_type,
  form_type_label.label_fa AS form_type_fa,
  lf.origin,
  origin_label.label_fa AS origin_fa,
  lf.review_status,
  review_label.label_fa AS review_status_fa,
  lf.notes
FROM lexeme_forms lf
JOIN taxonomy_labels form_type_label
  ON form_type_label.domain_code='lexeme_form_type'
 AND form_type_label.value_code=lf.form_type
JOIN taxonomy_labels origin_label
  ON origin_label.domain_code='lexeme_form_origin'
 AND origin_label.value_code=lf.origin
JOIN taxonomy_labels review_label
  ON review_label.domain_code='review_status'
 AND review_label.value_code=lf.review_status;

CREATE OR REPLACE VIEW v_frontend_lexeme_form_features AS
SELECT
  lf.id AS lexeme_form_id,
  lf.lexeme_form_key,
  feature_rows.feature_key,
  feature_rows.feature_value,
  labels.label_fa AS feature_value_fa
FROM lexeme_forms lf
JOIN JSON_TABLE(
  JSON_ARRAY(
    IF(JSON_EXTRACT(lf.features,'$.tense') IS NULL, NULL,
      JSON_OBJECT('key','tense','value',JSON_UNQUOTE(JSON_EXTRACT(lf.features,'$.tense')))),
    IF(JSON_EXTRACT(lf.features,'$.mood') IS NULL, NULL,
      JSON_OBJECT('key','mood','value',JSON_UNQUOTE(JSON_EXTRACT(lf.features,'$.mood')))),
    IF(JSON_EXTRACT(lf.features,'$.number') IS NULL, NULL,
      JSON_OBJECT('key','number','value',JSON_UNQUOTE(JSON_EXTRACT(lf.features,'$.number'))))
  ),
  '$[*]' COLUMNS(
    feature_key VARCHAR(32) PATH '$.key' NULL ON EMPTY,
    feature_value VARCHAR(64) PATH '$.value' NULL ON EMPTY
  )
) AS feature_rows
JOIN taxonomy_labels labels
  ON labels.domain_code=CONCAT('grammar_feature_',feature_rows.feature_key)
 AND labels.value_code=feature_rows.feature_value
WHERE feature_rows.feature_key IS NOT NULL

UNION ALL

SELECT
  lf.id AS lexeme_form_id,
  lf.lexeme_form_key,
  'person' AS feature_key,
  person_rows.person_code AS feature_value,
  person_label.label_fa AS feature_value_fa
FROM lexeme_forms lf
JOIN JSON_TABLE(
  CASE
    WHEN JSON_EXTRACT(lf.features,'$.person') IS NULL THEN JSON_ARRAY()
    WHEN JSON_TYPE(JSON_EXTRACT(lf.features,'$.person'))='ARRAY' THEN JSON_EXTRACT(lf.features,'$.person')
    ELSE JSON_ARRAY(JSON_UNQUOTE(JSON_EXTRACT(lf.features,'$.person')))
  END,
  '$[*]' COLUMNS(person_code VARCHAR(64) PATH '$')
) AS person_rows
JOIN taxonomy_labels person_label
  ON person_label.domain_code='grammar_feature_person'
 AND person_label.value_code=person_rows.person_code;
