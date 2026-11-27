-- Nightborne racial: bind the missing server-side script.
-- Spell ID is verified against local client/DB data; no race-unlock, achievement,
-- spawn, GUID, script param, immunity/scaling or area-trigger rows are added.

DELETE FROM `spell_script_names` WHERE `spell_id` = 260364 OR `ScriptName` = 'spell_arcane_pulse';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
    (260364, 'spell_arcane_pulse');
