-- DekkCore: Mechagnome racial Emergency should heal at low health and grant the follow-up aura.

DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('spell_class_mecagnomo_emergency', 'spell_class_mecagnomo_emergency2', 'spell_class_mecagnomo_emergency3');
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(312916, 'spell_class_mecagnomo_emergency'),
(313015, 'spell_class_mecagnomo_emergency2'),
(313010, 'spell_class_mecagnomo_emergency3');
