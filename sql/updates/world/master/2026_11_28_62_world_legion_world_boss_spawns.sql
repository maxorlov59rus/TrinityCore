-- VERIFY: ID семи боссов и их ScriptName сверены с DekkCore и живой БД; координаты XY получены из Grail-NPCs/RareScanner и клиентского UiMapAssignment.csv (DB2 build 70961), для Хумонгриса подтверждены точной строкой creature.sql из DekkCore/vSLDB; area и Z проверены по клиентским .map билда 70961 (area 7883/8368/8147/8089/8553/8547).

-- Спавны мировых боссов Расколотых островов (map 1220).
-- Идемпотентно: сначала удаляем только наши entry, затем вставляем фиксированные GUID.
-- Пояснения к полям:
--   zoneId/areaId = 0 — принятый формат для спавнов map 1220 в живой БД;
--   spawnDifficulties = '0', phaseUseFlags/PhaseId/PhaseGroup = 0 — как у всех 867 существ map 1220;
--   modelid = 0 — использовать модель из creature_template;
--   orientation = 0 — для шести боссов достоверное значение не найдено; у Хумонгриса взято из точной строки DekkCore;
--   spawntimesecs = 300 — единственное подтверждённое значение из точной строки Humongris, применено ко всем семи;
--   position_z — вычислен из клиентских .map build 70961 (в строке DekkCore/vSLDB указано 44.3088 от старого билда карт).

DELETE FROM `creature` WHERE `id` IN (99929, 108879, 109331, 110378, 117239, 117303, 121124);

INSERT INTO `creature`
(`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(3530000000003055, 99929, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, 6601.46, 4217.80, 162.11, 0, 300, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0),  -- Flotsam — Бухта кораблекрушения (Highmountain)
(3530000000003056, 108879, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2435.59, 8254.55, 58.51, 2.99236, 300, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Humongris — Сумеречный риф (Val'sharah), XY и orientation из точной строки
(3530000000003057, 109331, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, -1909.65, 7307.25, 19.03, 0, 300, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Calamir — Остров Стражей (Azsuna)
(3530000000003058, 110378, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, 3554.81, 3587.10, 781.19, 0, 300, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Drugon the Frostblood — Утесы Слепящих Снегов (Highmountain)
(3530000000003059, 117239, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, -748.50, 2610.52, 108.83, 0, 300, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Brutallus — Последнее пристанище Ринна (Broken Shore)
(3530000000003060, 117303, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, -684.33, 2651.71, 98.14, 0, 300, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0), -- Malificus — Последнее пристанище Ринна (Broken Shore)
(3530000000003061, 121124, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, -1604.92, 2608.59, 34.01, 0, 300, 0, 0, NULL, 0, 0, 0, 0, 0, '', NULL, 0); -- Apocron — Берег Страданий (Broken Shore)
