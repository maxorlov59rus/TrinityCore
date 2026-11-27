-- VERIFY: последний непортированный фикс Гилнеаса, глава 1 (TC issue #32109, открыт на 28.11.2026).
-- Источник: https://github.com/TrinityCore/TrinityCore/issues/32109 (SQL от Tannanag, финальная версия от 21.11.2026,
-- одобренная мейнтейнером Naddley). #32110/#32111/#32112/#32114 уже присутствуют в HEAD, этот файл их не трогает.
-- Сверено с живой БД TDB 1210.26091: гиды 376247..376355, 376285, 376310 существуют с id 34851/44086/34864;
-- current SmartAI 34850 имеет тайминги 62000 мс (фикс меняет их на 61800 мс); BroadcastText 36124/36125/36126,
-- 39313, 44373..44379 и их ruRU-строки присутствуют в hotfixes.broadcast_text / broadcast_text_locale,
-- поэтому отдельные *_locale INSERT не нужны. StaticFlags1 0x30000100 -> 0x10000100 снимает только
-- CREATURE_STATIC_FLAG_FLOATING (0x20000000), оставляя CAN_SWIM + SESSILE (подтверждено CreatureData.h).
-- Отдельные строки creature_text_locale для этих NPC отсутствуют, текст задаётся через BroadcastTextId.

-- Принц Лиам Греймайн: три реплики по кругу 61.8 с (20.6 с между репликами)
DELETE FROM `smart_scripts` WHERE `entryorguid`=34850 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34850,0,0,0,60,0,100,0,5000,5000,61800,61800,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Prince Liam Greymane - On Update - Say Line 0'),
(34850,0,1,0,60,0,100,0,25600,25600,61800,61800,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Prince Liam Greymane - On Update - Say Line 1'),
(34850,0,2,0,60,0,100,0,46200,46200,61800,61800,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Prince Liam Greymane - On Update - Say Line 2');

-- Паникующие горожане: восемь сидящих на корточках теперь периодически спрашивают о крышах.
-- Одна строка на entry 34851 + условие на StringId (как рекомендовано мейнтейнером), вместо восьми копий на гиды.
-- Дополнительно удаляются старые копии на гиды, если ранее применялась промежуточная версия патча.
UPDATE `creature` SET `StringId`='PanickedCitizenRooftops' WHERE `guid` IN (376247,376249,376252,376313,376333,376341,376354,376355);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-376247,-376249,-376252,-376313,-376333,-376341,-376354,-376355) AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=34851 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34851,0,0,0,1,0,10,0,10000,60000,60000,60000,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Panicked Citizen - Out of Combat - Say Line 0');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=34851 AND `SourceId`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ConditionStringValue1`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,1,34851,0,0,58,1,0,0,0,'PanickedCitizenRooftops',0,0,0,'','Trigger smart event if object has StringId ''PanickedCitizenRooftops''');

-- Горожанин у ворот: фиксированный диалог со стражем с интервалом 161 с вместо случайных реплик
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-376285,-376310) AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=4408600 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-376285,0,0,0,1,0,100,0,1000,6000,6000,9000,0,10,1,5,18,20,430,0,1,0,0,0,0,0,0,0,0,'Panicked Citizen - Out of Combat - Play Random Emote (1, 5, 18, 20, 430)'),
(-376285,0,1,0,1,0,100,0,0,0,161000,161000,0,80,4408600,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Panicked Citizen - Out of Combat - Run Script'),
(4408600,9,0,0,0,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Panicked Citizen - Actionlist - Say Line 0'),
(4408600,9,1,0,0,0,100,0,40000,40000,0,0,0,1,1,0,0,0,0,0,10,376310,34864,0,0,0,0,0,0,'Panicked Citizen - Actionlist - Say Line 1 (Gilneas City Guard)'),
(4408600,9,2,0,0,0,100,0,16000,16000,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Panicked Citizen - Actionlist - Say Line 1'),
(4408600,9,3,0,0,0,100,0,33000,33000,0,0,0,1,2,0,0,0,0,0,10,376310,34864,0,0,0,0,0,0,'Panicked Citizen - Actionlist - Say Line 2 (Gilneas City Guard)'),
(4408600,9,4,0,0,0,100,0,25000,25000,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Panicked Citizen - Actionlist - Say Line 2'),
(4408600,9,5,0,0,0,100,0,28000,28000,0,0,0,1,1,0,0,0,0,0,10,376310,34864,0,0,0,0,0,0,'Panicked Citizen - Actionlist - Say Line 1 (Gilneas City Guard)');

-- Тексты NPC: привязка к уже существующим BroadcastText (enUS - базовая строка, ruRU - в hotfixes)
DELETE FROM `creature_text` WHERE `CreatureID` IN (34850,34851,34864,44086);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(34850,0,0,'Stand ready, guards!  We don''t know how many intruders we''re dealing with, but the Headlands are overrun and we''re cut off from the harbor towns.  Expect to be outnumbered.',12,0,100,1,0,19614,36124,0,'Prince Liam Greymane'),
(34850,1,0,'I want the perimeter secured and the gates manned by two guards at all times.  No one gets in, no one gets out.',12,0,100,1,0,19615,36125,0,'Prince Liam Greymane'),
(34850,2,0,'We protected Gilneas from the Scourge.  We protected Gilneas during the Northgate rebellion.  We will protect Gilneas from whatever this new threat may be.',12,0,100,25,0,19616,36126,0,'Prince Liam Greymane'),
(34851,0,0,'What... what are those things on the rooftops?',12,0,100,0,0,0,39313,0,'Panicked Citizen'),
(34864,0,0,'No one''s allowed to leave. Prince Liam''s orders.',12,0,100,1,0,0,44373,0,'Gilneas City Guard'),
(34864,1,0,'It isn''t safe to leave, there''s something lurking out there in the woods.',12,0,100,1,0,0,44374,0,'Gilneas City Guard to Panicked Citizen'),
(34864,2,0,'Stay calm. We have everything under control.',12,0,100,1,0,0,44375,0,'Gilneas City Guard to Panicked Citizen'),
(44086,0,0,'What''s going on? I thought I saw something on the rooftops.',12,0,100,0,0,0,44379,0,'Panicked Citizen to Gilneas City Guard'),
(44086,1,0,'You can''t do this to us!',12,0,100,0,0,0,44377,0,'Panicked Citizen to Gilneas City Guard'),
(44086,2,0,'My children are in Stormglen alone! I have to get to them!',12,0,100,0,0,0,44378,0,'Panicked Citizen to Gilneas City Guard');

-- Страж города и павший страж: убрать зависание в воздухе, оставить root + плавание
UPDATE `creature_template_difficulty` SET `StaticFlags1`=0x10000100 WHERE `Entry` IN (34864,39095) AND `DifficultyID`=0;
