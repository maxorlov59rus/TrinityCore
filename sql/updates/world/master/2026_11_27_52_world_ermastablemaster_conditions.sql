-- VERIFY: issue #30137 и комментарий Shauren; живая TDB 1210.26091: меню 9821 options 2/3 существуют, условий SourceType 15 нет; serverside_spell_effect 132334 effect 0 = SPELL_EFFECT_APPLY_AURA; broadcast_text 64115 имеет enUS и ruRU.
-- Локализация пунктов меню уже есть в hotfixes.broadcast_text / broadcast_text_locale, новые locale-строки не добавляются.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 9821 AND `SourceEntry` IN (2, 3) AND `SourceId` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 9821, 2, 0, 0, 1, 0, 132334, 0, 0, '', 1, 0, 0, '', 'Показывать пункт меню, если у игрока нет ауры 132334, эффект 0'),
(15, 9821, 3, 0, 0, 1, 0, 132334, 0, 0, '', 0, 0, 0, '', 'Показывать пункт меню, если у игрока есть аура 132334, эффект 0');
