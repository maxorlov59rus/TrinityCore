-- Issue #28657: Restore the battle pet training intro chain in each starting zone.
-- Only PrevQuestID/NextQuestID are updated so existing addon data is preserved.

INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`,`NextQuestID`) VALUES
-- Goldshire (Marcus Jensen)
(31308, 0, 31309),
(31309, 31308, 31785),
(31785, 31309, 31550),
(31550, 31785, 0),
-- Tirisfal Glades (Ansel Fincap)
(31576, 0, 31577),
(31577, 31576, 31823),
(31823, 31577, 31578),
(31578, 31823, 0),
-- Stormwind City (Audrey Burnhep)
(31591, 0, 31592),
(31592, 31591, 31821),
(31821, 31592, 31593),
(31593, 31821, 0),
-- Durotar (Narzak)
(31571, 0, 31572),
(31572, 31571, 31830),
(31830, 31572, 31570),
(31570, 31830, 0),
-- Dun Morogh (Grady Bannson)
(31548, 0, 31549),
(31549, 31548, 31822),
(31822, 31549, 31551),
(31551, 31822, 0),
-- Teldrassil (Valeena)
(31552, 0, 31553),
(31553, 31552, 31826),
(31826, 31553, 31555),
(31555, 31826, 0),
-- Orgrimmar (Matty)
(31585, 0, 31586),
(31586, 31585, 31828),
(31828, 31586, 31587),
(31587, 31828, 0),
-- Orgrimmar (Varzok)
(31588, 0, 31589),
(31589, 31588, 31827),
(31827, 31589, 31590),
(31590, 31827, 0),
-- Azuremyst Isle (Lehna)
(31556, 0, 31568),
(31568, 31556, 31825),
(31825, 31568, 31569),
(31569, 31825, 0),
-- Eversong Woods (Jarson Everlong)
(31579, 0, 31580),
(31580, 31579, 31824),
(31824, 31580, 31581),
(31581, 31824, 0),
-- Mulgore (Naleen)
(31573, 0, 31574),
(31574, 31573, 31831),
(31831, 31574, 31575),
(31575, 31831, 0),
-- Darkshore (Will Larsons)
(31582, 0, 31583),
(31583, 31582, 31832),
(31832, 31583, 31584),
(31584, 31832, 0)
ON DUPLICATE KEY UPDATE `PrevQuestID` = VALUES(`PrevQuestID`), `NextQuestID` = VALUES(`NextQuestID`);
