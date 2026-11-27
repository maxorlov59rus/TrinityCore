-- VERIFY: TDB 1210.26091 / world; живая БД уже содержит связку карты 632 (Forge of Souls), сложности 1 и сценария 566; боссы 36497/36502 входят в spawn_group 37/38 с привязкой к bossStateId 0/1, квест-награда 35436 присутствует в world.quest_template.

-- Привязка сценария 566 «Кузня Душ» к карте 632 и сложности 1 (пересоздаётся для идемпотентности порта)
DELETE FROM `scenarios` WHERE `map`=632 AND `difficulty`=1;
INSERT INTO `scenarios` (`map`, `difficulty`, `scenario_A`, `scenario_H`) VALUES
(632, 1, 566, 566);
