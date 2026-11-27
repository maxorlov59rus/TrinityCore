SET @OGUID := 12000200;
SET @CGUID := 12000100;

UPDATE `quest_offer_reward` SET `VerifiedBuild`=56313 WHERE `ID` = 55639;

UPDATE `quest_poi` SET `VerifiedBuild`=56313 WHERE (`QuestID`=55639 AND `BlobIndex`=0 AND `Idx1`=4) OR (`QuestID`=55639 AND `BlobIndex`=0 AND `Idx1`=3) OR (`QuestID`=55639 AND `BlobIndex`=0 AND `Idx1`=2) OR (`QuestID`=55639 AND `BlobIndex`=0 AND `Idx1`=1) OR (`QuestID`=55639 AND `BlobIndex`=0 AND `Idx1`=0);

UPDATE `quest_poi_points` SET `VerifiedBuild`=56313 WHERE (`QuestID`=55639 AND `Idx1`=4 AND `Idx2`=0) OR (`QuestID`=55639 AND `Idx1`=3 AND `Idx2`=0) OR (`QuestID`=55639 AND `Idx1`=2 AND `Idx2`=0) OR (`QuestID`=55639 AND `Idx1`=1 AND `Idx2`=4) OR (`QuestID`=55639 AND `Idx1`=1 AND `Idx2`=3) OR (`QuestID`=55639 AND `Idx1`=1 AND `Idx2`=2) OR (`QuestID`=55639 AND `Idx1`=1 AND `Idx2`=1) OR (`QuestID`=55639 AND `Idx1`=1 AND `Idx2`=0) OR (`QuestID`=55639 AND `Idx1`=0 AND `Idx2`=0);

UPDATE `quest_details` SET `VerifiedBuild`=56313 WHERE `ID` = 55639;

DELETE FROM `creature_queststarter` WHERE `id`=156803 AND `quest`=55639;
INSERT INTO `creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(156803, 55639, 56313); -- Who Lurks in the Pit offered by Alaria

DELETE FROM `creature_questender` WHERE `id`=156807 AND `quest` = 55639;
INSERT INTO `creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
(156807, 55639, 56313); -- Who Lurks in the Pit ended by Captain Garrick

UPDATE `quest_template` SET `VerifiedBuild`=56313 WHERE `ID` = 55639;  

DELETE FROM `creature_text` WHERE (`CreatureID` = 156900 AND `GroupID` IN (0, 1)) OR  (`CreatureID` = 156929 AND `GroupID` = 0);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(156900, 0, 0, 'You will be kindling for the flame!', 12, 0, 100, 0, 0, 152997, 172629, 0, 'Hrun the Exiled to Player'),
(156900, 1, 0, 'If... I die... so... do you!', 12, 0, 100, 0, 0, 152998, 183958, 0, 'Hrun the Exiled to Player'),
(156929, 0, 0, 'You saved my life! Allow me to return the favor. Hop on!', 12, 0, 100, 0, 0, 152936, 178915, 0, 'Ralia Dreamchaser to Player');

