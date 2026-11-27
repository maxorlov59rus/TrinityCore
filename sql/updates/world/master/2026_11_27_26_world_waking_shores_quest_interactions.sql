-- DekkCore: bind Waking Shores quest interaction objects and NPCs to their scripts.
-- The custom teleporter NPC 19999999 is intentionally not ported (absent from TDB).

UPDATE `gameobject_template` SET `ScriptName` = 'go_protodragon_rib_cage' WHERE `entry` = 376502 AND `ScriptName` = '';
UPDATE `gameobject_template` SET `ScriptName` = 'go_protodragon_rib_cage_379137' WHERE `entry` = 379137 AND `ScriptName` = '';
UPDATE `gameobject_template` SET `ScriptName` = 'go_titanic_comedy' WHERE `entry` = 376941 AND `ScriptName` = '';
UPDATE `gameobject_template` SET `ScriptName` = 'go_scales_of_wrath' WHERE `entry` = 376942 AND `ScriptName` = '';
UPDATE `gameobject_template` SET `ScriptName` = 'go_Dracuixote' WHERE `entry` = 376943 AND `ScriptName` = '';
UPDATE `gameobject_template` SET `ScriptName` = 'go_lord_of_the_wings' WHERE `entry` = 376944 AND `ScriptName` = '';
UPDATE `gameobject_template` SET `ScriptName` = 'go_red_and_black_flights' WHERE `entry` = 376945 AND `ScriptName` = '';
UPDATE `gameobject_template` SET `ScriptName` = 'go_pride_and_protodrakes' WHERE `entry` = 376946 AND `ScriptName` = '';
UPDATE `gameobject_template` SET `ScriptName` = 'go_earthwardersforge_377013' WHERE `entry` = 377013 AND `ScriptName` = '';

UPDATE `creature_template` SET `ScriptName` = 'npc_ruby_egg_guardian' WHERE `entry` = 190171 AND `ScriptName` = '';
UPDATE `creature_template` SET `ScriptName` = 'npc_surveyors_disk' WHERE `entry` = 193707 AND `ScriptName` = '';
UPDATE `creature_template` SET `ScriptName` = 'npc_caretaker_azkra190155' WHERE `entry` = 190155 AND `ScriptName` = '';
