-- Issue #31479: Shattered Psyche should be applied only by Mind Flay and consumed by Mind Blast.

DELETE FROM `spell_proc` WHERE `SpellId` IN (391090, 391092);
INSERT INTO `spell_proc` (`SpellId`,`SchoolMask`,`SpellFamilyName`,`SpellFamilyMask0`,`SpellFamilyMask1`,`SpellFamilyMask2`,`SpellFamilyMask3`,`ProcFlags`,`ProcFlags2`,`SpellTypeMask`,`SpellPhaseMask`,`HitMask`,`AttributesMask`,`DisableEffectsMask`,`ProcsPerMinute`,`Chance`,`Cooldown`,`Charges`) VALUES
(391090,0x00,6,0x00000000,0x00000000,0x00000040,0x00000000,0x0,0x0,0x0,0x2,0x0,0x0,0x0,0,0,0,0), -- Shattered Psyche
(391092,0x00,6,0x00002000,0x00000000,0x00000000,0x00000000,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0,0,0,1); -- Shattered Psyche
