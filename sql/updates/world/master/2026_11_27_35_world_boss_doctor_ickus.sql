-- Plaguefall: bind the missing Doctor Ickus boss AI and its Slime Injection aura script.
-- IDs verified against TDB_full_world_1210.26091; no spawn data is added.

DELETE FROM `spell_script_names` WHERE `ScriptName` = 'aura_slime_injection';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(329110, 'aura_slime_injection');

UPDATE `creature_template` SET `ScriptName` = 'boss_doctor_ickus' WHERE `entry` = 164967;
