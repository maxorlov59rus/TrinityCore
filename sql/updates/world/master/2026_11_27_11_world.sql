-- Eternity Surge: 359073 (standard), 382411 (improved) and 359077 (damage).
-- Ported from DragonCore.

DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('spell_evo_eternity_surge', 'spell_evo_improved_eternity_surge', 'spell_evo_eternity_surge_damage');
INSERT INTO `spell_script_names` (`SpellId`, `ScriptName`) VALUES
(359073, 'spell_evo_eternity_surge'),
(382411, 'spell_evo_improved_eternity_surge'),
(359077, 'spell_evo_eternity_surge_damage');
