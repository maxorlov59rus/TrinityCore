-- Westfall Stew: bind the rewritten unified citizen AI and the Sentinel Hill scene scripts.
UPDATE `creature_template` SET `ScriptName`='npc_westfall_westfall_citizen' WHERE `entry` IN (42383, 42384, 42386, 42391, 42400);
UPDATE `creature` SET `ScriptName`='npc_westfall_westfall_citizen_quiet' WHERE `guid`=274913;
UPDATE `creature` SET `ScriptName`='npc_westfall_refugee_bridge_to_sentinelhill' WHERE `guid`=280420;
UPDATE `creature` SET `ScriptName`='npc_westfall_west_plains_drifter_walk_to_sentinel' WHERE `guid`=280419;

-- Exiles Reach: bind the Who Lurks in the Pit (55639) rescue scripts.
UPDATE `creature_template` SET `ScriptName`='npc_ralia_dreamchaser_q55639' WHERE `entry`=156929;
UPDATE `creature_template` SET `ScriptName`='npc_hrun_the_exiled_q55639' WHERE `entry`=156900;
