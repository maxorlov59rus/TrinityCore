-- Underrot: bind the missing Unbound Abomination encounter and its event helpers.
-- NPC and spell IDs are verified against TDB_full_world_1210.26091.
-- No spawn data, GUIDs, script params, immunity/scaling changes or area-trigger rows are added.

UPDATE `creature_template` SET `ScriptName` = 'boss_unbound_abomination' WHERE `entry` = 133007;
UPDATE `creature_template` SET `ScriptName` = 'npc_underrot_titan_keeper_hezrel' WHERE `entry` = 134419;
UPDATE `creature_template` SET `ScriptName` = 'npc_underrot_blood_visage' WHERE `entry` = 137103;
UPDATE `creature_template` SET `ScriptName` = 'npc_underrot_rotting_spore' WHERE `entry` = 137458;

DELETE FROM `spell_script_names` WHERE `ScriptName` IN (
    'aura_unbound_abomination_blood_barrier',
    'spell_underrot_vile_expulsion',
    'spell_underrot_cleansing_light',
    'aura_underrot_open_web_door'
);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
    (269185, 'aura_unbound_abomination_blood_barrier'),
    (269843, 'spell_underrot_vile_expulsion'),
    (269310, 'spell_underrot_cleansing_light'),
    (279271, 'aura_underrot_open_web_door');
