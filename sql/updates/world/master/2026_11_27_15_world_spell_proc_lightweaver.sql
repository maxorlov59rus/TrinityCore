-- Issue #31459: Lightweaver should stack from Flash Heal and be consumed by Prayer of Healing or Heal.

DELETE FROM `spell_proc` WHERE `SpellId` IN (390992, 390993);
INSERT INTO `spell_proc` (`SpellId`,`SchoolMask`,`SpellFamilyName`,`SpellFamilyMask0`,`SpellFamilyMask1`,`SpellFamilyMask2`,`SpellFamilyMask3`,`ProcFlags`,`ProcFlags2`,`SpellTypeMask`,`SpellPhaseMask`,`HitMask`,`AttributesMask`,`DisableEffectsMask`,`ProcsPerMinute`,`Chance`,`Cooldown`,`Charges`) VALUES
(390992,0x00,6,0x00000800,0x00000000,0x00000000,0x00000000,0x0,0x0,0x2,0x2,0x403,0x0,0x0,0,0,0,0), -- Lightweaver
(390993,0x00,6,0x00001200,0x00000000,0x00000000,0x00000000,0x0,0x0,0x2,0x1,0x403,0x10,0x0,0,0,0,0); -- Lightweaver
