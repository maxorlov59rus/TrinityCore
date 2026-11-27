-- Julia Stevens (Aspiring Pet Tamer) and her snakes (issue #27320).
-- The retail spawns in map 530 already exist; these are the missing original-world spawns.
SET @CGUID := 12000300;

DELETE FROM `creature` WHERE `guid` BETWEEN @CGUID+0 AND @CGUID+2;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(@CGUID+0, 64330, 0, 12, 0, '0', 0, 0, 0, -1, 0, 0, -9876.109375, 89.515625, 32.2881927490234375, 1.803623676300048828, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 69497), -- Julia Stevens
(@CGUID+1, 64335, 0, 12, 0, '0', 0, 0, 0, -1, 0, 0, -9874.89453125, 89.7586822509765625, 32.21353912353515625, 1.870338678359985351, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 69497), -- Slither
(@CGUID+2, 64334, 0, 12, 57, '0', 0, 0, 0, -1, 0, 0, -9877.4345703125, 89.1475677490234375, 32.22677230834960937, 1.719892263412475585, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 69497); -- Fangs

DELETE FROM `creature_text` WHERE `CreatureID` = 64330 AND `GroupID` = 0 AND `ID` = 0;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundPlayType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(64330, 0, 0, 'Think you can take me in battle?  Most girls hate snakes, but I think they\'re cute!', 12, 0, 100, 0, 0, 0, 0, 64260, 0, 'Julia Stevens to Player');

UPDATE `npc_text` SET `BroadcastTextID0`=64260, `VerifiedBuild`=69497 WHERE `ID`=20980;
UPDATE `gossip_menu` SET `VerifiedBuild`=69497 WHERE `MenuID`=14660 AND `TextID`=20980;

UPDATE `creature_template` SET `AIName`='SmartAI', `ScriptName`='', `npcflag`=`npcflag`|1, `VerifiedBuild`=69497 WHERE `entry`=64330;

DELETE FROM `creature_template_gossip` WHERE `CreatureID`=64330 AND `MenuID`=14660;
INSERT INTO `creature_template_gossip` (`CreatureID`, `MenuID`, `VerifiedBuild`) VALUES
(64330, 14660, 69497);

DELETE FROM `smart_scripts` WHERE `entryorguid`=64330 AND `source_type`=0 AND `id`=0 AND `link`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(64330, 0, 0, 0, '', 60, 0, 100, 0, 1000, 5000, 120000, 360000, 0, '', 1, 0, 0, 0, 0, 0, 0, 0, NULL, 18, 5, 0, 0, 0, NULL, 0, 0, 0, 0, 'Julia Stevens - Every 120-360 seconds - Say 0 to nearby players');
