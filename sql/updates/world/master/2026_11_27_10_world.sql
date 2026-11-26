-- 18562 Swiftmend: Soul of the Forest, Verdant Infusion HoT extension and
-- Reflorescence/Incarnation handling. Ported from DragonCore.

DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_dru_swiftmend';
INSERT INTO `spell_script_names` (`SpellId`, `ScriptName`) VALUES
(18562, 'spell_dru_swiftmend');
