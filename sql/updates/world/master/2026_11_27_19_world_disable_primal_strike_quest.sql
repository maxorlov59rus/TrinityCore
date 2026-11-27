-- Issue #18354: Primal Strike (27027) was removed in later expansions and must not be offered.

DELETE FROM `disables` WHERE `sourceType` = 1 AND `entry` = 27027;
INSERT INTO `disables` (`sourceType`,`entry`,`flags`,`params_0`,`params_1`,`comment`) VALUES
(1, 27027, 0, '', '', 'Obsolete quest: Primal Strike');
