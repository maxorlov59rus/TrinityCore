-- Issue #22216: Hide the Loch Modan breadcrumb once The Lost Pilot is no longer available.

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceGroup` = 0 AND `SourceEntry` = 26131 AND `SourceId` = 0 AND `ElseGroup` = 0 AND `ConditionTypeOrReference` = 14 AND `ConditionValue1` = 26854;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ConditionStringValue1`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19, 0, 26131, 0, 0, 14, 0, 26854, 0, 0, '', 1, 0, 0, '', 'Quest 26131 is unavailable while quest 26854 is taken, complete or rewarded');
