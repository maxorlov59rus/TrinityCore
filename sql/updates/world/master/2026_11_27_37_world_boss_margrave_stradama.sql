-- Plaguefall: bind the missing Margrave Stradama boss AI.
-- NPC ID verified against TDB_full_world_1210.26091; no spawn data is added.

UPDATE `creature_template` SET `ScriptName` = 'boss_margrave_stradama' WHERE `entry` = 164267;
