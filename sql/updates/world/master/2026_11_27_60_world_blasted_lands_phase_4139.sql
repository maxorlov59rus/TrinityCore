-- VERIFY: TDB 1210.26091 / world; issue TrinityCore #29224 (Branch-master, rev 86725ed9267); живая БД подтвердила квест 36379, NPC 76556/76643/38821/88206, GO 234576, сцену 844/фазу 4139/AT-скрипт 10254 как отсутствующие, BT 88578 с enRU и ruRU-локализацией; поля curhealth/curmana и колонки Flight/Rooted в master удалены и исключены, свободные GUID — 777777790-794 и 100000000069.

-- Спавны фазы 4139: Ironmarch Grunt, Archmage Khadgar и декоративные бунны с аурами
DELETE FROM `creature` WHERE `guid` BETWEEN 777777790 AND 777777794;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `MovementType`, `npcflag`, `unit_flags`, `VerifiedBuild`) VALUES
(777777790, 76556, 0, 4, 6963, '0', 4139, 0, 1190, 0, 1, -11481.1767578125, -3454.328125, 33.1897735595703125, 1.261624574661254882, 120, 0, 0, 0, 0, 0, 50747), -- Ironmarch Grunt — Permanent Feign Death 29266
(777777791, 76556, 0, 4, 6963, '0', 4139, 0, 1190, 0, 1, -11477.544921875, -3466.835205078125, 28.57114410400390625, 5.178782939910888671, 120, 0, 0, 0, 0, 0, 50747), -- Ironmarch Grunt — Permanent Feign Death 29266
(777777792, 76643, 0, 4, 6963, '0', 4139, 0, 1190, 0, 1, -11475.9970703125, -3452.428955078125, 32.78908157348632812, 2.560125589370727539, 120, 0, 0, 0, 0, 0, 50747), -- Archmage Khadgar — квест 36379
(777777793, 38821, 0, 4, 6953, '0', 4139, 0, 1190, 0, 0, -11476.9951171875, -3467.401123046875, 28.61593055725097656, 0, 120, 0, 0, 0, 0, 0, 50747), -- Dave's Industrial Light and Magic Bunny — Purple Fire Cosmetic 140255
(777777794, 38821, 0, 4, 6953, '0', 4139, 0, 1190, 0, 0, -11481.169921875, -3453.536376953125, 33.19791412353515625, 2.36602783203125, 120, 0, 0, 0, 0, 0, 50747); -- Dave's Industrial Light and Magic Bunny — Purple Fire Cosmetic 140255

-- Ауры на спавнах
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 777777790 AND 777777794;
INSERT INTO `creature_addon` (`guid`, `PathId`, `mount`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`, `PvPFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(777777790, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '29266'),
(777777791, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '29266'),
(777777793, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 4, '140255'),
(777777794, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 4, '140255');

-- Сцена и телескоп
DELETE FROM `scene_template` WHERE `SceneId`=844;
INSERT INTO `scene_template` (`SceneId`, `Flags`, `ScriptPackageID`, `Encrypted`) VALUES
(844, 16, 1001, 0);

DELETE FROM `gameobject` WHERE `guid`=100000000069;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `PhaseId`, `PhaseGroup`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `VerifiedBuild`) VALUES
(100000000069, 234576, 0, 4, 6963, '0', 4139, 0, -11479.3994140625, -3452.3525390625, 33.07344436645507812, 1.162210941314697265, 0, 0, 0.548948287963867187, 0.835856318473815917, 120, 255, 1, 50747); -- Telescope

-- Экипировка Archmage Khadgar
DELETE FROM `creature_equip_template` WHERE `CreatureID`=76643 AND `ID`=1;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(76643, 1, 28067, 0, 0, 0, 0, 0, 0, 0, 0, 50747);

-- Zidormi: в master нет колонок Flight/Rooted, сохраняем только неподвижное поведение
DELETE FROM `creature_template_movement` WHERE `CreatureId`=88206;
INSERT INTO `creature_template_movement` (`CreatureId`, `HoverInitiallyEnabled`, `Chase`, `Random`, `InteractionPauseTimer`) VALUES
(88206, NULL, 0, 0, NULL);

-- Фаза 4139 и её условие по квесту 36379
DELETE FROM `phase_name` WHERE `ID`=4139;
INSERT INTO `phase_name` (`ID`, `Name`) VALUES
(4139, 'Cosmetic - See Archmage Khadgar at The Shattered Front');

DELETE FROM `phase_area` WHERE `AreaId`=4 AND `PhaseId`=4139;
INSERT INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES
(4, 4139, 'Archmage Khadgar at the top of the hill - Quest 36379');

-- Ареатриггер 10254: реплика Хадгара при входе игрока
DELETE FROM `areatrigger_scripts` WHERE `entry`=10254;
INSERT INTO `areatrigger_scripts` (`entry`, `ScriptName`) VALUES
(10254, 'SmartTrigger');

DELETE FROM `smart_scripts` WHERE `entryorguid`=10254 AND `source_type`=2 AND `id`=0 AND `link`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10254, 2, 0, 0, 46, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, 0, 19, 76643, 0, 0, 0, 0, 0, 0, 0, 'При входе — Archmage Khadgar произносит реплику из creature_text 0');

-- Текст уже есть в broadcast_text 88578 (EN + ruRU), дубли локализации не добавляется
DELETE FROM `creature_text` WHERE `CreatureID`=76643;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundPlayType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(76643, 0, 0, '', 12, 0, 100, 16, 0, 0, 0, 88578, 0, 'Archmage Khadgar — реплика по ареатриггеру 10254, BroadcastTextId 88578 с ruRU');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=4139 AND `SourceEntry`=4;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(26, 4139, 4, 0, 0, 47, 0, 36379, 10, 0, '', 0, 0, 0, '', 'Фаза 4139 применяется, если квест 36379 взят или завершён (8 | 2)');

-- Параметры шаблонов
UPDATE `creature_template` SET `faction`=14 WHERE `entry`=76556; -- Ironmarch Grunt
UPDATE `creature_template` SET `BaseAttackTime`=2000, `unit_flags`=33024, `unit_flags2`=2048 WHERE `entry`=76643; -- Archmage Khadgar
UPDATE `creature_queststarter` SET `VerifiedBuild`=50747 WHERE `id`=85213 AND `quest`=36379;
UPDATE `creature_questender` SET `VerifiedBuild`=50747 WHERE `id`=85213 AND `quest`=36379;
UPDATE `gameobject_template` SET `ContentTuningId`=1221, `VerifiedBuild`=50747 WHERE `entry`=234576; -- Telescope
UPDATE `gameobject_template_addon` SET `flags`=4 WHERE `entry`=234576; -- Telescope
