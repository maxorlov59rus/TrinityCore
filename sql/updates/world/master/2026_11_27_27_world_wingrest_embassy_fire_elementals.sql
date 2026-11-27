-- Configure these to the numbers you want to use
SET @CGUID := 12000000;
SET @WAYPOINTID := 720400000;

-- Base spawn data for the creatures here
DELETE FROM `creature` WHERE `guid` BETWEEN @CGUID+0 AND @CGUID+66;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES 
(@CGUID+0, 187321, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3503.23, -1324.2, 103.915, 6.21176, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+1, 187321, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3474.28, -1324.03, 103.819, 0.566772, 300, 0, 0, 100, 2, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+2, 187321, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3424.79, -1380.8, 102.257, 3.23804, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+3, 187321, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3416.56, -1374.85, 103.34, 4.86622, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+4, 187321, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3468.09, -1279.61, 104.343, 5.3595, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+5, 187321, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3553.85, -1261.3, 111.697, 2.74062, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+6, 187321, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3494.13, -1251.99, 111.175, 2.74062, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+7, 187321, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3396.14, -1276.9, 105.614, 5.70634, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+8, 187321, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3576.83, -1227.04, 123.64, 1.62867, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+9, 187321, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3624.44, -1212.46, 136.484, 3.50626, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+10, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3557.15, -1306.12, 113.007, 0.871464, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+11, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3559, -1303.78, 112.982, 3.88826, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+12, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3586.67, -1299.39, 118.782, 3.59133, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+13, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3584.48, -1297.13, 117.959, 2.39405, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+14, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3582.11, -1289.74, 117.465, 0.287106, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+15, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3413.45, -1319.68, 108.131, 6.00157, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+16, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3416.5, -1312.94, 106.965, 2.17635, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+17, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3412.18, -1314.51, 107.594, 4.85775, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+18, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3512.31, -1273.02, 105.885, 6.12015, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+19, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3505.08, -1277.36, 104.762, 1.91396, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+20, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3577.15, -1202.85, 130.296, 0.321751, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+21, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3583.3, -1201.04, 131.024, 2.69716, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+22, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3579.89, -1197.34, 131.176, 5.97934, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+23, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3616.44, -1241.9, 134.309, 4.31519, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+24, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3620.64, -1235.6, 136.637, 4.34598, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+25, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3627.08, -1233.33, 138.39, 0.355307, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+26, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3567.7, -1172.63, 140.572, 3.30626, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+27, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3576.01, -1170.56, 142.761, 2.47661, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+28, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3581.06, -1165.5, 144.635, 4.76615, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+29, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3644.41, -1207.05, 141.564, 2.08994, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+30, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3654.17, -1202.96, 144.917, 4.84668, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+31, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3647.86, -1197.35, 141.707, 6.02636, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+32, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3509.07, -1273.96, 105.521, 2.75615, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+33, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3552.36, -1237.05, 117.222, 2.13568, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+34, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3541.63, -1240.52, 116.871, 0.398681, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+35, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3546.57, -1240.54, 116.527, 4.66066, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+36, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3527.59, -1279.72, 103.928, 4.09689, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+37, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3531.95, -1283.69, 103.927, 5.06183, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+38, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3523.9, -1278.28, 104.059, 0.586896, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+39, 187326, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3555.22, -1308.42, 112.759, 3.19433, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+40, 191946, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3430.54, -1362.06, 100.504, 6.15188, 7200, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+41, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3436.25, -1359.88, 99.9995, 1.85525, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+42, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3493.75, -1323.22, 103.895, 1.282, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+43, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3585.52, -1290.92, 118.315, 5.13495, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+44, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3410.99, -1305.38, 106.457, 1.58608, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+45, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3420.83, -1270.61, 105.181, 0.817185, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+46, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3523.97, -1264.97, 107.772, 0.178631, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+47, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3594.66, -1227.65, 125.925, 4.99166, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+48, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3520.05, -1192.64, 165.386, 4.79045, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+49, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3549.2, -1174.29, 139.01, 2.51886, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+50, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3617.39, -1195.38, 135.634, 6.12488, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+51, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3591.67, -1158.33, 145.753, 3.46072, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+52, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3647.06, -1275.75, 165.858, 0.768612, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+53, 192137, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3659.62, -1205.08, 146.542, 0.367905, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+54, 192227, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3478.47, -1342.96, 105.433, 5.46742, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+55, 192227, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3479.97, -1339.05, 104.033, 3.22216, 300, 4, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+56, 192227, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3473.29, -1336.29, 104.358, 0.313165, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+57, 192227, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3478.01, -1341.9, 104.101, 3.85971, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+58, 192274, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3618.57, -1162.92, 138.735, 4.43492, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+59, 193001, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3517.92, -1313.2, 104.102, 0, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+60, 193001, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3420.68, -1320.84, 106.568, 0, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+61, 193001, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3519.23, -1252.47, 111.221, 0, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+62, 193001, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3596.1, -1171.59, 141.71, 0, 300, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+63, 193026, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3473.32, -1391.45, 97.3246, 0, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+64, 193026, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3545.85, -1309.23, 111.091, 0, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+65, 193026, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3578.72, -1281.51, 117.205, 0, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451),
(@CGUID+66, 193026, 2444, 13644, 13939, '0', 0, 0, 0, -1, 0, 0, 3584.1, -1189.98, 134.229, 0, 300, 3, 0, 100, 1, NULL, NULL, NULL, NULL, '', NULL, 67451);


