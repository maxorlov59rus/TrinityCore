-- VERIFY: DekkCore 43adcd995f / DekkCore_2023_01_06_03_world.sql; живая TDB 1210.26091: квесты 65101/65286/66513 и NPC 189569/189322/189324/189603 существуют, всех ссылок creature_queststarter/creature_questender для этих квестов нет. RU/EN-локализация уже есть в quest_template и quest_template_locale (ruRU, VB 69587), дубли не добавляются. GUID и спавны не переносятся.
DELETE FROM `creature_queststarter` WHERE (`id` = 189569 AND `quest` = 65101) OR (`id` = 189322 AND `quest` = 65286) OR (`id` = 189324 AND `quest` = 66513);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES
(189569, 65101),
(189322, 65286),
(189324, 66513);

DELETE FROM `creature_questender` WHERE (`id` = 189603 AND `quest` = 66513);
INSERT INTO `creature_questender` (`id`, `quest`) VALUES
(189603, 66513);
