-- Dracthyr стартовая цепочка (#30660): недостающие привязки квестодателей и квестополучателей.
-- Все ID ниже сверены с WPP-дампом V11_0_7_58867 и TDB_full_world_1210.26091.
-- Не добавляются спавны, GUID, фазы, карты, quest_template, quest_template_addon
-- и содержимое objectives: в TDB они уже присутствуют либо требуют отдельного подтверждения.

-- VERIFY (в этот SQL не включается):
--   карта 2570 из WPP помечена как "Child of 2444" и не может быть напрямую перенесена в TC;
--   поле PhaseId в WPP — строка из нескольких фаз, а в Target DB одно int-поле;
--   CreateObject2 с пометкой "!!! might be temporary spawn !!!" не является статическим спавном;
--   SET @CGUID := SET_VALUE_MANUALLY_HERE запрещает копировать WPP-GUID без перебазирования;
--   стартер/ендер для Alliance-ветки 65286, 66513, 65101 и NPC 193016/194028/194027/248563
--   остаются неподтверждёнными и в SQL не добавляются.

DELETE FROM `creature_queststarter` WHERE
    (`id`=190239 AND `quest`=65613) OR (`id`=190239 AND `quest`=65437) OR
    (`id`=189389 AND `quest`=66534) OR (`id`=189386 AND `quest`=66237) OR
    (`id`=191780 AND `quest`=65100) OR (`id`=182601 AND `quest`=65098) OR
    (`id`=182441 AND `quest`=65097) OR (`id`=184308 AND `quest`=65087) OR
    (`id`=182258 AND `quest`=65084) OR (`id`=182297 AND `quest`=65057) OR
    (`id`=182275 AND `quest`=65052) OR (`id`=186210 AND `quest`=65046) OR
    (`id`=182274 AND `quest`=65050) OR (`id`=182274 AND `quest`=65049) OR
    (`id`=181054 AND `quest`=65045) OR (`id`=184163 AND `quest`=65075) OR
    (`id`=184163 AND `quest`=66324) OR (`id`=184163 AND `quest`=65307) OR
    (`id`=184214 AND `quest`=65074) OR (`id`=184163 AND `quest`=65073) OR
    (`id`=184214 AND `quest`=65063) OR (`id`=181054 AND `quest`=65060) OR
    (`id`=192889 AND `quest`=65036) OR (`id`=181054 AND `quest`=64873) OR
    (`id`=182251 AND `quest`=65615) OR (`id`=184269 AND `quest`=64872) OR
    (`id`=186883 AND `quest`=64871) OR (`id`=181594 AND `quest`=64866) OR
    (`id`=181596 AND `quest`=64863) OR (`id`=181056 AND `quest`=64865) OR
    (`id`=181494 AND `quest`=64864) OR (`id`=187223 AND `quest`=64864);

INSERT INTO `creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
    (190239, 65613, 58867), -- Ebyssian — "An Iconic, Draconic Look"
    (190239, 65437, 58867), -- Ebyssian — "Aspectral Invitation"
    (189389, 66534, 58867), -- Scalecommander Cindrethresh — "Ground Leave"
    (189386, 66237, 58867), -- Spiritwalker Ebonhorn — "Spiritual Allies"
    (191780, 65100, 58867), -- Scalecommander Emberthal — "Final Orders"
    (182601, 65098, 58867), -- Wrathion — "The Consequence of Courage"
    (182441, 65097, 58867), -- Scalecommander Emberthal — "Run!"
    (184308, 65087, 58867), -- Scalecommander Sarkareth — "The Prize Inside"
    (182258, 65084, 58867), -- Scalecommander Emberthal — "The Froststone Vault"
    (182297, 65057, 58867), -- Scalecommander Sarkareth — "Rally to Emberthal"
    (182275, 65052, 58867), -- Scalecommander Azurathel — "The Ebon Scales"
    (186210, 65046, 58867), -- Dervishian — "The Primalists"
    (182274, 65050, 58867), -- Scalecommander Azurathel — "Conjured Army"
    (182274, 65049, 58867), -- Scalecommander Azurathel — "Tangle with the Tarasek"
    (181054, 65045, 58867), -- Scalecommander Emberthal — "Stormsunder Crater"
    (184163, 65075, 58867), -- Scalecommander Viridia — "The Healing Wings"
    (184163, 66324, 58867), -- Scalecommander Viridia — "Never Forgotten"
    (184163, 65307, 58867), -- Scalecommander Viridia — "Mercy First"
    (184214, 65074, 58867), -- Scalecommander Cindrethresh — "Easy Prey"
    (184163, 65073, 58867), -- Scalecommander Viridia — "A Toxic Problem"
    (184214, 65063, 58867), -- Scalecommander Cindrethresh — "Into the Hive"
    (181054, 65060, 58867), -- Scalecommander Emberthal — "Caldera of the Menders"
    (192889, 65036, 58867), -- Dervishian — "Train Like We Fight"
    (181054, 64873, 58867), -- Scalecommander Emberthal — "Stretch Your Wings"
    (182251, 65615, 58867), -- Scalecommander Azurathel — "Arcane Intrusion"
    (184269, 64872, 58867), -- Scalecommander Cindrethresh — "The Fire Within"
    (186883, 64871, 58867), -- Scalecommander Cindrethresh — "The Dragon at the Door"
    (181594, 64866, 58867), -- Scalecommander Azurathel — "Into the Cauldron"
    (181596, 64863, 58867), -- Dervishian — "Arcane Guardians"
    (181056, 64865, 58867), -- Scalecommander Azurathel — "Gear Up"
    (181494, 64864, 58867), -- Dervishian — "Awaken, Dracthyr"
    (187223, 64864, 58867); -- Kodethi — "Awaken, Dracthyr"

DELETE FROM `creature_questender` WHERE
    (`id`=190239 AND `quest`=65613) OR (`id`=190239 AND `quest`=65437) OR
    (`id`=184786 AND `quest`=66534) OR (`id`=189389 AND `quest`=66237) OR
    (`id`=182612 AND `quest`=65100) OR (`id`=191780 AND `quest`=65098) OR
    (`id`=182601 AND `quest`=65097) OR (`id`=184308 AND `quest`=65087) OR
    (`id`=184308 AND `quest`=65084) OR (`id`=181054 AND `quest`=65057) OR
    (`id`=182297 AND `quest`=65052) OR (`id`=182275 AND `quest`=65050) OR
    (`id`=182275 AND `quest`=65049) OR (`id`=186218 AND `quest`=65046) OR
    (`id`=182274 AND `quest`=65045) OR (`id`=198429 AND `quest`=72263) OR
    (`id`=181054 AND `quest`=65075) OR (`id`=184163 AND `quest`=66324) OR
    (`id`=184163 AND `quest`=65307) OR (`id`=184163 AND `quest`=65073) OR
    (`id`=184214 AND `quest`=65074) OR (`id`=184163 AND `quest`=65063) OR
    (`id`=184214 AND `quest`=65060) OR (`id`=181054 AND `quest`=65036) OR
    (`id`=192889 AND `quest`=64873) OR (`id`=182251 AND `quest`=65615) OR
    (`id`=184269 AND `quest`=64872) OR (`id`=184269 AND `quest`=64871) OR
    (`id`=182168 AND `quest`=64866) OR (`id`=181594 AND `quest`=64865) OR
    (`id`=182069 AND `quest`=64863) OR (`id`=181056 AND `quest`=64864);

INSERT INTO `creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
    (190239, 65613, 58867), -- Ebyssian — "An Iconic, Draconic Look"
    (190239, 65437, 58867), -- Ebyssian — "Aspectral Invitation"
    (184786, 66534, 58867), -- Scalecommander Cindrethresh — "Ground Leave"
    (189389, 66237, 58867), -- Scalecommander Cindrethresh — "Spiritual Allies"
    (182612, 65100, 58867), -- Scalecommander Cindrethresh — "Final Orders"
    (191780, 65098, 58867), -- Scalecommander Emberthal — "The Consequence of Courage"
    (182601, 65097, 58867), -- Wrathion — "Run!"
    (184308, 65087, 58867), -- Scalecommander Sarkareth — "The Prize Inside"
    (184308, 65084, 58867), -- Scalecommander Sarkareth — "The Froststone Vault"
    (181054, 65057, 58867), -- Scalecommander Emberthal — "Rally to Emberthal"
    (182297, 65052, 58867), -- Scalecommander Sarkareth — "The Ebon Scales"
    (182275, 65050, 58867), -- Scalecommander Azurathel — "Conjured Army"
    (182275, 65049, 58867), -- Scalecommander Azurathel — "Tangle with the Tarasek"
    (186218, 65046, 58867), -- Dervishian — "The Primalists"
    (182274, 65045, 58867), -- Scalecommander Azurathel — "Stormsunder Crater"
    (198429, 72263, 58867), -- Treysh — "Cavalry Has Its Place"
    (181054, 65075, 58867), -- Scalecommander Emberthal — "The Healing Wings"
    (184163, 66324, 58867), -- Scalecommander Viridia — "Never Forgotten"
    (184163, 65307, 58867), -- Scalecommander Viridia — "Mercy First"
    (184163, 65073, 58867), -- Scalecommander Viridia — "A Toxic Problem"
    (184214, 65074, 58867), -- Scalecommander Cindrethresh — "Easy Prey"
    (184163, 65063, 58867), -- Scalecommander Viridia — "Into the Hive"
    (184214, 65060, 58867), -- Scalecommander Cindrethresh — "Caldera of the Menders"
    (181054, 65036, 58867), -- Scalecommander Emberthal — "Train Like We Fight"
    (192889, 64873, 58867), -- Dervishian — "Stretch Your Wings"
    (182251, 65615, 58867), -- Scalecommander Azurathel — "Arcane Intrusion"
    (184269, 64872, 58867), -- Scalecommander Cindrethresh — "The Fire Within"
    (184269, 64871, 58867), -- Scalecommander Cindrethresh — "The Dragon at the Door"
    (182168, 64866, 58867), -- Scalecommander Azurathel — "Into the Cauldron"
    (181594, 64865, 58867), -- Scalecommander Azurathel — "Gear Up"
    (182069, 64863, 58867), -- Dervishian — "Arcane Guardians"
    (181056, 64864, 58867); -- Scalecommander Azurathel — "Awaken, Dracthyr"
