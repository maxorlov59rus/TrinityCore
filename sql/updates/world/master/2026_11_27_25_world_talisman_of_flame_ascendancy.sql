-- DekkCore: Talisman of Flame Ascendancy should summon the quest NPC during The Flame Ascendancy.

DELETE FROM `item_script_names` WHERE `ScriptName` = 'talisman_of_flame_ascendancy';
INSERT INTO `item_script_names` (`Id`,`ScriptName`) VALUES
(54814, 'talisman_of_flame_ascendancy');
