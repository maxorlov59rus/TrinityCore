-- VERIFY: TDB 1210.26091 / world; DekkCore 43adcd995f; живая БД подтвердила спавн 122968 в map 1763, NPC 125828/125868 и broadcast_text 140480/140493 (VB 69497); 129412 в ритейле 12.1.5.70961 отсутствует.
-- EN-текст в creature_text служит fallback; RU/EN-локализация уже есть в hotfixes.broadcast_text_locale (ruRU) и базовом hotfixes.broadcast_text (enUS), дубли не добавляются.
UPDATE `creature_template` SET `ScriptName` = 'boss_ataldazar_yazma' WHERE `entry` = 122968;
UPDATE `creature_template` SET `ScriptName` = 'npc_ataldazar_soulspawn' WHERE `entry` = 125828;
UPDATE `creature_template` SET `ScriptName` = 'npc_ataldazar_echo_of_shadra' WHERE `entry` = 125868;

DELETE FROM `creature_text` WHERE `CreatureID` = 122968 AND `GroupID` IN (0, 6);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundPlayType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(122968, 0, 0, 'Dazar will awaken soon, but you will not live to see it!', 14, 0, 100, 0, 0, 0, 0, 140480, 0, 'Yazma - Enter Combat'),
(122968, 6, 0, 'Fools! Zul will rip... your spirits... apart...', 14, 0, 100, 0, 0, 0, 0, 140493, 0, 'Yazma - Death');
