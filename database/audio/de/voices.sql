-- Generated provider voice assignments. Do not hand-edit; regenerate from config/audio-voice-locks.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
START TRANSACTION;
UPDATE languages SET standalone_audio_voice_name='Hope - upbeat and clear', standalone_audio_voice_id='tnSpp4vdxKPjI9w0GnoV' WHERE code='de';
UPDATE characters c JOIN languages l ON l.id=c.language_id SET c.voice_name='Adam - Authentic & Engaging Conversationalist', c.elevenlabs_voice_id='s3TPKV1kjDlVtZbl4Ksh', c.voice_profile=JSON_SET(COALESCE(c.voice_profile,JSON_OBJECT()),'$.voiceName','Adam - Authentic & Engaging Conversationalist','$.elevenLabsVoiceId','s3TPKV1kjDlVtZbl4Ksh') WHERE l.code='de' AND c.character_key='char-de-iris';
UPDATE characters c JOIN languages l ON l.id=c.language_id SET c.voice_name='Hope - upbeat and clear', c.elevenlabs_voice_id='tnSpp4vdxKPjI9w0GnoV', c.voice_profile=JSON_SET(COALESCE(c.voice_profile,JSON_OBJECT()),'$.voiceName','Hope - upbeat and clear','$.elevenLabsVoiceId','tnSpp4vdxKPjI9w0GnoV') WHERE l.code='de' AND c.character_key='char-de-learner';
UPDATE characters c JOIN languages l ON l.id=c.language_id SET c.voice_name='Ava – Natural AI Voice', c.elevenlabs_voice_id='gJx1vCzNCD1EQHT212Ls', c.voice_profile=JSON_SET(COALESCE(c.voice_profile,JSON_OBJECT()),'$.voiceName','Ava – Natural AI Voice','$.elevenLabsVoiceId','gJx1vCzNCD1EQHT212Ls') WHERE l.code='de' AND c.character_key='char-de-mia';
COMMIT;
