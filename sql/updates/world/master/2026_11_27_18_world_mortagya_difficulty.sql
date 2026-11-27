-- Issue #30858: Morta'gya the Keeper should use the 12.x difficulty row with its loot/tuning data.

DELETE FROM `creature_template_difficulty` WHERE `Entry` = 42877 AND `DifficultyID` = 0 AND `VerifiedBuild` = 0;
UPDATE `creature_template_difficulty` SET `DifficultyID` = 0 WHERE `Entry` = 42877 AND `DifficultyID` = 1;
