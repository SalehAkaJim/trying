-- Canonical form/occurrence sync for German Pre-A1 Unit 3.
-- Applied after zzz-pre-a1-simple-orders.sql and safe to re-run.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);

UPDATE sources
SET locator='Items 040–058',
    locator_fa='بخش‌های ۰۴۰ تا ۰۵۸؛ جمله‌های منبع‌دار دربارهٔ غذای موجود، خوردن و سفارش ساده.'
WHERE source_key='src-wikibooks-de-lesson-002';

UPDATE source_items
SET locator='042', locator_fa='بخش ۰۴۲'
WHERE item_key='srcitem-de-u3-ich-esse-reis';

SET @x_essen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-essen');
SET @x_brauchen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-brauchen');
SET @x_kaufen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kaufen');
SET @x_moegen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-moegen');
SET @x_heute := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-heute');
SET @x_suppe := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-suppe');
SET @x_reis := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-reis');
SET @x_bitte := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-bitte');
SET @x_tasse := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-tasse');
SET @x_kaffee := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kaffee');
SET @x_hose := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-hose');
SET @x_hemd := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-hemd');
SET @x_schuhe := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-schuhe');

INSERT INTO lexeme_forms
(lexeme_form_key,lexeme_id,surface,normalized_surface,form_type,features,origin,review_status,notes) VALUES
('lexform-de-essen-esse',@x_essen,'esse','esse','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','در جملهٔ منبع‌دار «Ich esse Reis.» به‌صورت اول‌شخص مفرد حال استفاده شده است.'),
('lexform-de-brauchen-brauche',@x_brauchen,'brauche','brauche','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','در جملهٔ منبع‌دار «Ich brauche eine Hose.» به‌صورت اول‌شخص مفرد حال استفاده شده است.'),
('lexform-de-kaufen-kaufe',@x_kaufen,'kaufe','kaufe','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','در جملهٔ منبع‌دار «Ich kaufe ein Hemd und ein Paar Schuhe.» به‌صورت اول‌شخص مفرد حال استفاده شده است.'),
('lexform-de-moegen-moechten',@x_moegen,'möchten','möchten','inflected',JSON_OBJECT('mood','subjunctive_II','person','3','number','plural'),'source_attested','approved','در پرسش مؤدبانهٔ منبع‌دار «Was möchten Sie bitte?» با ضمیر رسمی «Sie» استفاده شده است؛ از نظر صرفی با سوم‌شخص جمع هم‌شکل است.')
ON DUPLICATE KEY UPDATE
 lexeme_id=VALUES(lexeme_id),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),form_type=VALUES(form_type),features=VALUES(features),origin=VALUES(origin),review_status=VALUES(review_status),notes=VALUES(notes);

SET @f_esse := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-essen-esse');
SET @f_brauche := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-brauchen-brauche');
SET @f_kaufe := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-kaufen-kaufe');
SET @f_moechten := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-moechten');

