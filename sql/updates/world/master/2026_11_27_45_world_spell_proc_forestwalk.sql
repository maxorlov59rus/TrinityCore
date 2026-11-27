-- Issue #31425: Forestwalk должна срабатывать только после успешного наложения Regrowth.

DELETE FROM `spell_proc` WHERE `SpellId` = 400129;
INSERT INTO `spell_proc` (`SpellId`,`SchoolMask`,`SpellFamilyName`,`SpellFamilyMask0`,`SpellFamilyMask1`,`SpellFamilyMask2`,`SpellFamilyMask3`,`ProcFlags`,`ProcFlags2`,`SpellTypeMask`,`SpellPhaseMask`,`HitMask`,`AttributesMask`,`DisableEffectsMask`,`ProcsPerMinute`,`Chance`,`Cooldown`,`Charges`) VALUES
(400129,0x00,7,0x00000040,0x00000000,0x00000000,0x00000000,0x0,0x0,0x0,0x1,0x403,0x0,0x0,0,0,0,0); -- Forestwalk
