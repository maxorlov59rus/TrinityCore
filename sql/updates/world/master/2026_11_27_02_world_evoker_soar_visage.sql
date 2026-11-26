DELETE FROM `spell_script_names` WHERE (`spell_id` = 369536 AND `ScriptName` = 'spell_evo_soar') OR (`spell_id` = 430747 AND `ScriptName` = 'spell_evo_soar_aura');
DELETE FROM `spell_script_names` WHERE `spell_id` = 351239 AND `ScriptName` = 'spell_evo_visage';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(369536, 'spell_evo_soar'),
(430747, 'spell_evo_soar_aura'),
(351239, 'spell_evo_visage');
