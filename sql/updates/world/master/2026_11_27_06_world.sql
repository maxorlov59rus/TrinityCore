-- Allied Race details contact at the Stormwind Embassy.
-- The "Allied Race" template exists in TDB but has no spawn; give it a gossip
-- flag, a friendly embassy faction and a ScriptName, then place it in the
-- embassy next to the existing recruitment NPCs.

UPDATE `creature_template`
SET `faction` = 1733,
    `npcflag` = `npcflag` | 1,
    `ScriptName` = 'npc_allied_race_details'
WHERE `entry` = 133342;

DELETE FROM `creature` WHERE `guid` = 9900501;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `PhaseId`, `PhaseGroup`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `MovementType`, `VerifiedBuild`)
VALUES (9900501, 133342, 0, 1519, 9171, '0', 0, 0, 0, 0, -8185.0, 790.0, 74.05, 1.6, 300, 0, 0, 0);
