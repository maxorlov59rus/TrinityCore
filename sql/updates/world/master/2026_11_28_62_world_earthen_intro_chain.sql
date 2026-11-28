-- VERIFY: фикс цепочки вступления Эартенов из community-fix пакета RomanKern89/wow-midnight-server
-- (sql/01_quest_earthen_intro_fix.sql). В живой TDB квесты 79200 (Who am I?), 79201 и 83328
-- (оба "The Analysis Interface") существуют, но строк quest_template_addon для них нет;
-- objective-ы 79201 и 83328 побайтово совпадают (222568/222569/222570), а стартер/ендер есть
-- только у 79200. Поэтому 79201 — фантомный дубль, разрывающий цепочку 79200 -> 83328.
-- Источник: https://github.com/RomanKern89/wow-midnight-server/blob/main/sql/01_quest_earthen_intro_fix.sql
-- Локализация не требуется: новые строки и BroadcastText не добавляются.

-- Удаляем только две наши строки, чтобы повторное применение было идемпотентным.
DELETE FROM `quest_template_addon` WHERE `ID` IN (79200, 83328);
INSERT INTO `quest_template_addon` (`ID`, `PrevQuestID`, `NextQuestID`) VALUES
(79200, 0, 83328),
(83328, 79200, 0);

-- VERIFY после применения:
-- SELECT ID, PrevQuestID, NextQuestID FROM quest_template_addon WHERE ID IN (79200, 83328);
-- Должно быть 2 строки: 79200 -> 83328 и 83328 <- 79200.
