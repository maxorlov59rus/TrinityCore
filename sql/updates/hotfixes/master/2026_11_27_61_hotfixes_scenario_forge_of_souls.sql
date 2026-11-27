-- VERIFY: клиент 12.1.5.70961, дампы wago.tools Scenario/ScenarioStep/CriteriaTree/Criteria/ModifierTree с привязкой к билду 70961; живая БД hotfixes: строк для сценария 566, шага 1046, деревьев 36523-36525, критериев 27935/27936 и модификатора 12710 нет; локализация ruRU для этих ID отсутствует, готовые строки не дублируются.

-- Сценарий 566 «Кузня Душ» (The Forge of Souls): тип 3, флаги 10 из ритейл-DB2
DELETE FROM `scenario` WHERE `ID`=566;
INSERT INTO `scenario` (`ID`, `Name`, `AreaTableID`, `Type`, `Flags`, `UiTextureKitID`, `UiScenarioDisplayInfoID`, `VerifiedBuild`) VALUES
(566, 'The Forge of Souls', 0, 3, 10, 0, 0, 70961);

-- Русское название сценария из клиентского DB2 (ruRU)
DELETE FROM `scenario_locale` WHERE `ID`=566;
INSERT INTO `scenario_locale` (`ID`, `locale`, `Name_lang`, `VerifiedBuild`) VALUES
(566, 'ruRU', 'Кузня Душ', 70961);

-- Единственный обязательный шаг сценария: победить боссов, награда — квест 35436 из world.quest_template
DELETE FROM `scenario_step` WHERE `ID`=1046;
INSERT INTO `scenario_step` (`Description`, `Title`, `ID`, `ScenarioID`, `Criteriatreeid`, `RewardQuestID`, `RelatedStep`, `Supersedes`, `OrderIndex`, `Flags`, `VisibilityPlayerConditionID`, `WidgetSetID`, `VerifiedBuild`) VALUES
('Defeat the bosses within The Forge of Souls', 'The Forge of Souls', 1046, 566, 36523, 35436, 0, 0, 0, 0, 0, 0, 70961);

-- Русские заголовок и описание шага из клиентского DB2 (ruRU)
DELETE FROM `scenario_step_locale` WHERE `ID`=1046;
INSERT INTO `scenario_step_locale` (`ID`, `locale`, `Description_lang`, `Title_lang`, `VerifiedBuild`) VALUES
(1046, 'ruRU', 'Победите боссов в Кузне Душ', 'Кузня Душ', 70961);

-- Дерево критериев шага: контейнер и две цели на убийство боссов
DELETE FROM `criteria_tree` WHERE `ID` IN (36523, 36524, 36525);
INSERT INTO `criteria_tree` (`ID`, `Description`, `Parent`, `Amount`, `Operator`, `CriteriaID`, `OrderIndex`, `Flags`, `VerifiedBuild`) VALUES
(36523, 'The Forge of Souls Bosses', 0, 0, 4, 0, 0, 0, 70961),
(36524, 'Bronjahm defeated', 36523, 1, 0, 27935, 0, 0, 70961),
(36525, 'Devourer of Souls defeated', 36523, 1, 0, 27936, 1, 0, 70961);

-- Русские описания критериев из клиентского DB2 (ruRU)
DELETE FROM `criteria_tree_locale` WHERE `ID` IN (36523, 36524, 36525);
INSERT INTO `criteria_tree_locale` (`ID`, `locale`, `Description_lang`, `VerifiedBuild`) VALUES
(36523, 'ruRU', 'Боссы Кузни Душ', 70961),
(36524, 'ruRU', 'Броньям побежден', 70961),
(36525, 'ruRU', 'Пожиратель Душ побежден', 70961);

-- Критерии типа 0 (KillCreature): Броньям 36497 и Пожиратель душ 36502
DELETE FROM `criteria` WHERE `ID` IN (27935, 27936);
INSERT INTO `criteria` (`ID`, `Type`, `Asset`, `ModifierTreeId`, `StartEvent`, `StartAsset`, `StartTimer`, `FailEvent`, `FailAsset`, `Flags`, `EligibilityWorldStateID`, `EligibilityWorldStateValue`, `VerifiedBuild`) VALUES
(27935, 0, 36497, 12710, 0, 0, 0, 0, 0, 0, 0, 0, 70961),
(27936, 0, 36502, 12710, 0, 0, 0, 0, 0, 0, 0, 0, 70961);

-- Модификатор 12710: пустой контейнер с оператором All, не ограничивает выполнение критериев
DELETE FROM `modifier_tree` WHERE `ID`=12710;
INSERT INTO `modifier_tree` (`ID`, `Parent`, `Operator`, `Amount`, `Type`, `Asset`, `SecondaryAsset`, `TertiaryAsset`, `VerifiedBuild`) VALUES
(12710, 0, 4, 1, 0, 0, 0, 0, 70961);
