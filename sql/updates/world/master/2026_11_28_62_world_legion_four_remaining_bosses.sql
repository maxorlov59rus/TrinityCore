-- VERIFY: четыре оставшихся босса из DekkCore/Legion/WorldBosses портированы в module BrokenIsles.
-- ScriptName и spell-биндинги сверены с DekkCore sql/base/world/creature_template.sql
-- и sql/base/world/spell_script_names.sql; entry/spell ID сверены с живой БД world и клиентским SpellName.csv (build 12.1.5.70077).
-- Конфликтующих привязок в живой БД нет. AT 7053 и 7411 не привязываются: отсутствуют в клиентском AreaTrigger.csv и в живой БД.
--
-- Источники координат (не вычислены и не выдуманы):
--   Nithogg 107544 — точная строка DekkCore sql/base/world/creature.sql:
--       (20533575, 107544, 1220, 7541, 8095, ..., 4011.56, 2342.61, 359.911, 2.20438, 3600, ...)
--   Levantus, Shar'thos, The Soultakers, Ana-Mouz, Na'zak — полная БД WarAxe_Legion 7.3.5
--       (sql/base/world_1.0.0.rar, таблица creature, map 1220).
--   Точность источника проверена по Withered J'im 102075: координаты WarAxe совпадают
--   с уже применённой строкой DekkCore в пределах нескольких метров.
-- Локализация не требуется: новых BroadcastText, creature_text и *_locale нет.
--
-- Ana-Mouz и Na'zak уже привязаны в 2026_11_28_62_world_legion_remaining_bosses.sql;
-- здесь добавляются только их спавны из WarAxe_Legion.

-- Идемпотентно: удаляем только наши строки spell-биндингов.
DELETE FROM `spell_script_names` WHERE (`spell_id`, `ScriptName`) IN (
    (212836, 'spell_nithogg_tail_lash'),
    (212837, 'spell_nithogg_crackling_jolt_target'),
    (212867, 'spell_nithogg_electrical_storm_target'),
    (212889, 'spell_nithogg_static_charge_summon')
);

INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
    (212836, 'spell_nithogg_tail_lash'),
    (212837, 'spell_nithogg_crackling_jolt_target'),
    (212867, 'spell_nithogg_electrical_storm_target'),
    (212889, 'spell_nithogg_static_charge_summon');

-- Привязки NPC.
UPDATE `creature_template` SET `ScriptName` = 'boss_levantus'               WHERE `entry` = 108829;
UPDATE `creature_template` SET `ScriptName` = 'boss_nithogg'                WHERE `entry` = 107544;
UPDATE `creature_template` SET `ScriptName` = 'npc_nithogg_electrical_storm' WHERE `entry` = 107338;
UPDATE `creature_template` SET `ScriptName` = 'npc_nithogg_static_orb'      WHERE `entry` = 107353;
UPDATE `creature_template` SET `ScriptName` = 'boss_sharthos'               WHERE `entry` = 108678;
UPDATE `creature_template` SET `ScriptName` = 'boss_soultakers'             WHERE `entry` = 106981;
UPDATE `creature_template` SET `ScriptName` = 'boss_soultakers'             WHERE `entry` = 106982;
UPDATE `creature_template` SET `ScriptName` = 'boss_soultakers'             WHERE `entry` = 106984;

-- 107023 — альтернативная запись Nithogg без ScriptName в DekkCore; не привязываем и не спавним.
-- 212841 (spell_nithogg_crackling_jolt_damage) в порте отсутствует (Register() пустой) — не привязываем.

-- Спавны: идемпотентно удаляем только наши entry, затем вставляем фиксированные GUID.
DELETE FROM `creature` WHERE `id` IN (108829, 107544, 108678, 106981, 106982, 106984, 109943, 110321);

INSERT INTO `creature`
(`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(3530000000003063, 108829, 1220, 7334, 8274, '0', 0, 0, 0, -1, 0, 0, -1161.93, 6992.62, 0.0230616, 0.386672, 60, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Levantus — Litduin Reef, Azsuna
(3530000000003064, 107544, 1220, 7541, 8095, '0', 0, 0, 0, -1, 0, 0, 4011.56, 2342.61, 359.911, 2.20438, 3600, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Nithogg — Nastrondir, Stormheim; точная строка DekkCore
(3530000000003065, 108678, 1220, 7558, 8333, '0', 0, 0, 0, -1, 0, 0, 3383.60, 6552.63, 201.299, 3.98227, 60, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Shar'thos — Val'sharah
(3530000000003066, 106981, 1220, 7541, 7857, '0', 0, 0, 0, -1, 0, 0, 4861.92, 510.399, -48.9026, 2.34603, 60, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Captain Hring — The Soultakers, Stormheim
(3530000000003067, 106982, 1220, 7541, 7857, '0', 0, 0, 0, -1, 0, 0, 4890.91, 506.204, -48.9026, 0.441436, 60, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Reaver Jdorn — The Soultakers, Stormheim
(3530000000003068, 106984, 1220, 7541, 7857, '0', 0, 0, 0, -1, 0, 0, 4878.42, 520.085, -48.9026, 1.41297, 60, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Soultrapper Mevra — The Soultakers, Stormheim
(3530000000003069, 109943, 1220, 7637, 7844, '0', 0, 0, 0, -1, 0, 0, 1003.75, 4932.03, 32.7195, 5.54974, 60, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Ana-Mouz — Highmountain
(3530000000003070, 110321, 1220, 7637, 8160, '0', 0, 0, 0, -1, 0, 0, 1693.34, 5638.36, -57.8931, 4.30803, 60, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0); -- Na'zak the Fiend — Suramar

-- VERIFY после применения:
-- SELECT spell_id, ScriptName FROM spell_script_names WHERE spell_id IN (212836,212837,212867,212889);
-- Должно быть ровно 4 строки с указанными именами.
-- SELECT entry, ScriptName FROM creature_template WHERE entry IN (108829,107544,107338,107353,108678,106981,106982,106984);
-- Должно быть 8 строк с непустыми ScriptName.
-- SELECT guid,id,map,zoneId,areaId,position_x,position_y,position_z,orientation,spawntimesecs FROM creature
--   WHERE id IN (108829,107544,108678,106981,106982,106984,109943,110321);
-- Должно быть ровно 8 строк с координатами из WarAxe_Legion/DekkCore.
