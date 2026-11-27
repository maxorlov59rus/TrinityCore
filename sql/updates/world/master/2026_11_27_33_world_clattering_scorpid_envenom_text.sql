-- Clattering Scorpid shows the Envenom warning only to players on the quest (issue #18742).
SET @ENTRY := 3125;

DELETE FROM `smart_scripts` WHERE `entryorguid`=@ENTRY AND `source_type`=0 AND `id`=4 AND `link`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(@ENTRY, 0, 4, 0, '', 31, 0, 100, 0, 73672, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, 0, NULL, 1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 'Clattering Scorpid - On Envenom hit - Say 0');

-- SourceGroup 32 = SAI event 31 (SMART_EVENT_SPELLHIT_TARGET).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=@ENTRY AND `SourceId`=0 AND
  ((`SourceGroup`=3 AND `ConditionTypeOrReference`=1 AND `ConditionValue1`=73673) OR
   (`SourceGroup`=32 AND `ConditionTypeOrReference`=9 AND `ConditionValue1`=25165));
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 32, @ENTRY, 0, 0, 1, 0, 73673, 1, 0, '', 0, 0, 0, '', 'SAI - Require the Envenom totem aura for quest credit and warning'),
(22, 32, @ENTRY, 0, 0, 9, 0, 25165, 0, 0, '', 0, 0, 0, '', 'SAI - Show Envenom warning only while on Never Trust a Big Barb and a Smile');