-- Remove existing spawns
DELETE FROM `creature` WHERE (`id` IN (160394, 160433) AND `map` = 2175 AND `zoneId` = 10424 AND `areaId` = 10527);
-- Add new spawns
DELETE FROM `creature` WHERE `guid` BETWEEN @CGUID+0 AND @CGUID+25;  
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `PhaseId`, `PhaseGroup`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `VerifiedBuild`) VALUES
(@CGUID+0, 156902, 2175, 10424, 10527, '0', '0', 0, 0, 0, 73.55034637451171875, -2129.298583984375, -25.74432373046875, 2.20798802375793457, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Ralia Dreamchaser (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 305513 - Necrotic Ritual (DNT))
(@CGUID+1, 160451, 2175, 10424, 10527, '0', '0', 0, 0, 0, 75.59722137451171875, -2118.47216796875, -27.3309917449951171, 5.623931407928466796, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Hrun the Exiled (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 298902 - Fire Burst)
(@CGUID+2, 160394, 2175, 10424, 10527, '0', '0', 0, 0, 0, 102.87841796875, -2213.439697265625, 30.78537178039550781, 2.298623323440551757, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Barrow Spider (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs)
(@CGUID+3, 160394, 2175, 10424, 10527, '0', '0', 0, 0, 0, 56.01008987426757812, -2224.93994140625, -18.92352294921875, 3.692547559738159179, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Barrow Spider (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs) (possible waypoints or random movement)
(@CGUID+4, 160394, 2175, 10424, 10527, '0', '0', 0, 0, 0, 35.944915771484375, -2263.1337890625, 0.856739521026611328, 3.975739955902099609, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Barrow Spider (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs)
(@CGUID+5, 160433, 2175, 10424, 10527, '0', '0', 0, 0, 0, 21.09291458129882812, -2223.662841796875, 12.74303436279296875, 1.297713160514831542, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Barrow Spiderling (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs) (possible waypoints or random movement)
(@CGUID+6, 160433, 2175, 10424, 10527, '0', '0', 0, 0, 0, 75.85784149169921875, -2183.736083984375, 24.40164375305175781, 1.321158528327941894, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Barrow Spiderling (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs) (possible waypoints or random movement)
(@CGUID+7, 160433, 2175, 10424, 10527, '0', '0', 0, 0, 0, 32.09027862548828125, -2232.057373046875, 15.30853271484375, 4.475126266479492187, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Barrow Spiderling (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs) (possible waypoints or random movement)
(@CGUID+8, 160433, 2175, 10424, 10527, '0', '0', 0, 0, 0, 71.1664276123046875, -2190.528076171875, 24.40254592895507812, 4.394566059112548828, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Barrow Spiderling (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs) (possible waypoints or random movement)
(@CGUID+9, 160394, 2175, 10424, 10527, '0', '0', 0, 0, 0, 37.763671875, -2189.829345703125, 19.88393211364746093, 4.008761405944824218, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Barrow Spider (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs) (possible waypoints or random movement)
(@CGUID+10, 154268, 2175, 10424, 10527, '0', '0', 0, 0, 0, 205.138519287109375, -2050.562255859375, 96.8371124267578125, 3.414698600769042968, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Hungry Vulture (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (possible waypoints or random movement)
(@CGUID+11, 161224, 2175, 10424, 10527, '0', '0', 0, 0, 0, -62.0329208374023437, -2263.302001953125, 14.1887969970703125, 0.578257381916046142, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Shuffling Crab (Area: Hrun's Barrow - Difficulty: 0) CreateObject1
(@CGUID+12, 156900, 2175, 10424, 10527, '0', '0', 0, 0, 0, 69.98264312744140625, -2122.057373046875, -30.1194019317626953, 5.326576709747314453, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Hrun the Exiled (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: ) - !!! already present in database !!! (possible waypoints or random movement)
(@CGUID+13, 160451, 2175, 10424, 10527, '0', '0', 0, 0, 0, 75.59722137451171875, -2118.47216796875, -27.3309917449951171, 5.623931407928466796, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Hrun the Exiled (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 298902 - Fire Burst)
(@CGUID+14, 160451, 2175, 10424, 10527, '0', '0', 0, 0, 0, 63.67013931274414062, -2124.8369140625, -27.2542858123779296, 5.623931407928466796, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Hrun the Exiled (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 298902 - Fire Burst)
(@CGUID+15, 156929, 2175, 10424, 10527, '0', '0', 0, 0, 0, 74.55728912353515625, -2134.444580078125, -30.0123291015625, 5.272579193115234375, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Ralia Dreamchaser (Area: Hrun's Barrow - Difficulty: 0) CreateObject1
(@CGUID+16, 160394, 2175, 10424, 10527, '0', '0', 0, 0, 0, 105.2446441650390625, -2214.515869140625, 31.0885772705078125, 5.118701934814453125, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Barrow Spider (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs) (possible waypoints or random movement)
(@CGUID+17, 160433, 2175, 10424, 10527, '0', '0', 0, 0, 0, 119.8256912231445312, -2278.305908203125, 43.78490447998046875, 0.284724712371826171, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Barrow Spiderling (Area: Hrun's Barrow - Difficulty: 0) CreateObject1
(@CGUID+18, 160433, 2175, 10424, 10527, '0', '0', 0, 0, 0, 121.8573532104492187, -2277.267578125, 42.98326492309570312, 6.241856098175048828, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Barrow Spiderling (Area: Hrun's Barrow - Difficulty: 0) CreateObject1
(@CGUID+19, 160433, 2175, 10424, 10527, '0', '0', 0, 0, 0, 71.19809722900390625, -2188.115234375, 24.13590049743652343, 4.591461181640625, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Barrow Spiderling (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs) (possible waypoints or random movement)
(@CGUID+20, 160433, 2175, 10424, 10527, '0', '0', 0, 0, 0, 76.25751495361328125, -2184.197021484375, 24.46865653991699218, 4.283608913421630859, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Barrow Spiderling (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs) (possible waypoints or random movement)
(@CGUID+21, 153266, 2175, 10424, 10527, '0', '0', 0, 0, 0, 214.729949951171875, -2074.442138671875, 78.60988616943359375, 4.625847816467285156, 120, 10, 0, 1, NULL, NULL, NULL, NULL, 56313), -- Killclaw the Terrible (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 313373 - Old Wounds (DNT)) (possible waypoints or random movement)
(@CGUID+22, 160433, 2175, 10424, 10527, '0', '0', 0, 0, 0, 118.8298568725585937, -2274.116455078125, 42.39156341552734375, 5.601245403289794921, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Barrow Spiderling (Area: Hrun's Barrow - Difficulty: 0) CreateObject2 (Auras: 316915 - Venomous Fangs)
(@CGUID+23, 160433, 2175, 10424, 10527, '0', '0', 0, 0, 0, 121.6024322509765625, -2273.036376953125, 42.079132080078125, 0.085403807461261749, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Barrow Spiderling (Area: Hrun's Barrow - Difficulty: 0) CreateObject2 (Auras: 316915 - Venomous Fangs)
(@CGUID+24, 160394, 2175, 10424, 10527, '0', '0', 0, 0, 0, 34.26218795776367187, -2262.103271484375, 1.171705961227416992, 0.519148945808410644, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313), -- Barrow Spider (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs)
(@CGUID+25, 160433, 2175, 10424, 10527, '0', '0', 0, 0, 0, 31.80845069885253906, -2233.3857421875, 10.21085834503173828, 4.503332138061523437, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 56313); -- Barrow Spiderling (Area: Hrun's Barrow - Difficulty: 0) CreateObject1 (Auras: 316915 - Venomous Fangs)


DELETE FROM `creature_addon` WHERE `guid` BETWEEN @CGUID+0 AND @CGUID+25;
INSERT INTO `creature_addon` (`guid`, `PathId`, `mount`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`, `PvpFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(@CGUID+0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '305513'), -- Ralia Dreamchaser - 305513 - Necrotic Ritual (DNT)
(@CGUID+1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '298902'), -- Hrun the Exiled - 298902 - Fire Burst
(@CGUID+2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spider - 316915 - Venomous Fangs
(@CGUID+3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spider - 316915 - Venomous Fangs
(@CGUID+4, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spider - 316915 - Venomous Fangs
(@CGUID+5, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spiderling - 316915 - Venomous Fangs
(@CGUID+6, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spiderling - 316915 - Venomous Fangs
(@CGUID+7, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spiderling - 316915 - Venomous Fangs
(@CGUID+8, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spiderling - 316915 - Venomous Fangs
(@CGUID+9, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spider - 316915 - Venomous Fangs
(@CGUID+10, 0, 0, 0, 3, 0, 1, 0, 0, 0, 0, 0, 3, ''), -- Hungry Vulture
(@CGUID+12, 0, 0, 0, 0, 0, 1, 0, 468, 0, 0, 0, 0, ''), -- Hrun the Exiled 
(@CGUID+13, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '298902'), -- Hrun the Exiled - 298902 - Fire Burst
(@CGUID+14, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '298902'), -- Hrun the Exiled - 298902 - Fire Burst
(@CGUID+16, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spider - 316915 - Venomous Fangs
(@CGUID+19, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spiderling - 316915 - Venomous Fangs
(@CGUID+20, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spiderling - 316915 - Venomous Fangs
(@CGUID+21, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 4, '313373'), -- Killclaw the Terrible - 313373 - Old Wounds (DNT)
(@CGUID+22, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spiderling - 316915 - Venomous Fangs
(@CGUID+23, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spiderling - 316915 - Venomous Fangs
(@CGUID+24, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'), -- Barrow Spider - 316915 - Venomous Fangs
(@CGUID+25, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '316915'); -- Barrow Spiderling - 316915 - Venomous Fangs

UPDATE `creature_template_difficulty` SET `StaticFlags1`=536871168, `VerifiedBuild`=56313 WHERE (`Entry`=160451 AND `DifficultyID`=0); -- 160451 (Hrun the Exiled) - Sessile, Floating
UPDATE `creature_template_difficulty` SET `StaticFlags1`=536871168, `VerifiedBuild`=56313 WHERE (`Entry`=156902 AND `DifficultyID`=0); -- 156902 (Ralia Dreamchaser) - Sessile, Floating
UPDATE `creature_template_difficulty` SET `StaticFlags1`=268435456, `VerifiedBuild`=56313 WHERE (`Entry`=156900 AND `DifficultyID`=0); -- 156900 (Hrun the Exiled) - CanSwim

DELETE FROM `creature_template_difficulty` WHERE (`DifficultyID`=0 AND `Entry` IN (218381,227453));
INSERT INTO `creature_template_difficulty` (`Entry`, `DifficultyID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`) VALUES
(218381, 0, 10, 1, 1, 267887, 536870928, 8388614), -- Warband Bank Convergence
(227453, 0, 10, 1, 1, 278622, 1610612752, 1030); -- Deployed Battle Supplies

UPDATE `creature_template` SET `unit_flags3`=1090519040 WHERE `entry`=160451; -- Hrun the Exiled
UPDATE `creature_template` SET `faction`=1732, `BaseAttackTime`=2000, `unit_flags2`=2048, `unit_flags3`=1073741824 WHERE `entry`=156902; -- Ralia Dreamchaser
UPDATE `creature_template` SET `unit_flags`=33555200 WHERE `entry`=156900; -- Hrun the Exiled


DELETE FROM `creature_template_addon` WHERE `entry` IN (160451 /*160451 (Hrun the Exiled) - Fire Burst*/, 156902 /*156902 (Ralia Dreamchaser) - Necrotic Ritual (DNT)*/, 165189 /*165189 (Generic Hunter Pet) - Pet Active, Pet Damage, Pet Health, Hunter Pet, Avoidance, Kindred Spirits, Pathfinding*/);
INSERT INTO `creature_template_addon` (`entry`, `PathId`, `mount`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`, `PvpFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(160451, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '298902'), -- 160451 (Hrun the Exiled) - Fire Burst
(156902, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '305513'), -- 156902 (Ralia Dreamchaser) - Necrotic Ritual (DNT)
(165189, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '166615 8875 19581 34902 65220 88680 264656'); -- 165189 (Generic Hunter Pet) - Pet Active, Pet Damage, Pet Health, Hunter Pet, Avoidance, Kindred Spirits, Pathfinding

UPDATE `creature_template_addon` SET `emote`=0, `auras`='322352' WHERE `entry`=156900; -- 156900 (Hrun the Exiled) - Final Sacrifice

DELETE FROM `spell_target_position` WHERE (`ID`=327496 AND `EffectIndex`=0);
INSERT INTO `spell_target_position` (`ID`, `EffectIndex`, `MapID`, `PositionX`, `PositionY`, `PositionZ`, `VerifiedBuild`) VALUES
(327496, 0, 0, -9058, 438.899993896484375, 93.09999847412109375, 56313); -- Spell: 327496 (Bind) Efffect: 11 (SPELL_EFFECT_BIND)

UPDATE `spell_target_position` SET `VerifiedBuild`=56313 WHERE (`EffectIndex`=0 AND `ID` IN (281403,319030,312548,305891)) OR (`EffectIndex`=4 AND `ID`=305425);

DELETE FROM `gameobject` WHERE `guid` BETWEEN @OGUID+0 AND @OGUID+4;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `PhaseId`, `PhaseGroup`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `VerifiedBuild`) VALUES
(@OGUID+0, 339568, 2175, 10424, 10527, '0', '0', 0, 111.0572891235351562, -2217.923583984375, 32.95146942138671875, 2.87512826919555664, -0.18683481216430664, -0.06464099884033203, 0.973572731018066406, 0.114326126873493194, 120, 255, 0, 56313), -- Thick Cocoon (Area: Hrun's Barrow - Difficulty: 0) CreateObject1
(@OGUID+1, 339568, 2175, 10424, 10527, '0', '0', 0, 123.5694427490234375, -2238.923583984375, -5.86077213287353515, 1.357517719268798828, -0.07591676712036132, -0.08171272277832031, 0.622530937194824218, 0.774606287479400634, 120, 255, 0, 56313), -- Thick Cocoon (Area: Hrun's Barrow - Difficulty: 0) CreateObject1
(@OGUID+2, 339568, 2175, 10424, 10527, '0', '0', 0, 65.34201812744140625, -2276.59375, -0.66227895021438598, 0.820587992668151855, -0.15194892883300781, 0.1264801025390625, 0.4056396484375, 0.892396092414855957, 120, 255, 0, 56313), -- Thick Cocoon (Area: Hrun's Barrow - Difficulty: 0) CreateObject1
(@OGUID+3, 339568, 2175, 10424, 10527, '0', '0', 0, 80.48090362548828125, -2279.5244140625, 60.4192047119140625, 0.021085526794195175, -0.0907440185546875, 0.175644874572753906, 0.026347160339355468, 0.979908287525177001, 120, 255, 0, 56313), -- Thick Cocoon (Area: Hrun's Barrow - Difficulty: 0) CreateObject1
(@OGUID+4, 339568, 2175, 10424, 10527, '0', '0', 0, 36.02951431274414062, -2199.451416015625, 17.00921058654785156, 2.142104148864746093, -0.19759082794189453, 0.006606101989746093, 0.867940902709960937, 0.455623567104339599, 120, 255, 0, 56313); -- Thick Cocoon (Area: Hrun's Barrow - Difficulty: 0) CreateObject1

UPDATE `gameobject_template` SET `VerifiedBuild`=56313 WHERE `entry` = 339568;

DELETE FROM `gameobject_queststarter` WHERE (`id`=330627 AND `quest`=56839);
INSERT INTO `gameobject_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(330627, 56839, 56313); -- Killclaw the Terrible offered by Danger Sign 