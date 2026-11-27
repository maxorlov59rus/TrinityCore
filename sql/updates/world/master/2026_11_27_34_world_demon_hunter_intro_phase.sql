-- Demon Hunter starting zone phase: adapt the old aura-based report to phase_area + conditions (issue #19147).
-- The intro scene itself is already handled by zone_mardum.cpp; only the cosmetic post-scene phase is missing.
-- Phases are no longer aura-driven, so only the quest-state conditions are ported.
SET @PHASE := 4899;
SET @AREA := 7705;
SET @INTRO_QUEST := 40076;
SET @NEXT_QUEST := 40077;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=@PHASE AND `SourceEntry`=@AREA AND `SourceId`=0 AND
  `ConditionTypeOrReference` IN (8, 14) AND `ConditionValue1` IN (@INTRO_QUEST, @NEXT_QUEST);

INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(26, @PHASE, @AREA, 0, 1, 8, 0, @INTRO_QUEST, 0, 0, '', 0, 0, 0, '', 'Set phase 4899 in area 7705 if Demon Hunter intro quest 40076 is rewarded'),
(26, @PHASE, @AREA, 0, 1, 14, 0, @NEXT_QUEST, 0, 0, '', 0, 0, 0, '', 'Set phase 4899 in area 7705 while quest 40077 has never been taken');
