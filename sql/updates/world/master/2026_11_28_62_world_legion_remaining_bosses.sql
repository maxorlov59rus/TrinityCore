-- VERIFY: оставшиеся мировые боссы Legion из DekkCore/Legion/WorldBosses (dekk/main 3d052ac).
-- В этом файле три скрипта: boss_ana_mouz.cpp, boss_nazak_the_fiend.cpp, boss_withered_jim.cpp.
-- Остальные четыре (levantus, nithogg, sharthos, the_soultakers) адаптированы локально и вынесены
-- в 2026_11_28_62_world_legion_four_remaining_bosses.sql (биндинги и спавны).
-- ID спеллов и entry сверены с клиентом 12.1.5.70077 (SpellName.csv) и живой БД; конфликтующих привязок нет.
-- Локализация не требуется: новые BroadcastText, creature_text и *_locale не добавляются.
-- Спавн Withered J'im взят из точной строки creature.sql DekkCore (map 1220, zone 7334, area 8147,
-- x=-1769.23, y=6364.26, z=57.5588, orientation=6.22849, spawntimesecs=300).
-- Внимание: client .map build 70961 даёт для этой точки высоту 196.90 — вероятно, верх уступа;
-- поэтому сохранено значение из авторитетной строки БД, а не вычисленное с карты.
-- Спавны Ana-Mouz и Na'zak добавлены в 2026_11_28_62_world_legion_four_remaining_bosses.sql
-- из полной БД WarAxe_Legion 7.3.5 (координат нет ни в DekkCore, ни в TDB 7.3.5/1210).
-- No-op скрипт spell_foundational_collapse (219591) не привязывается: он только подавил бы
-- стандартное действие заклинания, не создав кристаллы. Античит-блок DamageTaken в Withered J'im
-- удалён как не соответствующий Blizzlike-поведению.

-- Удаляем только свои строки, чтобы файл можно было применять повторно.
DELETE FROM `spell_script_names` WHERE (`spell_id`, `ScriptName`) IN (
    (219045, 'spell_mothers_embrace'),
    (223614, 'spell_resonance')
);

INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
    (219045, 'spell_mothers_embrace'),
    (223614, 'spell_resonance');

-- Привязки боссов.
UPDATE `creature_template` SET `ScriptName` = 'boss_ana_muz'         WHERE `entry` = 109943;
UPDATE `creature_template` SET `ScriptName` = 'boss_nazak_the_fiend' WHERE `entry` = 110321;
UPDATE `creature_template` SET `ScriptName` = 'boss_withered_jim'    WHERE `entry` = 102075;

-- Спавн Withered J'im на map 1220; формат полей совпадает с остальными спавнами map 1220 в живой БД.
DELETE FROM `creature` WHERE `id` = 102075;

INSERT INTO `creature`
(`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(3530000000003062, 102075, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, -1769.23, 6364.26, 57.5588, 6.22849, 300, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0); -- Withered J'im — Остров Стражей (Azsuna)

-- VERIFY после применения:
-- SELECT spell_id, ScriptName FROM spell_script_names WHERE spell_id IN (219045,223614);
-- Должно быть ровно 2 строки с указанными именами.
-- SELECT entry, ScriptName FROM creature_template WHERE entry IN (102075,109943,110321);
-- Должно быть 3 строки с непустыми ScriptName.
-- SELECT guid, id, position_x, position_y, position_z FROM creature WHERE id = 102075;
-- Должна быть 1 строка с guid 3530000000003062 и координатами из исходной строки DekkCore.