-- Adding SmartAI to these creatures so they can use smart_scripts
UPDATE creature_template SET `AIName` = 'SmartAI' WHERE `Entry` IN (192227, 187321, 192274);

-- creature_addons
DELETE FROM `creature_addon` WHERE `guid` BETWEEN @CGUID+1 AND @CGUID+3;
INSERT INTO `creature_addon` (`guid`, `PathId`, `mount`, `MountCreatureID`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`, `PvPFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES 
(@CGUID+1, @WAYPOINTID+0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, NULL),
(@CGUID+2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '151597'),
(@CGUID+3, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '151597');

-- Template_addon
DELETE FROM `creature_template_addon` WHERE entry IN (187321, 187326, 191946, 192227);
INSERT INTO `creature_template_addon` (`entry`, `PathId`, `mount`, `MountCreatureID`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`, `PvPFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES 
(187321, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '376861'),
(187326, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '370034'),
(191946, 0, 0, 0, 0, 0, 4, 1, 0, 0, 0, 0, 0, 0, '159474 376838'),
(192227, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '370034');

-- Sparring data, used by the elementals at the cave that are supposed to be fighting an earth ele.
DELETE FROM `creature_template_sparring` WHERE `Entry`=187321 AND `NoNPCDamageBelowHealthPct`=45;
INSERT INTO `creature_template_sparring` (`Entry`, `NoNPCDamageBelowHealthPct`) VALUES (187321, 45);

DELETE FROM `smart_scripts` WHERE `entryorguid`=-(@CGUID+57) AND `source_type`=0 AND `id`=0 AND `link`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES (-(@CGUID+57), 0, 0, 0, '', 11, 0, 100, 0, 0, 0, 0, 0, 0, '', 53, 0, @WAYPOINTID+1, 0, 0, 0, 0, 0, NULL, 1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Encroaching Lava - Walk to Wingrest Embassy');
DELETE FROM `smart_scripts` WHERE `entryorguid`=-(@CGUID+56) AND `source_type`=0 AND `id`=0 AND `link`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES (-(@CGUID+56), 0, 0, 0, '', 11, 0, 100, 0, 0, 0, 0, 0, 0, '', 53, 0, @WAYPOINTID+2, 0, 0, 0, 0, 0, NULL, 1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Encroaching Lava - Walk to Wingrest Embassy');
DELETE FROM `smart_scripts` WHERE `entryorguid`=-(@CGUID+3) AND `source_type`=0 AND `id`=1 AND `link`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES (-(@CGUID+3), 0, 1, 0, '', 0, 0, 100, 0, 4000, 8000, 14000, 18000, 0, '', 11, 383237, 0, 0, 0, 0, 0, 0, NULL, 2, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Primal Lava Elemental -  Cast Molten Gash in combat');
DELETE FROM `smart_scripts` WHERE `entryorguid`=-(@CGUID+2) AND `source_type`=0 AND `id`=1 AND `link`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES (-(@CGUID+2), 0, 1, 0, '', 0, 0, 100, 0, 4000, 8000, 14000, 18000, 0, '', 11, 383237, 0, 0, 0, 0, 0, 0, NULL, 2, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Primal Lava Elemental -  Cast Molten Gash in combat');
DELETE FROM `smart_scripts` WHERE `entryorguid`=-(@CGUID+1) AND `source_type`=0 AND `id`=1 AND `link`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES (-(@CGUID+1), 0, 1, 0, '', 0, 0, 100, 0, 4000, 8000, 14000, 18000, 0, '', 11, 383237, 0, 0, 0, 0, 0, 0, NULL, 2, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Primal Lava Elemental -  Cast Molten Gash in combat');
DELETE FROM `smart_scripts` WHERE `entryorguid`=187321 AND `source_type`=0 AND `id` IN (0, 1) AND `link`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES 
(187321, 0, 0, 0, '', 25, 0, 100, 0, 0, 0, 0, 0, 0, '', 11, 376861, 0, 0, 0, 0, 0, 0, NULL, 1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Primal Lava Elemental -  Cast Channel: Lava (ChannelCastOmni) [DNT] on Reset'),
(187321, 0, 1, 0, '', 0, 0, 100, 0, 4000, 8000, 14000, 18000, 0, '', 11, 383237, 0, 0, 0, 0, 0, 0, NULL, 2, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Primal Lava Elemental -  Cast Molten Gash in combat');
DELETE FROM `smart_scripts` WHERE `entryorguid`=192274 AND `source_type`=0 AND `id` IN (0, 1, 2, 3) AND `link`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES 
(192274, 0, 0, 0, '', 25, 0, 100, 0, 0, 0, 0, 0, 0, '', 11, 376765, 0, 0, 0, 0, 0, 0, NULL, 1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Baron Ashflow -  Cast Channel: Lavastorm [DNT] on Reset'),
(192274, 0, 1, 0, '', 0, 0, 100, 0, 500, 500, 32000, 32000, 0, '', 11, 394643, 0, 0, 0, 0, 0, 0, NULL, 1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Baron Ashflow - Cast Burning Nova in Combat'),
(192274, 0, 2, 0, '', 0, 0, 100, 0, 9000, 9000, 20000, 20000, 0, '', 11, 383864, 0, 0, 0, 0, 0, 0, NULL, 1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Baron Ashflow - Cast Summon Droplet  in Combat'),
(192274, 0, 3, 0, '', 0, 0, 100, 0, 13000, 13000, 3000, 3000, 0, '', 11, 371618, 0, 0, 0, 0, 0, 0, NULL, 2, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Baron Ashflow - Cast Lava Bolt in Combat');

-- Waypoints
DELETE FROM `waypoint_path` WHERE `PathID` BETWEEN @WAYPOINTID+0 AND @WAYPOINTID+2;
INSERT INTO `waypoint_path` (`PathId`, `MoveType`, `Flags`, `Velocity`, `Comment`) VALUES 
(@WAYPOINTID+0, 0, 0, NULL, '187321 (Primal Lava Elemental)'),
(@WAYPOINTID+1, 0, 0, NULL, '192227 (Encroaching Lava)'),
(@WAYPOINTID+2, 0, 0, NULL, '192227 (Encroaching Lava)');

DELETE FROM `waypoint_path_node` WHERE `PathID` BETWEEN @WAYPOINTID+0 AND @WAYPOINTID+2;
INSERT INTO `waypoint_path_node` (`PathId`, `NodeId`, `PositionX`, `PositionY`, `PositionZ`, `Orientation`, `Delay`) VALUES 
(@WAYPOINTID+0, 1, 3472.14, -1325.27, 103.461, NULL, 0),
(@WAYPOINTID+0, 2, 3477.45, -1325.28, 103.889, NULL, 0),
(@WAYPOINTID+0, 3, 3489.36, -1316.07, 104.832, NULL, 0),
(@WAYPOINTID+0, 4, 3497.2, -1309.71, 104.672, NULL, 0),
(@WAYPOINTID+0, 5, 3509.48, -1304.64, 105.302, NULL, 0),
(@WAYPOINTID+0, 6, 3523.05, -1298.81, 104.284, NULL, 0),
(@WAYPOINTID+0, 7, 3509.48, -1304.64, 105.302, NULL, 0),
(@WAYPOINTID+0, 8, 3497.2, -1309.71, 104.672, NULL, 0),
(@WAYPOINTID+0, 9, 3489.36, -1316.07, 104.832, NULL, 0),
(@WAYPOINTID+0, 10, 3477.45, -1325.28, 103.889, NULL, 0),
(@WAYPOINTID+0, 11, 3472.14, -1325.27, 103.461, NULL, 0),
(@WAYPOINTID+1, 1, 3473.89, -1339.44, 103.78, NULL, 0),
(@WAYPOINTID+1, 2, 3468.53, -1342.27, 101.57, NULL, 0),
(@WAYPOINTID+1, 3, 3463.48, -1351.12, 99.29, NULL, 0),
(@WAYPOINTID+1, 4, 3477.08, -1368.79, 97.3118, NULL, 0),
(@WAYPOINTID+1, 5, 3490.24, -1377.65, 94.8145, NULL, 0),
(@WAYPOINTID+1, 6, 3495.47, -1381.69, 94.182, NULL, 0),
(@WAYPOINTID+2, 1, 3464.59, -1344.56, 100.59, NULL, 0),
(@WAYPOINTID+2, 2, 3460.93, -1354.79, 98.87, NULL, 0),
(@WAYPOINTID+2, 3, 3465.87, -1375.23, 97.78, NULL, 0),
(@WAYPOINTID+2, 4, 3478.62, -1387.92, 96.02, NULL, 0),
(@WAYPOINTID+2, 5, 3487.33, -1395.37, 94.45, NULL, 0);