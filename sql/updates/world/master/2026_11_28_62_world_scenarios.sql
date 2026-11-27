-- VERIFY: живая БД TDB 1210.26091 / world; связки карты и сложности со сценариями взяты из существующих world.scenarios и пересоздаются для идемпотентности порта; несуществующие привязки не выдумываются.

-- Привязка перенесённых сценариев к картам и сложностям
DELETE FROM `scenarios` WHERE (`map`=658 AND `difficulty`=1) OR (`map`=658 AND `difficulty`=2) OR (`map`=940 AND `difficulty`=2);
INSERT INTO `scenarios` (`map`, `difficulty`, `scenario_A`, `scenario_H`) VALUES
(658, 1, 569, 569),
(658, 2, 571, 571),
(940, 2, 570, 570);
