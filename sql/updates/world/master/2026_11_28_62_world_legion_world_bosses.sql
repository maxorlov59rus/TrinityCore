-- VERIFY: перенос стоковых мировых боссов Legion из DekkCore (dekk/main 3d052ac)
-- в штатный модуль BrokenIsles (регистрация в broken_isles_script_loader.cpp, без правки генерируемого ScriptLoader.cpp).
-- Источник скриптов: src/server/scripts/DekkCore/Legion/WorldBosses/.
-- Источник привязок: dekk/main -> base/world/spell_script_names.sql и base/world/creature_template.sql.
-- Сверено с клиентом 12.1.5.70077: SpellName.csv содержит все 14 перечисленных ID заклинаний.
-- В живой БД entry 99929, 108879, 109331, 109456, 110378, 112128, 117239, 117303, 121124 существуют,
-- но ScriptName пуст; конфликтующих привязок нет.
-- Локализация не требуется: новые BroadcastText, creature_text и *_locale не добавляются.
-- Спавны будут добавлены отдельным файлом после подтверждения координат источником.

-- Удаляем только свои строки, чтобы файл можно было применять повторно.
DELETE FROM `spell_script_names` WHERE (`spell_id`, `ScriptName`) IN (
    (216427, 'spell_humongris_fire_boom_target'),
    (216817, 'spell_humongris_you_go_bang'),
    (217893, 'spell_calamir_wf_target_picker'),
    (217986, 'spell_calamir_arcane_desolation_target'),
    (219493, 'spell_gen_snow_crash'),
    (220295, 'spell_flotsam_jetsam_target'),
    (220340, 'spell_flotsam_getsam_target'),
    (220367, 'spell_flotsam_getsam_damage'),
    (223357, 'spell_flotsam_oozing_bile_aura'),
    (223374, 'spell_flotsam_yaksam_target'),
    (233484, 'spell_brutallus_meteor_slash'),
    (233566, 'spell_brutallus_rupture'),
    (233614, 'spell_malificus_pestilence'),
    (241498, 'spell_apocron_felfir_missiles')
);

INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
    (216427, 'spell_humongris_fire_boom_target'),
    (216817, 'spell_humongris_you_go_bang'),
    (217893, 'spell_calamir_wf_target_picker'),
    (217986, 'spell_calamir_arcane_desolation_target'),
    (219493, 'spell_gen_snow_crash'),
    (220295, 'spell_flotsam_jetsam_target'),
    (220340, 'spell_flotsam_getsam_target'),
    (220367, 'spell_flotsam_getsam_damage'),
    (223357, 'spell_flotsam_oozing_bile_aura'),
    (223374, 'spell_flotsam_yaksam_target'),
    (233484, 'spell_brutallus_meteor_slash'),
    (233566, 'spell_brutallus_rupture'),
    (233614, 'spell_malificus_pestilence'),
    (241498, 'spell_apocron_felfir_missiles');

-- Привязки боссов и их помощников.
UPDATE `creature_template` SET `ScriptName` = 'boss_apocron'              WHERE `entry` = 121124;
UPDATE `creature_template` SET `ScriptName` = 'boss_world_brutallus'       WHERE `entry` = 117239;
UPDATE `creature_template` SET `ScriptName` = 'boss_calamir'               WHERE `entry` = 109331;
UPDATE `creature_template` SET `ScriptName` = 'npc_calamir_wrathful_flames' WHERE `entry` = 109456;
UPDATE `creature_template` SET `ScriptName` = 'boss_drugon_frostblood'     WHERE `entry` = 110378;
UPDATE `creature_template` SET `ScriptName` = 'boss_flotsam'               WHERE `entry` = 99929;
UPDATE `creature_template` SET `ScriptName` = 'npc_flotsam_regurgitated_marshstomper' WHERE `entry` = 112128;
UPDATE `creature_template` SET `ScriptName` = 'boss_humongris'             WHERE `entry` = 108879;
UPDATE `creature_template` SET `ScriptName` = 'boss_malificus'             WHERE `entry` = 117303;

-- VERIFY после применения:
-- SELECT spell_id, ScriptName FROM spell_script_names
--   WHERE spell_id IN (216427,216817,217893,217986,219493,220295,220340,220367,223357,223374,233484,233566,233614,241498);
-- Должно быть ровно 14 строк, по одной на каждый ID.
-- SELECT entry, ScriptName FROM creature_template
--   WHERE entry IN (99929,108879,109331,109456,110378,112128,117239,117303,121124);
-- Должно быть 9 строк с непустыми ScriptName, как в UPDATE выше.
