-- Issue #30177: Capacitor Totem must cast its stun shortly after being summoned.

DELETE FROM `smart_scripts` WHERE `entryorguid` = 61245 AND `source_type` = 0 AND `id` = 0 AND `link` = 0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(61245, 0, 0, 0, '', 63, 0, 100, 0, 0, 0, 0, 0, 0, '', 85, 118905, 0, 0, 0, 0, 0, 0, NULL, 1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Capacitor Totem - On Just Created - Self: Cast Spell 118905');

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 61245;
