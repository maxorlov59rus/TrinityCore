-- VERIFY: клиент 12.1.5.70961 и дампы wago.tools DB2 Scenario/ScenarioStep/CriteriaTree/Criteria/ModifierTree/WorldStateExpression с привязкой к билду 70961; имена дополнительно сверены с доступным wowdb/static.wowdb.com, сюжетные цепочки — с wowhead.com/storylines; живая БД hotfixes/world проверена на отсутствие/совпадение строк; готовые enUS/ruRU-локализации не дублируются.

-- Сценарии, шаги и CriteriaTree переносятся из retail DB2 без кастомных CriteriaType; все INSERT идемпотентны.

DELETE FROM `scenario` WHERE `ID` IN (569,570,571);
INSERT INTO `scenario` (`ID`, `Name`, `AreaTableID`, `Type`, `Flags`, `UiTextureKitID`, `UiScenarioDisplayInfoID`, `VerifiedBuild`) VALUES
(569, 'Pit of Saron', 0, 3, 10, 0, 0, 70961),
(570, 'Hour of Twilight', 0, 3, 10, 0, 0, 70961),
(571, 'Pit of Saron', 0, 3, 18, 0, 0, 70961);

-- Русские названия сценариев из клиентского DB2 (ruRU)
DELETE FROM `scenario_locale` WHERE `ID` IN (569,570,571) AND `locale`='ruRU';
INSERT INTO `scenario_locale` (`ID`, `locale`, `Name_lang`, `VerifiedBuild`) VALUES
(569, 'ruRU', 'Яма Сарона', 70961),
(570, 'ruRU', 'Время Сумерек', 70961),
(571, 'ruRU', 'Яма Сарона', 70961);

-- Шаги сценариев: описание, заголовок, дерево критериев, награда-квест и порядок
DELETE FROM `scenario_step` WHERE `ID` IN (1053,1054,1055);
INSERT INTO `scenario_step` (`Description`, `Title`, `ID`, `ScenarioID`, `Criteriatreeid`, `RewardQuestID`, `RelatedStep`, `Supersedes`, `OrderIndex`, `Flags`, `VisibilityPlayerConditionID`, `WidgetSetID`, `VerifiedBuild`) VALUES
('Defeat the quarry''s forces and free captives.', 'Pit of Saron', 1053, 569, 217006, 35438, 0, 0, 0, 0, 0, 0, 70961),
('Assist Thrall in defeating the Twilight Hammer.', 'The Hour of Twilight', 1054, 570, 36530, 35439, 0, 0, 0, 0, 0, 0, 70961),
('Defeat the quarry''s forces and free captives.', 'Pit of Saron', 1055, 571, 217011, 35440, 0, 0, 0, 0, 0, 0, 70961);

-- Русские заголовки и описания шагов из клиентского DB2 (ruRU)
DELETE FROM `scenario_step_locale` WHERE `ID` IN (1053,1054,1055) AND `locale`='ruRU';
INSERT INTO `scenario_step_locale` (`ID`, `locale`, `Description_lang`, `Title_lang`, `VerifiedBuild`) VALUES
(1053, 'ruRU', 'Победите солдат на каменоломне и освободите пленников.', 'Яма Сарона', 70961),
(1054, 'ruRU', 'Помогите Траллу победить Сумеречный Молот.', 'Время Сумерек', 70961),
(1055, 'ruRU', 'Победите солдат на каменоломне и освободите пленников.', 'Яма Сарона', 70961);

