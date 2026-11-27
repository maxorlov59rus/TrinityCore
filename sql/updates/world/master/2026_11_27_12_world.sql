-- Allied-race information objects.
-- The embassy GO templates exist in TDB, but their ScriptName column is empty.
-- Bind them to the modern GameObjectAI gossip script and place the five races
-- whose TDB templates had no spawn next to the existing embassy objects.

UPDATE `gameobject_template` SET `ScriptName` = 'go_allied_race_infos_nightborne' WHERE `entry` = 273293;
UPDATE `gameobject_template` SET `ScriptName` = 'go_allied_race_infos_highmountaintauren' WHERE `entry` = 273286;
UPDATE `gameobject_template` SET `ScriptName` = 'go_allied_race_infos_voidelf' WHERE `entry` = 273853;
UPDATE `gameobject_template` SET `ScriptName` = 'go_allied_race_infos_lightforgeddraenei' WHERE `entry` = 273855;
UPDATE `gameobject_template` SET `ScriptName` = 'go_allied_race_infos_zandalaritroll' WHERE `entry` = 307614;
UPDATE `gameobject_template` SET `ScriptName` = 'go_allied_race_infos_kultiran' WHERE `entry` = 316736;
UPDATE `gameobject_template` SET `ScriptName` = 'go_allied_race_infos_darkirondwarf' WHERE `entry` = 298865;
UPDATE `gameobject_template` SET `ScriptName` = 'go_allied_race_infos_vulpera' WHERE `entry` = 339344;
UPDATE `gameobject_template` SET `ScriptName` = 'go_allied_race_infos_magharorc' WHERE `entry` = 298892;
UPDATE `gameobject_template` SET `ScriptName` = 'go_allied_race_infos_mechagnome' WHERE `entry` = 339222;

SET @OGUID = 9901000;

DELETE FROM `gameobject` WHERE `guid` BETWEEN @OGUID + 0 AND @OGUID + 4;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `PhaseId`, `PhaseGroup`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `VerifiedBuild`) VALUES
(@OGUID + 0, 273293, 0, 1519, 9171, '0', 0, 0, -8150.30, 818.20, 75.80, 3.89929, 0, 0, -0.92909, 0.369853, 120, 255, 1, 0),
(@OGUID + 1, 273286, 0, 1519, 9171, '0', 0, 0, -8152.20, 820.10, 75.95, 3.89929, 0, 0, -0.92909, 0.369853, 120, 255, 1, 0),
(@OGUID + 2, 307614, 0, 1519, 9171, '0', 0, 0, -8157.80, 825.20, 76.15, 3.89929, 0, 0, -0.92909, 0.369853, 120, 255, 1, 0),
(@OGUID + 3, 298892, 0, 1519, 9171, '0', 0, 0, -8153.60, 824.30, 75.85, 3.89929, 0, 0, -0.92909, 0.369853, 120, 255, 1, 0),
(@OGUID + 4, 339344, 0, 1519, 9171, '0', 0, 0, -8159.00, 821.50, 76.05, 3.89929, 0, 0, -0.92909, 0.369853, 120, 255, 1, 0);
