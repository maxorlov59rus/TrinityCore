-- VERIFY: TDB 1210.26091 / world; DekkCore 90ab207921d422adcd1ca6732edb108ea25a27f4 / Dekkcore_2023_07_17_01_world.sql; живая БД подтвердила отсутствие SceneId 3173/3097/3165/3152. Чистые data-only строки без локализации и GUID; UPDATE 3096/3094 не переносятся.
DELETE FROM `scene_template` WHERE `SceneId` IN (3173, 3097, 3165, 3152);
INSERT INTO `scene_template` (`SceneId`, `Flags`, `ScriptPackageID`, `Encrypted`) VALUES
(3173, 21, 3909, 0),
(3097, 17, 3916, 0),
(3165, 16, 3899, 0),
(3152, 16, 3868, 0);
