-- Shared German language bootstrap.
-- Must run before any German level migration so levels do not depend on Pre-A1 file ordering.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

INSERT INTO languages (code,name_native,name_fa,status,standalone_audio_voice_name,standalone_audio_voice_id)
VALUES ('de','Deutsch','آلمانی','building',NULL,NULL)
ON DUPLICATE KEY UPDATE
  name_native=VALUES(name_native),
  name_fa=VALUES(name_fa);

COMMIT;
