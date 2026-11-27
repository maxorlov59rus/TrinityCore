-- VERIFY: TDB 1210.26091 / world; DekkCore ead80bcb4dab3c63c7009e783cea57db25b179a0 / Dekkcore_2023_07_14_01_world.sql; живая БД подтвердила отсутствие SceneId 3170/3147/3145/3172/3137/3123. Чистые data-only строки без локализации и GUID; UPDATE 3096/3094 не переносятся.
DELETE FROM `scene_template` WHERE `SceneId` IN (3170, 3147, 3145, 3172, 3137, 3123);
INSERT INTO `scene_template` (`SceneId`, `Flags`, `ScriptPackageID`, `Encrypted`) VALUES
(3170, 27, 3925, 0),
(3147, 27, 3927, 0),
(3145, 27, 3936, 0),
(3172, 17, 3931, 0),
(3137, 16, 3919, 0),
(3123, 24, 3821, 0);
