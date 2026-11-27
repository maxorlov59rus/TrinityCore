-- VERIFY: TDB 1210.26091 / world; DekkCore a57018c519036f9615eae7cbbd55b64f29b5ee40 / Dekkcore_2023_07_18_00_world.sql; живая БД подтвердила отсутствие SceneId 3207 и наличие 3246 (17/3996/0), поэтому 3246 не трогается. Чистая data-only строка без локализации и GUID.
DELETE FROM `scene_template` WHERE `SceneId` IN (3207);
INSERT INTO `scene_template` (`SceneId`, `Flags`, `ScriptPackageID`, `Encrypted`) VALUES
(3207, 81, 3943, 0);
