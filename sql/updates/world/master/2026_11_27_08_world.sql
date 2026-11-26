-- Maztha (44919), the Horde flight master in Orgrimmar, had npcflag 82
-- (QUESTGIVER|TRAINER|TRAINER_PROFESSION) and no gossip menu, so she opened
-- neither the flight map nor the riding trainer. Ported from BFA-HavenCore
-- 2026_07_10_07.sql / _08.sql, adapted to the current gossip/trainer schema.
-- The old default trainer binding (44919, 386, 0, 0) is replaced with an
-- explicit gossip option bound to a dedicated riding trainer.

UPDATE `creature_template` SET `npcflag` = 8275, `gossip_menu_id` = 944919 WHERE `entry` = 44919;

DELETE FROM `gossip_menu` WHERE `MenuID` = 944919;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`, `VerifiedBuild`) VALUES
(944919, 0, 0);

DELETE FROM `gossip_menu_option` WHERE `MenuID` = 944919;
INSERT INTO `gossip_menu_option`
(`MenuID`, `GossipOptionID`, `OptionID`, `OptionNpc`, `OptionText`, `OptionBroadcastTextID`, `Language`, `Flags`, `ActionMenuID`, `ActionPoiID`, `GossipNpcOptionID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `SpellID`, `OverrideIconID`, `VerifiedBuild`)
VALUES
(944919, 0, 0, 3, 'Train me.', 3266, 0, 0, 0, 0, NULL, 0, 0, NULL, 0, NULL, NULL, 0);

DELETE FROM `trainer` WHERE `Id` = 944919;
INSERT INTO `trainer` (`Id`, `Type`, `Greeting`, `VerifiedBuild`) VALUES
(944919, 2, 'I can teach you to ride, if you have the coin and the courage.', 0);

DELETE FROM `trainer_spell` WHERE `TrainerId` = 944919;
INSERT INTO `trainer_spell`
(`TrainerId`, `SpellId`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqAbility1`, `ReqAbility2`, `ReqAbility3`, `ReqLevel`, `VerifiedBuild`)
VALUES
(944919, 33388, 40000,    762, 0,   0, 0, 0, 0, 0), -- Apprentice Riding
(944919, 33391, 500000,   762, 75,  0, 0, 0, 0, 0), -- Journeyman Riding
(944919, 34090, 2500000,  762, 150, 0, 0, 0, 0, 0), -- Expert Riding
(944919, 34091, 50000000, 762, 225, 0, 0, 0, 0, 0), -- Artisan Riding
(944919, 90265, 50000000, 762, 300, 0, 0, 0, 0, 0); -- Master Riding

DELETE FROM `creature_trainer` WHERE `CreatureID` = 44919;
INSERT INTO `creature_trainer` (`CreatureID`, `TrainerID`, `MenuID`, `OptionID`) VALUES
(44919, 944919, 944919, 0);
