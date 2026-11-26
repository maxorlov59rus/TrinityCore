-- 206491 Nemesis: grant the matching creature-type damage bonus when the
-- marked target dies. Ported from RoleplayCore/BfaCore-Reforged.

DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_dh_nemesis';
INSERT INTO `spell_script_names` (`SpellId`, `ScriptName`) VALUES
(206491, 'spell_dh_nemesis');
