-- Plaguefall: bind the missing Domina Venomblade boss AI.
-- NPC ID verified against TDB_full_world_1210.26091; no spawn data is added.

UPDATE `creature_template` SET `ScriptName` = 'boss_domina_venomblade' WHERE `entry` = 164266;