-- Деревья критериев: контейнеры и листовые цели
DELETE FROM `criteria_tree` WHERE `ID` IN (36530,36531,36532,36533,217006,217007,217008,217009,217010,217011,217012,217013,217014,217015);
INSERT INTO `criteria_tree` (`ID`, `Description`, `Parent`, `Amount`, `Operator`, `CriteriaID`, `OrderIndex`, `Flags`, `VerifiedBuild`) VALUES
(36530, 'The Hour of Twilight - Hour of Twilight', 0, 0, 4, 0, 0, 0, 70961),
(36531, 'Arcurion defeated', 36530, 1, 0, 24841, 0, 0, 70961),
(36532, 'Asira Dawnslayer defeated', 36530, 1, 0, 24842, 1, 0, 70961),
(36533, 'Archbishop Benedictus defeated', 36530, 1, 0, 18544, 2, 0, 70961),
(217006, '3.0 Dungeon - Pit of Saron (Normal)', 0, 0, 4, 0, 0, 0, 70961),
(217007, 'Forgemaster Garfrost defeated', 217006, 1, 0, 109138, 0, 0, 70961),
(217008, 'Ick and Krick defeated', 217006, 1, 0, 109137, 1, 0, 70961),
(217009, 'Scourgelord Tyrannus defeated', 217006, 1, 0, 109136, 3, 0, 70961),
(217010, 'Quarry camps liberated', 217006, 6, 0, 109242, 2, 0, 70961),
(217011, '3.0 Dungeon - Pit of Saron (Heroic)', 0, 0, 4, 0, 0, 0, 70961),
(217012, 'Forgemaster Garfrost defeated', 217011, 1, 0, 109138, 0, 0, 70961),
(217013, 'Ick and Krick defeated', 217011, 1, 0, 109137, 1, 0, 70961),
(217014, 'Scourgelord Tyrannus defeated', 217011, 1, 0, 109136, 3, 0, 70961),
(217015, 'Quarry camps liberated', 217011, 6, 0, 109242, 2, 0, 70961);

-- Русские описания критериев из клиентского DB2 (ruRU)
DELETE FROM `criteria_tree_locale` WHERE `ID` IN (36530,36531,36532,36533,217006,217007,217008,217009,217010,217011,217012,217013,217014,217015) AND `locale`='ruRU';
INSERT INTO `criteria_tree_locale` (`ID`, `locale`, `Description_lang`, `VerifiedBuild`) VALUES
(36530, 'ruRU', 'Время Сумерек – Время Сумерек', 70961),
(36531, 'ruRU', 'Аркурион побежден', 70961),
(36532, 'ruRU', 'Азира Убийца Зари побеждена', 70961),
(36533, 'ruRU', 'Архиепископ Бенедикт побежден', 70961),
(217006, 'ruRU', '3.0 Dungeon - Pit of Saron (Normal)', 70961),
(217007, 'ruRU', 'Победите начальника кузни Гархлада', 70961),
(217008, 'ruRU', 'Победите Ика и Крика', 70961),
(217009, 'ruRU', 'Победите повелителя Плети Тирания', 70961),
(217010, 'ruRU', 'Освободите лагеря у каменоломни', 70961),
(217011, 'ruRU', '3.0 Dungeon - Pit of Saron (Heroic)', 70961),
(217012, 'ruRU', 'Победите начальника кузни Гархлада', 70961),
(217013, 'ruRU', 'Победите Ика и Крика', 70961),
(217014, 'ruRU', 'Победите повелителя Плети Тирания', 70961),
(217015, 'ruRU', 'Освободите лагеря у каменоломни', 70961);

-- Критерии: только типы, поддерживаемые ядром TrinityCore без кастомных хуков
DELETE FROM `criteria` WHERE `ID` IN (18544,24841,24842,109136,109137,109138,109242);
INSERT INTO `criteria` (`ID`, `Type`, `Asset`, `ModifierTreeId`, `StartEvent`, `StartAsset`, `StartTimer`, `FailEvent`, `FailAsset`, `Flags`, `EligibilityWorldStateID`, `EligibilityWorldStateValue`, `VerifiedBuild`) VALUES
(18544, 0, 54938, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70961),
(24841, 0, 54590, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70961),
(24842, 0, 54968, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70961),
(109136, 165, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70961),
(109137, 165, 2001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70961),
(109138, 165, 1999, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70961),
(109242, 0, 252760, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70961);

-- Упущение в уже портированном сценарии 566: у modifier_tree 12710 отсутствует дочерний узел 12711
-- (тип 67 = WorldStateExpression, Asset 5497), из-за чего CriteriaTree 36523 не проверяет состояние мира.
DELETE FROM `modifier_tree` WHERE `ID`=12711 AND `VerifiedBuild`=70961;
INSERT INTO `modifier_tree` (`ID`, `Parent`, `Operator`, `Amount`, `Type`, `Asset`, `SecondaryAsset`, `TertiaryAsset`, `VerifiedBuild`) VALUES
(12711, 12710, 2, 1, 67, 5497, 0, 0, 70961);

-- Выражение состояния мира 5497 из клиентского DB2 (build 70961)
DELETE FROM `world_state_expression` WHERE `ID`=5497 AND `VerifiedBuild`=70961;
INSERT INTO `world_state_expression` (`ID`, `Expression`, `VerifiedBuild`) VALUES
(5497, '010101000000000101010000000000', 70961);

