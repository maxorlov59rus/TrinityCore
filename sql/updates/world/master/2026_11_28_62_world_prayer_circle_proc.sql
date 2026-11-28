-- VERIFY: талант «Молитвенный круг» (Prayer Circle, SpellID 321377) для Holy-жреца в билде 12.1.5.70077.
-- Источник: https://github.com/TrinityCore/TrinityCore/issues/29039 — исходный SQL от 2023 года устарел
-- (сам автор пометил его как требующий проверки); https://github.com/TrinityCore/TrinityCore/issues/31424 —
-- исправленная версия, но закрыта с пометкой «no longer valid in 12.0.1». Ниже значения сверены с клиентскими
-- DB2 текущего билда (WOWSTATIC_12_1_5_70077):
--   Talent.db2 ID 21754: ClassID 5, SpecID 257, SpellID 321377 — талант существует;
--   SpellEffect.db2 ID 809044: SPELL_AURA_PROC_TRIGGER_SPELL (42) -> SpellID 321379 (бафф «Молитвенный круг»);
--   SpellAuraOptions.db2 ID 143179: ProcTypeMask1 0x4000 (PROC_FLAG_DEAL_HELPFUL_SPELL); при ProcFlags=0 TC
--     берёт это значение из DBC. ProcChance 612 = 0x200 | 100, TC читает младший байт как 100%;
--   SpellClassOptions.db2 SpellID 34861 (Holy Word: Sanctify): SpellClassSet 6, SpellClassMask0 0x10000000;
--     среди всех заклинаний SpellClassSet 6 бит 0x10000000 в SpellClassMask0 имеет только 34861.
-- Без строки spell_proc TC генерирует прок по умолчанию с пустой маской семейства и срабатывает от любого
-- подходящего заклинания, а не только от Holy Word: Sanctify.
-- Локализация не требуется: новые строки, BroadcastText и *_locale не добавляются.

-- Удаляем только свою строку, чтобы файл можно было применять повторно.
DELETE FROM `spell_proc` WHERE `SpellId` = 321377;
INSERT INTO `spell_proc`
  (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
   `ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`,
   `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`)
VALUES
  (321377, 0x00, 6, 0x10000000, 0x00000000, 0x00000000, 0x00000000,
   0x0, 0x0, 0x0, 0x2, 0x403, 0x0, 0x0, 0, 0, 0, 0);

-- VERIFY после применения:
-- SELECT SpellId, SpellFamilyName, SpellFamilyMask0, SpellPhaseMask, HitMask
-- FROM spell_proc WHERE SpellId = 321377;
-- Должна быть 1 строка: SpellFamilyName=6, SpellFamilyMask0=268435456, SpellPhaseMask=2, HitMask=1027.
