-- Require source-backed target-language lesson titles and Persian companions.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
UPDATE lessons SET source_title='Was machen Sie nachmittags? / Was machen Sie abends?', source_title_fa='بعدازظهرها چه کار می‌کنید؟ / شب‌ها چه کار می‌کنید؟' WHERE lesson_key='de-a1-lesson-daily-routine-day-review';
UPDATE lessons SET source_title='Entschuldigen Sie bitte. Wo ist hier ein Hotel? / Gibt es ein Restaurant darin?', source_title_fa='ببخشید. اینجا یک هتل کجاست؟ / داخلش رستوران هست؟' WHERE lesson_key='de-a1-lesson-directions-public-places-review';
UPDATE lessons SET source_title='Wie komme ich zum Bahnhof? / Wie komme ich zum Flughafen?', source_title_fa='چطور به ایستگاه قطار برسم؟ / چطور به فرودگاه برسم؟' WHERE lesson_key='de-a1-lesson-directions-sequence-review';
UPDATE lessons SET source_title='Wo studiert euer Bruder? / Wo wohnt eure Schwester?', source_title_fa='برادرتان کجا درس می‌خواند؟ / خواهرتان کجا زندگی می‌کند؟' WHERE lesson_key='de-a1-lesson-family-profile-review';
UPDATE lessons SET source_title='Gibt es Käse? / Gibt es Gemüse?', source_title_fa='پنیر هست؟ / سبزیجات هست؟' WHERE lesson_key='de-a1-lesson-food-combinations-review';
UPDATE lessons SET source_title='Was möchten Sie? / Mit Milch und Zucker?', source_title_fa='چه میل دارید؟ / با شیر و شکر؟' WHERE lesson_key='de-a1-lesson-food-preference-review';
UPDATE lessons SET source_title='Buchstabieren Sie Ihren Vornamen. / Buchstabieren Sie Ihren Familiennamen.', source_title_fa='نام کوچک‌تان را هجی کنید. / نام خانوادگی‌تان را هجی کنید.' WHERE lesson_key='de-a1-lesson-forms-signs-message-review';
UPDATE lessons SET source_title='Welche Medikamente bekommt Herr Berger? / Wo bekommt er sie?', source_title_fa='آقای برگر چه داروهایی می‌گیرد؟ / آن‌ها را کجا می‌گیرد؟' WHERE lesson_key='de-a1-lesson-health-medicine-pharmacy';
UPDATE lessons SET source_title='Haben Sie noch Fieber? / Haben Sie noch Husten?', source_title_fa='هنوز تب دارید؟ / هنوز سرفه دارید؟' WHERE lesson_key='de-a1-lesson-health-recovery';
UPDATE lessons SET source_title='Was fehlt Ihnen? / Ich habe Fieber.', source_title_fa='چه مشکلی دارید؟ / تب دارم.' WHERE lesson_key='de-a1-lesson-health-symptoms';
UPDATE lessons SET source_title='Wo ist mein Heft? / Wo ist meine Tasche?', source_title_fa='دفترم کجاست؟ / کیفم کجاست؟' WHERE lesson_key='de-a1-lesson-home-description-review';
UPDATE lessons SET source_title='Guten Tag! Ich suche Lisa Müller. Sind Sie Lisa Müller? / Ja, und Sie? Wie heißen Sie?', source_title_fa='روز بخیر! دنبال لیزا مولر می‌گردم. شما لیزا مولر هستید؟ / بله، و شما؟ اسمتان چیست؟' WHERE lesson_key='de-a1-lesson-integrated-introduction-review';
UPDATE lessons SET source_title='Ich brauche Hilfe. / Wo finde ich einen Arzt?', source_title_fa='کمک لازم دارم. / کجا می‌توانم یک پزشک پیدا کنم؟' WHERE lesson_key='de-a1-lesson-services-help-review';
UPDATE lessons SET source_title='Darf ich Ihnen helfen? / Ja, können Sie mir helfen, diesen Rock in meiner Größe zu finden?', source_title_fa='می‌توانم کمکتان کنم؟ / بله، می‌توانید کمکم کنید این دامن را در سایز من پیدا کنم؟' WHERE lesson_key='de-a1-lesson-services-permission-review';
UPDATE lessons SET source_title='Wie viel kostet das? / Was kostet das?', source_title_fa='این چقدر قیمت دارد؟ / قیمت این چقدر است؟' WHERE lesson_key='de-a1-lesson-shopping-checkout-review';
UPDATE lessons SET source_title='Was brauchen Sie? / Was kaufen Sie?', source_title_fa='چه چیزی لازم دارید؟ / چه چیزی می‌خرید؟' WHERE lesson_key='de-a1-lesson-shopping-price-review';
UPDATE lessons SET source_title='Ich begleite Sie noch ein Stück. Ist Ihnen das recht? / Ja, ich bin einverstanden.', source_title_fa='کمی دیگر همراهتان می‌آیم. برایتان مناسب است؟ / بله، موافقم.' WHERE lesson_key='de-a1-lesson-time-plans-review';
UPDATE lessons SET source_title='Bitte eine Fahrkarte nach Berlin.', source_title_fa='لطفاً یک بلیت به برلین.' WHERE lesson_key='de-a1-lesson-transport-ticket';
UPDATE lessons SET source_title='Wann fährt der nächste Zug nach Budapest? / In 20 Minuten von Gleis 3.', source_title_fa='قطار بعدی به بوداپست چه زمانی حرکت می‌کند؟ / ۲۰ دقیقهٔ دیگر از سکوی ۳.' WHERE lesson_key='de-a1-lesson-transport-times-platform';
UPDATE lessons SET source_title='Hält dieser Zug in Berlin?', source_title_fa='این قطار در برلین توقف می‌کند؟' WHERE lesson_key='de-a1-lesson-transport-train-bus';
UPDATE lessons SET source_title='Wie ist denn das Wetter in Berlin? / Wie wird das Wetter?', source_title_fa='هوا در برلین چطور است؟ / هوا چطور خواهد شد؟' WHERE lesson_key='de-a1-lesson-weather-current';
UPDATE lessons SET source_title='Es ist sonnig / Es ist bewölkt', source_title_fa='هوا آفتابی است / هوا ابری است' WHERE lesson_key='de-a1-lesson-weather-rain-plan';
UPDATE lessons SET source_title='Es regnet / Es schneit', source_title_fa='باران می‌بارد / برف می‌بارد' WHERE lesson_key='de-a1-lesson-weather-temperature';
UPDATE lessons SET source_title='Vorname / Familienname / Adresse / Stadt / Offen / Geschlossen', source_title_fa='نام کوچک / نام خانوادگی / نشانی / شهر / باز / بسته' WHERE lesson_key='de-a1-lesson-personal-form-signs';
UPDATE lessons SET source_title='Wie heißen Sie? / Wo wohnen Sie? / Wie alt sind Sie?', source_title_fa='اسمتان چیست؟ / کجا زندگی می‌کنید؟ / چند سالتان است؟' WHERE lesson_key='de-pre-a1-lesson-personal-review';
COMMIT;

DELIMITER $$
DROP TRIGGER IF EXISTS trg_lessons_bu_final_guard$$
CREATE TRIGGER trg_lessons_bu_final_guard BEFORE UPDATE ON lessons FOR EACH ROW
BEGIN
  DECLARE opening_count INT DEFAULT 0;
  IF (NEW.unit_id IS NULL AND NEW.position_in_unit IS NOT NULL)
     OR (NEW.unit_id IS NOT NULL AND (NEW.position_in_unit IS NULL OR NEW.position_in_unit<1)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='unit_id and position_in_unit must be set together';
  END IF;
  IF NEW.status='final' AND (
       NEW.source_title IS NULL OR TRIM(NEW.source_title)=''
       OR NEW.source_title_fa IS NULL OR TRIM(NEW.source_title_fa)=''
     ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='A final lesson requires target-language source_title and Persian source_title_fa';
  END IF;
  IF NEW.status='final' AND OLD.status<>'final' THEN
    SELECT COUNT(*) INTO opening_count FROM activities
    WHERE lesson_id=NEW.id AND position_index=1 AND activity_type='conversation_speaking';
    IF opening_count<>1 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='A final lesson must begin with conversation_speaking';
    END IF;
  END IF;
END$$
DELIMITER ;
