-- DekkCore: Wandering Ancient should use one of its four random displays.

DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_wandering_ancient';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(348162, 'spell_wandering_ancient');