INSERT INTO lexeme_occurrences
(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-food-today-1-heute','dialogue_turn','turn-de-food-today-1','heute',NULL,NULL,@x_heute,NULL,'approved','اتصال «heute» تأیید شده است.'),
('occ-turn-de-food-today-2-heute','dialogue_turn','turn-de-food-today-2','Heute',NULL,NULL,@x_heute,NULL,'approved','اتصال «Heute» تأیید شده است.'),
('occ-turn-de-food-today-2-suppe','dialogue_turn','turn-de-food-today-2','Suppe',NULL,NULL,@x_suppe,NULL,'approved','اتصال «Suppe» تأیید شده است.'),
('occ-turn-de-food-today-3-essen','dialogue_turn','turn-de-food-today-3','essen',NULL,NULL,@x_essen,NULL,'approved','صورت پایهٔ «essen» در پرسش منبع‌دار آمده است.'),
('occ-turn-de-food-today-4-esse','dialogue_turn','turn-de-food-today-4','esse',NULL,NULL,@x_essen,@f_esse,'approved','فرم «esse» به «essen» متصل است.'),
('occ-turn-de-food-today-4-reis','dialogue_turn','turn-de-food-today-4','Reis',NULL,NULL,@x_reis,NULL,'approved','اتصال «Reis» تأیید شده است.'),
('occ-turn-de-simple-order-3-moechten','dialogue_turn','turn-de-simple-order-3','möchten',NULL,NULL,@x_moegen,@f_moechten,'approved','فرم رسمی «möchten» به «mögen» متصل است.'),
('occ-turn-de-simple-order-3-bitte','dialogue_turn','turn-de-simple-order-3','bitte',NULL,NULL,@x_bitte,NULL,'approved','اتصال «bitte» تأیید شده است.'),
('occ-turn-de-simple-order-4-tasse','dialogue_turn','turn-de-simple-order-4','Tasse',NULL,NULL,@x_tasse,NULL,'approved','اتصال «Tasse» تأیید شده است.'),
('occ-turn-de-simple-order-4-kaffee','dialogue_turn','turn-de-simple-order-4','Kaffee',NULL,NULL,@x_kaffee,NULL,'approved','اتصال «Kaffee» تأیید شده است.'),
('occ-turn-de-simple-order-4-bitte','dialogue_turn','turn-de-simple-order-4','bitte',NULL,NULL,@x_bitte,NULL,'approved','اتصال «bitte» تأیید شده است.'),
('occ-turn-de-need-buy-1-brauchen','dialogue_turn','turn-de-need-buy-1','brauchen',NULL,NULL,@x_brauchen,NULL,'approved','صورت پایهٔ «brauchen» در پرسش منبع‌دار آمده است.'),
('occ-turn-de-need-buy-2-brauche','dialogue_turn','turn-de-need-buy-2','brauche',NULL,NULL,@x_brauchen,@f_brauche,'approved','فرم «brauche» به «brauchen» متصل است.'),
('occ-turn-de-need-buy-2-hose','dialogue_turn','turn-de-need-buy-2','Hose',NULL,NULL,@x_hose,NULL,'approved','اتصال «Hose» تأیید شده است.'),
('occ-turn-de-need-buy-3-kaufen','dialogue_turn','turn-de-need-buy-3','kaufen',NULL,NULL,@x_kaufen,NULL,'approved','صورت پایهٔ «kaufen» در پرسش منبع‌دار آمده است.'),
('occ-turn-de-need-buy-4-kaufe','dialogue_turn','turn-de-need-buy-4','kaufe',NULL,NULL,@x_kaufen,@f_kaufe,'approved','فرم «kaufe» به «kaufen» متصل است.'),
('occ-turn-de-need-buy-4-hemd','dialogue_turn','turn-de-need-buy-4','Hemd',NULL,NULL,@x_hemd,NULL,'approved','اتصال «Hemd» تأیید شده است.'),
('occ-turn-de-need-buy-4-schuhe','dialogue_turn','turn-de-need-buy-4','Schuhe',NULL,NULL,@x_schuhe,NULL,'approved','اتصال «Schuhe» تأیید شده است.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

SET @l18 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-simple-order');
SET @a18a := (SELECT id FROM activities WHERE activity_key='act-de-simple-order-conversation');
INSERT INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role)
VALUES(@l18,@x_moegen,FALSE,'review')
ON DUPLICATE KEY UPDATE is_primary=VALUES(is_primary),role=VALUES(role);
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES(@a18a,@x_moegen);

SET @si_esse := (SELECT id FROM source_items WHERE item_key='srcitem-de-u3-ich-esse-reis');
SET @si_brauche := (SELECT id FROM source_items WHERE item_key='srcitem-de-u3-need-hose');
SET @si_kaufe := (SELECT id FROM source_items WHERE item_key='srcitem-de-u3-buy-answer');
SET @si_moechten := (SELECT id FROM source_items WHERE item_key='srcitem-de-u3-order-question');
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('lexeme_form','lexform-de-essen-esse',@si_esse,'other','فرم صرفی از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme_form','lexform-de-brauchen-brauche',@si_brauche,'other','فرم صرفی از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme_form','lexform-de-kaufen-kaufe',@si_kaufe,'other','فرم صرفی از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme_form','lexform-de-moegen-moechten',@si_moechten,'other','فرم رسمی «möchten» از پرسش منبع‌دار استخراج شده است.')
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

COMMIT;
