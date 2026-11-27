-- Lightforged Draenei racials: bind the missing server-side scripts.
-- Spell IDs are verified against local client/DB data; no spawns, GUIDs, script params,
-- immunity/scaling changes or area-trigger rows are added.

DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('spell_light_judgement', 'aura_light_reckoning');
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
    (256893, 'spell_light_judgement'),
    (255652, 'aura_light_reckoning');
