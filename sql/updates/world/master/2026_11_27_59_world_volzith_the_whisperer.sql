-- Vol'zith the Whisperer: скрипты босса и аддов, локализованные реплики, ареатриггер Yawning Gate

-- Скрипты NPC
UPDATE `creature_template` SET `ScriptName`='boss_volzith_the_whisperer' WHERE `entry`=134069;
UPDATE `creature_template` SET `ScriptName`='npc_volzith_tentacle' WHERE `entry`=135987;
UPDATE `creature_template` SET `ScriptName`='npc_volzith_manifestation' WHERE `entry`=135903;
UPDATE `creature_template` SET `ScriptName`='npc_volzith_forgotten_denizen' WHERE `entry`=136297;
UPDATE `creature_template` SET `ScriptName`='npc_volzith_sunken_denizen' WHERE `entry`=136100;

-- Реплики: все BroadcastTextId подтверждены в hotfixes.broadcast_text и имеют ruRU-локализацию
DELETE FROM `creature_text` WHERE `CreatureID`=134069;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundPlayType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(134069, 0, 0, '', 15, 0, 100, 0, 0, 103098, 0, 151880, 0, 'Vol''zith - intro, common tongue'),
(134069, 1, 0, '', 14, 0, 100, 0, 0, 0, 0, 150976, 0, 'Vol''zith - intro, Old God tongue'),
(134069, 2, 0, '', 15, 0, 100, 0, 0, 103110, 0, 151878, 0, 'Vol''zith - aggro, common tongue'),
(134069, 3, 0, '', 14, 0, 100, 0, 0, 0, 0, 150530, 0, 'Vol''zith - aggro, Old God tongue'),
(134069, 4, 0, '', 15, 0, 100, 0, 0, 103100, 0, 151893, 0, 'Vol''zith - call the abyss, common tongue'),
(134069, 5, 0, '', 14, 0, 100, 0, 0, 103100, 0, 151893, 0, 'Vol''zith - call the abyss, yell'),
(134069, 6, 0, '', 15, 0, 100, 0, 0, 103112, 0, 151877, 0, 'Vol''zith - death, common tongue'),
(134069, 7, 0, '', 14, 0, 100, 0, 0, 0, 0, 150531, 0, 'Vol''zith - death, Old God tongue'),
(134069, 8, 0, '', 15, 0, 100, 0, 0, 103101, 0, 150536, 0, 'Vol''zith - kill, Old God tongue'),
(134069, 9, 0, '', 14, 0, 100, 0, 0, 103104, 0, 151881, 0, 'Vol''zith - kill, common tongue'),
(134069, 10, 0, '', 15, 0, 100, 0, 0, 103105, 0, 151882, 0, 'Vol''zith - grasp, common tongue'),
(134069, 11, 0, '', 14, 0, 100, 0, 0, 0, 0, 150708, 0, 'Vol''zith - grasp, Old God tongue');

-- Spell-скрипт периодического призыва
DELETE FROM `spell_script_names` WHERE `spell_id`=267299 AND `ScriptName`='spell_volzith_call_the_abyss';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(267299, 'spell_volzith_call_the_abyss');

-- Ареатриггер 13312 - Yawning Gate
DELETE FROM `areatrigger_create_properties` WHERE `Id`=13312 AND `IsCustom`=0;
INSERT INTO `areatrigger_create_properties` (`Id`, `IsCustom`, `AreaTriggerId`, `IsAreatriggerCustom`, `Flags`, `MoveCurveId`, `ScaleCurveId`, `MorphCurveId`, `FacingCurveId`, `AnimId`, `AnimKitId`, `DecalPropertiesId`, `SpellForVisuals`, `TimeToTargetScale`, `Speed`, `SpeedIsTime`, `Shape`, `ShapeData0`, `ShapeData1`, `ShapeData2`, `ShapeData3`, `ShapeData4`, `ShapeData5`, `ShapeData6`, `ShapeData7`, `ScriptName`, `VerifiedBuild`) VALUES
(13312, 0, 13312, 0, 0, 0, 0, 0, 0, -1, 0, 0, NULL, 0, 0, 0, 0, 20, 20, 0, 0, 0, 0, 0, 0, 'at_volzith_yawning_gate', 0);

DELETE FROM `areatrigger_template` WHERE `Id`=13312 AND `IsCustom`=0;
INSERT INTO `areatrigger_template` (`Id`, `IsCustom`, `VerifiedBuild`) VALUES
(13312, 0, 0);
