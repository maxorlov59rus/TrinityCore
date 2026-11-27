-- VERIFY: TDB 1210.26091 / world; DekkCore Waycrest Manor boss_gorak_tul; живая БД подтвердила спавны 131864/133435 в map 1862, отсутствие статичного спавна 135552 и готовые broadcast_text 150395/150396/150400.
-- RU/EN-локализация реплик уже есть в hotfixes.broadcast_text и hotfixes.broadcast_text_locale (ruRU), дубли не добавляются.
UPDATE `creature_template` SET `ScriptName` = 'boss_gorak_tul' WHERE `entry` = 131864;
UPDATE `creature_template` SET `ScriptName` = 'npc_deathtouched_slaver' WHERE `entry` = 135552;

DELETE FROM `creature_text` WHERE `CreatureID` = 131864 AND `GroupID` IN (0, 1, 2);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundPlayType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(131864, 0, 0, 'Death consumes all!', 14, 0, 100, 0, 0, 0, 0, 150395, 0, 'Gorak Tul - Enter Combat'),
(131864, 1, 0, 'Rise!', 14, 0, 100, 0, 0, 0, 0, 150400, 0, 'Gorak Tul - Dread Essence'),
(131864, 2, 0, 'Death... cannot hold me...', 14, 0, 100, 0, 0, 0, 0, 150396, 0, 'Gorak Tul - Death');
