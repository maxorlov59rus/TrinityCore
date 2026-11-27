-- DekkCore: Deepholm Construct Reactivation should grant credit for Slaves of the Earth.

DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_deepholm_kill_all_constructs';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(65109, 'spell_deepholm_kill_all_constructs');
