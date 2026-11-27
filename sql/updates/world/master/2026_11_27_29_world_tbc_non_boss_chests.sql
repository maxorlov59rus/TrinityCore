-- Remove non-boss chests from TBC dungeons (issue #28775).
-- Source: Blizzard forum post by Crygil, 2009-06-04.
DELETE FROM `gameobject` WHERE `guid` IN (4713, 4719, 6990, 11222, 13822, 25829, 25830, 25831, 25832, 32632, 32635, 32636, 32710, 43140, 43141);
