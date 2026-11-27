-- The Emerald Dreamcatcher (issue #24098).
-- Tallonkai's Dresser stored the loot id in data30 (personal loot field instead of loot id).
SET @ENTRY := 126158;
SET @QID := 2438;

UPDATE `gameobject_template` SET `data1`=`data30`, `data30`=0, `VerifiedBuild`=69497 WHERE `entry`=@ENTRY;

INSERT INTO `quest_template_addon` (`ID`, `NextQuestID`, `SpecialFlags`) VALUES
(@QID, 2459, 0)
ON DUPLICATE KEY UPDATE `NextQuestID`=2459, `SpecialFlags`=0;
