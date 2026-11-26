SET @CGUID := 11000391;
SET @PATH := 100000000;

DELETE FROM `creature` WHERE `guid` BETWEEN @CGUID+0 AND @CGUID+2;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `PhaseId`, `PhaseGroup`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `VerifiedBuild`) VALUES
(@CGUID+0, 245248, 2369, 10424, 13377, '0', 0, 0, 0, 1, -3.81319260597229003, 2.652411937713623046, 9.070906639099121093, 2.632274627685546875, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 66562), -- Breka Grimaxe (Area: Северное море - Difficulty: 0) CreateObject1
(@CGUID+1, 248563, 2369, 10424, 13377, '0', 15286, 0, 0, 0, -16.2924175262451171, -36.7197608947753906, 8.992197036743164062, 3.240731477737426757, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 66562), -- Гневион (Area: Северное море - Difficulty: 0) CreateObject1
(@CGUID+2, 248565, 2369, 10424, 13377, '0', 15286, 0, 0, 0, -10.0732851028442382, 78.40439605712890625, 15.1006622314453125, 3.030475854873657226, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 66562); -- Калесгос (Area: Северное море - Difficulty: 0) CreateObject1

UPDATE `creature` SET `PhaseId`=15286 WHERE `guid`=1050189; -- Trall

DELETE FROM `creature_addon` WHERE `guid` BETWEEN @CGUID+1 AND @CGUID+2;
INSERT INTO `creature_addon` (`guid`, `PathId`, `mount`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`, `PvpFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(@CGUID+1, 0, 0, 0, 3, 0, 1, 0, 0, 18508, 0, 0, 0, ''), -- Гневион
(@CGUID+2, 0, 0, 0, 3, 0, 1, 0, 0, 18518, 0, 0, 0, ''); -- Калесгос

DELETE FROM `creature_equip_template` WHERE (`ID`=1 AND `CreatureID` IN (166827,166814,166824,166573,245248));
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(166827, 1, 204482, 0, 0, 0, 0, 0, 0, 0, 0, 66562), -- 166827
(166814, 1, 175161, 0, 0, 0, 0, 0, 0, 0, 0, 66562), -- 166814
(166824, 1, 204482, 0, 0, 0, 0, 0, 0, 0, 0, 66562), -- 166824
(166573, 1, 204482, 0, 0, 0, 0, 0, 0, 0, 0, 66562), -- 166573
(245248, 1, 165616, 0, 0, 0, 0, 0, 0, 0, 0, 66562); -- 245248

UPDATE `creature_template_difficulty` SET `ContentTuningID`=1421, `StaticFlags1`=0x10000000, `VerifiedBuild`=66562 WHERE (`Entry`=245248 AND `DifficultyID`=0); -- 245248 (Breka Grimaxe) - CanSwim
UPDATE `creature_template` SET `faction`=2361, `npcflag`=2, `BaseAttackTime`=2000, `unit_flags2`=0x800 WHERE `entry`=245248; -- Breka Grimaxe

DELETE FROM `gameobject_template_locale` WHERE (`entry` IN (349879, 400622, 333479) AND `locale`='ruRU');
INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `unk1`, `VerifiedBuild`) VALUES
(349879, 'ruRU', 'Транспорт Орды', '', '', 66562),
(400622, 'ruRU', 'Штабель бочек', '', '', 66562),
(333479, 'ruRU', 'Корабль Альянса', '', '', 66562);

