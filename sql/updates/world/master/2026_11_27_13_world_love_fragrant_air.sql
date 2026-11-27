-- Love is in the Air: Fragrant Air Analysis removes the heavily perfumed aura
-- from the target, completing the "Something Stinks" objective.

DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_love_is_in_the_air_fragrant_air_analysis';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(70192, 'spell_love_is_in_the_air_fragrant_air_analysis');
