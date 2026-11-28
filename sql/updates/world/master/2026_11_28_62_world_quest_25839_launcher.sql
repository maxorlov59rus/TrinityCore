-- VERIFY: квест 25839 «The Ultrasafe Personnel Launcher» — восстановление запуска с катапульты.
-- Источник: https://github.com/aquadeus/TrinityCore/tree/quest_25839, коммит 6add93bf04.
-- В живой БД NPC 41398 (Ultrasafe Personnel Launcher) и 41327 (Launch "Platform") есть,
-- но у 41398 нет флага spellclick и скрипта, а у 41327 висит spell 59099
-- (в клиентском SpellName.db2 — «Уничтожение платформы»), из-за чего квест не проходится.
-- Сверено с клиентом 12.1.5.70961: QuestV2.db2 ID 25839 существует; SpellName.db2 содержит
-- 50630 «Выставить всех пассажиров», 77424 «Подготовиться к запуску!»,
-- 77431 «Force Cast Deploy-a-tron», 96003 «Подготовка к запуску».
-- Константы кода проверены по репозиторию: UNIT_NPC_FLAG_SPELLCLICK = 0x01000000,
-- CONDITION_SOURCE_TYPE_SPELL_CLICK_EVENT = 18, CONDITION_QUESTTAKEN = 9.
-- Локализация не требуется: новые строки, BroadcastText и *_locale не добавляются.

-- Удаляем только свои строки, чтобы файл можно было применять повторно.
DELETE FROM `quest_details` WHERE `ID` = 25839;
INSERT INTO `quest_details`
  (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`, `VerifiedBuild`)
VALUES
  (25839, 1, 25, 5, 0, 0, 0, 0, 0, 70077);

DELETE FROM `conditions`
WHERE `SourceTypeOrReferenceId` = 18 AND `SourceGroup` = 41398 AND `SourceEntry` = 77424;
INSERT INTO `conditions`
  (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`,
   `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`,
   `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`)
VALUES
  (18, 41398, 77424, 0, 0, 9, 0, 25839, 0, 0, '', 0, 0, 0, '',
   'Клик по 41398 требует активный квест 25839');

DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` IN (41398, 41327);
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES
  (41398, 77424, 1, 0),
  (41327, 77424, 1, 0);

-- Скрипт лежит в Custom/DunMorogh/npc_ultrasafe_personnel_launcher.cpp.
UPDATE `creature_template` SET `npcflag` = 16777216, `ScriptName` = 'npc_ultrasafe_personnel_launcher' WHERE `entry` = 41398;

-- VERIFY после применения:
-- SELECT ID, Emote1, Emote2, Emote3, VerifiedBuild FROM quest_details WHERE ID = 25839;
-- SELECT SourceGroup, SourceEntry, ConditionTypeOrReference, ConditionValue1
--   FROM conditions WHERE SourceTypeOrReferenceId = 18 AND SourceGroup = 41398 AND SourceEntry = 77424;
-- SELECT npc_entry, spell_id, cast_flags, user_type
--   FROM npc_spellclick_spells WHERE npc_entry IN (41398, 41327);
-- SELECT entry, npcflag, ScriptName FROM creature_template WHERE entry = 41398;
-- Должно быть: 1 строка quest_details, 1 условие на квест 25839, 2 spellclick-строки с 77424,
-- NPC 41398 с npcflag=16777216 и ScriptName='npc_ultrasafe_personnel_launcher'.