DELETE FROM `quest_offer_reward_locale` WHERE (`locale`='ruRU' AND `ID` IN (59928,59927,59926,56775));
INSERT INTO `quest_offer_reward_locale` (`ID`, `locale`, `RewardText`, `VerifiedBuild`) VALUES
(59928, 'ruRU', 'Этим штормом управляет какая-то неведомая сила!\n\nДержись меня в момент крушения. Я буду оберегать тебя.', 66562),
(59927, 'ruRU', 'У тебя большой потенциал, |3-6($c). Ты тоже можешь найти славу на этом острове!', 66562),
(59926, 'ruRU', 'Хорошо. Ты тренируешься с тех пор, как мы отчалили.\n\nМне нужно исследовать этот шторм. За ним стоит какая-то противоестественная сила.\n\nСразись с Трогом. Он оценит твои навыки и решит, чем ты будешь заниматься, когда мы окажемся на суше.', 66562),
(56775, 'ruRU', 'Отлично, |3-6($c). Вижу, ты в пути времени зря не $gтерял:теряла;.\n\nЧто-то погода внезапно поменялась, не нравится мне это. Попроси рядового Коула с тобой потренироваться, пока я поразмыслю над текущей ситуацией.', 66562);

DELETE FROM `conversation_actors` WHERE (`ConversationId` IN (30361, 30343) AND `Idx` IN (1,0));
INSERT INTO `conversation_actors` (`ConversationId`, `ConversationActorId`, `Idx`, `CreatureId`, `CreatureDisplayInfoId`, `NoActorObject`, `ActivePlayerObject`, `VerifiedBuild`) VALUES
(30361, 64220, 1, 248565, 105921, 0, 0, 66562),
(30361, 109403, 0, 166824, 115495, 0, 0, 66562), -- Full: 0x203AE50FE0A2EA000117FF000044EB9B Creature/0 R3769/S71679 Map: 2175 (9.0 NPE (New Player Experience) - Exile's Reach) Entry: 166824 (Thrall) Low: 4516763
(30343, 64220, 1, 248565, 105921, 0, 0, 66562),
(30343, 109370, 0, 156280, 88316, 0, 0, 66562); -- Full: 0x2042490FE0989E0001580A0000455ABF Creature/0 R4242/S88074 Map: 2175 (9.0 NPE (New Player Experience) - Exile's Reach) Entry: 156280 (Леди Джайна Праудмур) Low: 4545215

DELETE FROM `conversation_line_template` WHERE `Id` IN (83722, 83721, 83684, 83683);
INSERT INTO `conversation_line_template` (`Id`, `UiCameraID`, `ActorIdx`, `Flags`, `ChatType`, `VerifiedBuild`) VALUES
(83722, 150, 1, 0, 0, 66562),
(83721, 0, 0, 0, 0, 66562),
(83684, 150, 1, 0, 0, 66562),
(83683, 0, 0, 0, 0, 66562);

DELETE FROM `conversation_template` WHERE `Id` IN (30361, 30343);
INSERT INTO `conversation_template` (`Id`, `FirstLineID`, `TextureKitId`, `ScriptName`, `VerifiedBuild`) VALUES
(30361, 83721, 0, 'conversation_spar_ship', 66562),
(30343, 83683, 0, 'conversation_spar_ship', 66562);

DELETE FROM `phase_name` WHERE `ID`=15286;
INSERT INTO `phase_name` (`ID`, `Name`) VALUES (15286, 'Cosmetic - See Trall - Wrathion and Kalecgos on lower deck');

DELETE FROM `phase_area` WHERE `AreaId`=13377 AND `PhaseId`=15286;
INSERT INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES (13377, 15286, 'Cosmetic - See Trall - Wrathion and Kalecgos on lower deck');

-- GUID: Full: 0x203AE50FE0F2BD400117FF000044EB9B Creature/0 R3769/S71679 Map: 2175 (9.0 NPE (New Player Experience) - Exile's Reach) Entry: 248565 (Калесгос) Low: 4516763
DELETE FROM `waypoint_path` WHERE `PathId`=@PATH+0;
INSERT INTO `waypoint_path` (`PathId`, `MoveType`, `Flags`, `Velocity`, `Comment`) VALUES
(@PATH+0, 1, 0, NULL, '248565 (Kalecgos fly forward - Horde)');
DELETE FROM `waypoint_path_node` WHERE `PathId`=@PATH+0;
INSERT INTO `waypoint_path_node` (`PathId`, `NodeId`, `PositionX`, `PositionY`, `PositionZ`, `Orientation`) VALUES
(@PATH+0, 1, -410.0703, 78.40503, 15.183995, NULL); -- PathType: ExactPathFlying

-- GUID: Full: 0x203AE50FE0F2BCC00117FF000044EB9B Creature/0 R3769/S71679 Map: 2175 (9.0 NPE (New Player Experience) - Exile's Reach) Entry: 248563 (Гневион) Low: 4516763
DELETE FROM `waypoint_path` WHERE `PathId`=@PATH+1;
INSERT INTO `waypoint_path` (`PathId`, `MoveType`, `Flags`, `Velocity`, `Comment`) VALUES
(@PATH+1, 1, 0, NULL, '248563 (Wrathion fly forward - Horde)');
DELETE FROM `waypoint_path_node` WHERE `PathId`=@PATH+1;
INSERT INTO `waypoint_path_node` (`PathId`, `NodeId`, `PositionX`, `PositionY`, `PositionZ`, `Orientation`) VALUES
(@PATH+1, 1, -416.29395, -36.71997, 9.07553, NULL); -- PathType: ExactPathFlying

-- GUID: Full: 0x2042490FE0F2BD4001580A0000455ABF Creature/0 R4242/S88074 Map: 2175 (9.0 NPE (New Player Experience) - Exile's Reach) Entry: 248565 (Калесгос) Low: 4545215
DELETE FROM `waypoint_path` WHERE `PathId`=@PATH+2;
INSERT INTO `waypoint_path` (`PathId`, `MoveType`, `Flags`, `Velocity`, `Comment`) VALUES
(@PATH+2, 1, 0, NULL, '248565 (Kalecgos fly forward - Alliance)');
DELETE FROM `waypoint_path_node` WHERE `PathId`=@PATH+2;
INSERT INTO `waypoint_path_node` (`PathId`, `NodeId`, `PositionX`, `PositionY`, `PositionZ`, `Orientation`) VALUES
(@PATH+2, 1, -487.6328, 50.77539, 28.236526, NULL); -- PathType: ExactPathFlying

-- GUID: Full: 0x2042490FE0F2BCC001580A0000455ABF Creature/0 R4242/S88074 Map: 2175 (9.0 NPE (New Player Experience) - Exile's Reach) Entry: 248563 (Гневион) Low: 4545215
DELETE FROM `waypoint_path` WHERE `PathId`=@PATH+3;
INSERT INTO `waypoint_path` (`PathId`, `MoveType`, `Flags`, `Velocity`, `Comment`) VALUES
(@PATH+3, 1, 0, NULL, '248563 (Wrathion fly forward - Alliance)');
DELETE FROM `waypoint_path_node` WHERE `PathId`=@PATH+3;
INSERT INTO `waypoint_path_node` (`PathId`, `NodeId`, `PositionX`, `PositionY`, `PositionZ`, `Orientation`) VALUES
(@PATH+3, 1, -446.479, -32.87451, 6.100418, NULL); -- PathType: ExactPathFlying

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=15286 AND `SourceEntry`=13377;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(26, 15286, 13377, 0, 0, 47, 0, 59926, 64, 0, '', 1, 0, 0, '', 'Apply Phase 15286 if Quest 59926 is not rewarded');
DELETE FROM `creature_text` WHERE `CreatureID`=166782 AND `GroupID`=0 AND `ID`=0;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(166782, 0, 0, 'Thank the elements you survived.', 12, 0, 100, 3, 0, 297937, 0, 0, 'Trall to Player');

DELETE FROM `creature_text_locale` WHERE `CreatureID`=166782 AND `GroupID`=0 AND `ID`=0 AND `Locale`='ruRU';
INSERT INTO `creature_text_locale` (`CreatureID`, `GroupID`, `ID`, `Locale`, `Text`) VALUES
(166782, 0, 0, 'ruRU', 'Хвала стихиям, ты в порядке!');

DELETE FROM `creature_text` WHERE `CreatureID`=156626 AND `GroupID`=0 AND `ID`=0;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(156626, 0, 0, '$n! The sea was kind to you today.', 12, 0, 100, 3, 0, 297962, 0, 0, 'Леди Джайна Праудмур to Player');

DELETE FROM `creature_text_locale` WHERE `CreatureID`=156626 AND `GroupID`=0 AND `ID`=0 AND `Locale`='ruRU';
INSERT INTO `creature_text_locale` (`CreatureID`, `GroupID`, `ID`, `Locale`, `Text`) VALUES
(156626, 0, 0, 'ruRU', 'Тебе повезло! Море тебя пощадило.');
UPDATE `creature_template_difficulty` SET `StaticFlags1`=0x10000000, `VerifiedBuild`=64978 WHERE (`Entry`=54131 AND `DifficultyID`=0); -- 54131 (Fe-Feng Hozen) - CanSwim
UPDATE `creature_template_difficulty` SET `StaticFlags1`=0x10000000, `VerifiedBuild`=64978 WHERE (`Entry`=54131 AND `DifficultyID`=1); -- 54131 (Fe-Feng Hozen) - CanSwim

DELETE FROM `smart_scripts` WHERE `entryorguid`= 54131;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(54131, 0, 0, 0, '', 0, 0, 100, 0, 0, 1, 1, 60000, 60000, '', 157, 0, 0, 0, 0, 0, 0, 0, NULL, 1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'On Update IC - Self: Exit Vehicle on Self');

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 54131;

DELETE FROM `quest_offer_reward_locale` WHERE (`locale`='ruRU' AND `ID` IN (30027,29406,29424,29419,29410,29409,29408,29524, 29522, 29414,29421,29420,29523,29418,29417,29664,29422,29423,29521));
INSERT INTO `quest_offer_reward_locale` (`ID`, `locale`, `RewardText`, `VerifiedBuild`) VALUES
(30027, 'ruRU', 'Это прекрасное оружие. Оно как раз тебе подойдет.$B$BА теперь давай опробуем его в действии.', 64978),
(29406, 'ruRU', 'Неплохо, совсем неплохо, $n! Возможно, ты правильно $gвыбрал:выбрала; свой путь.$B$BХорошо. Продолжим.', 64978),
(29424, 'ruRU', 'Спасибо! Ты $gдостойный:достойная:c; |3-6($c). Твои учителя могут гордиться тобой.', 64978),
(29419, 'ruRU', 'Ты слишком $gдобр:добра; ко мне, |3-6($c).', 64978),
(29410, 'ruRU', 'Ты $gпришел:пришла; к Аисе? Знаешь... не стоит отвлекать ее, пока она не закончит свои упражнения. Она не станет с тобой разговаривать.$B$BВозможно, пока она тренируется, ты $gмог:могла; бы помочь мне? У меня возникли небольшие проблемы с лесными духами.', 64978),
(29409, 'ruRU', 'Превосходно, $n. Не осталось никаких сомнений, что ты $gпоступил:поступила; правильно, избрав путь |3-1($c).', 64978),
(29408, 'ruRU', 'Тебе так легко удалось выхватить пламя из моей лапы... это говорит о многом.$b$b\"Предписание умеренности\" – древний свиток мудрости, который достался нам от старейшин моих старейшин. Эта мудрость принадлежала мирному времени.$B$BДля каждого урока есть свое время и место, и сейчас, когда на горизонте встает тьма, время этой мудрости прошло.$B$BСжигая свиток, мы принимаем грядущие перемены и даем обещание действовать. В руке твоей – пламя, что освещает наше будущее.', 64978),
(29524, 'ruRU', 'Любопытно.$B$BТы здесь не больше часа – а уже на равных сражаешься с опытными учениками.$B$BТы можешь многого добиться, но помни, что твое обучение еще только начинается.', 64978),
(29522, 'ruRU', 'Здравствуй! Ты держишься так спокойно и уверенно... Мне это нравится!$B$BО тебе среди учеников ходят удивительные слухи. Если твои способности хотя бы наполовину так хороши, как все говорят, думаю, мы станем хорошими друзьями!', 64978),
(29414, 'ruRU', 'Путь твой ясен. Ты будешь $gтем:той;, кто вновь разожжет пламя духа огня и вернет его в храм.$B$BВы с Аисой не последний раз работаете вместе. Она сильная и мудрая. Ты можешь ей довериться.', 64978),
(29523, 'ruRU', 'Ты знаешь, что это такое – ухватиться за шанс. Мы с тобой – родственные души, $n.', 64978),
(29418, 'ruRU', '$n! Ты $Gвернулся и принес:вернулась и принесла; корни! А ты времени зря не теряешь. Отлично!', 64978),
(29417, 'ruRU', 'А в тебе есть боевой дух! Пожалуй, ты мне нравишься!', 64978),
(29420, 'ruRU', 'Жизнь заключается не в поиске себя. Жизнь – это саморазвитие. Путь перед тобой открыт, но испытания для себя на этом пути будешь выбирать только ты.', 64978),
(29664, 'ruRU', 'Эти огни придадут тебе силу, которую ты еще не $gобрел:обрела;. Они усилят способности, сокрытые в тебе.', 64978),
(29421, 'ruRU', 'Помни: лучший из воинов тот, кто в словах своих скромен, но добивается успеха действиями.', 64978),
(29422, 'ruRU', '<Присмотревшись, сквозь яркое свечение вы замечаете, что он улыбается. Похоже, вы ему понравились.>', 64978),
(29423, 'ruRU', '$n, ты очень хорошо $gсправился:справилась; с поручением. Хо здесь, и огни храма загорелись вновь. Судя по легкости, с которой тебе далось это задание, тебе многое по плечу.$B$BВ пребывании Хо в храме есть великий смысл. Пришло время поведать тебе о грядущем.', 64978),
(29521, 'ruRU', 'Рада снова видеть тебя, $n.$B$BТы, должно быть, уже $gпонял:поняла;, что купание в этом пруду превращает в скунса. За время существования Шэнь-Цзынь Су в этих некогда волшебных прудах погибло немало животных. Духи погибших слились с водой, и любой прикоснувшийся к этой воде обретает их облик.$B$BЗдесь есть несколько таких проклятых прудов, и некоторые из них опаснее прочих.', 64978);

DELETE FROM `quest_request_items_locale` WHERE (`locale`='ruRU' AND `ID` IN (30027,29424,29418,29523,29422));
INSERT INTO `quest_request_items_locale` (`ID`, `locale`, `CompletionText`, `VerifiedBuild`) VALUES
(30027, 'ruRU', 'Выбор своего первого оружия – событие в некотором смысле символическое. $gКаждый:Каждая:c; |3-6($c), покинув тренировочную площадку, $gдолжен быть готов:должна быть готова; взять в руки оружие, чтобы защищать свой народ.', 64978),
(29424, 'ruRU', 'О лесных духах не беспокойся. На самом деле они – обычные растения и со временем снова дадут побеги.', 64978),
(29418, 'ruRU', 'Ты ведь не боишься испачкать руки, не так ли?', 64978),
(29523, 'ruRU', 'Когда нам предоставляется шанс, наша обязанность – протянуть руку и крепко за него ухватиться. Поддаться сомнению равносильно поражению.', 64978),
(29422, 'ruRU', '<Хо спокойно парит над прудом.>', 64978);

DELETE FROM `quest_request_items` WHERE `ID`=29422;
INSERT INTO `quest_request_items` (`ID`, `EmoteOnComplete`, `EmoteOnIncomplete`, `EmoteOnCompleteDelay`, `EmoteOnIncompleteDelay`, `VerifiedBuild`) VALUES
(29422, 0, 1, 0, 0, 64978); -- Huo, the Spirit of Fire

INSERT INTO `gameobject_template_locale` (`entry`, `locale`, `name`, `castBarCaption`, `unk1`, `VerifiedBuild`) VALUES
(210005, 'ruRU', 'Оружейная стойка', '', NULL, 64978);
