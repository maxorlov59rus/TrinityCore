-- Экзил-Рич: охотник от первого квеста до Оргриммара (#30685), недостающие привязки квестодателей и квестополучателей.
-- ID ниже сверены со сниффом WPP V11_0_7_58911, TDB 1210.26091 и Wago DB2 build 11.0.7.58911.
-- VERIFY: не переносятся спавны, GUID (@CGUID := SET_VALUE_MANUALLY_HERE), PhaseId, waypoints,
--   UPDATE VerifiedBuild, gameobject_queststarter 330627/56839 и общие квесты 2/8192/8194/10240;
--   NPC 167183, 167596, 167631, 167632, 167633, 167675, 168431, 168441, 168540, 168545, 168551
--   не имеют подтверждённых локальных спавнов и/или npcflag QUESTGIVER, поэтому одни quest-link
--   строки могут быть недостаточны для появления квеста;
--   имена 167631/167632/167596/167633/167675 из сниффа 58911 расходятся с TDB 12.1,
--   ID взяты из дампа, имена в комментариях — по WPP object_names 58911.

DELETE FROM `creature_queststarter` WHERE
    (`id`=168545 AND `quest` IN (60359,60347)) OR
    (`id`=168441 AND `quest`=60344) OR
    (`id`=168431 AND `quest`=60343) OR
    (`id`=167675 AND `quest`=59985) OR
    (`id`=167183 AND `quest`=59984) OR
    (`id`=167632 AND `quest`=59979) OR
    (`id`=167631 AND `quest`=59980) OR
    (`id`=167633 AND `quest`=59981) OR
    (`id`=167596 AND `quest`=59978) OR
    (`id`=167212 AND `quest`=59975) OR
    (`id`=167215 AND `quest` IN (60162,59953,59952)) OR
    (`id`=167290 AND `quest` IN (59947,59944)) OR
    (`id`=167291 AND `quest` IN (59946,59945)) OR
    (`id`=157114 AND `quest`=54933) OR
    (`id`=167219 AND `quest`=59943) OR
    (`id`=167225 AND `quest`=59949);

INSERT INTO `creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
    (168545, 60359, 58911), -- Home Is Where the Hearth Is — Cork Fizzlepop
    (168545, 60347, 58911), -- What's Your Specialty? — Cork Fizzlepop
    (168441, 60344, 58911), -- Finding Your Way — Cork Fizzlepop
    (168431, 60343, 58911), -- Welcome to Orgrimmar — Warlord Breka Grimaxe
    (167675, 59985, 58911), -- An End to Beginnings — Warlord Breka Grimaxe
    (167183, 59984, 58911), -- Dungeon: Darkmaul Citadel — Warlord Mulgrin Thunderwalker
    (167632, 59979, 58911), -- Like Ogres to the Slaughter — Shuja Grimaxe
    (167631, 59980, 58911), -- Catapult Destruction — Herbert Gloomburst
    (167633, 59981, 58911), -- Controlling their Stones — Warlord Breka Grimaxe
    (167596, 59978, 58911), -- Right Beneath Their Eyes — Warlord Breka Grimaxe
    (167212, 59975, 58911), -- To Darkmaul Citadel — Warlord Breka Grimaxe
    (167215, 60162, 58911), -- The Art of Taming — Mithdran Dawntracker
    (167215, 59953, 58911), -- Hunting the Stalker — Mithdran Dawntracker
    (167215, 59952, 58911), -- A Hunter's Trap — Mithdran Dawntracker
    (167290, 59947, 58911), -- Message to Base — Shuja Grimaxe
    (167290, 59944, 58911), -- The Rescue of Herbert Gloomburst — Shuja Grimaxe
    (167291, 59946, 58911), -- Purge the Totems — Bo
    (167291, 59945, 58911), -- Harpy Culling — Bo
    (157114, 54933, 58911), -- Freeing the Light — Lightspawn
    (167219, 59943, 58911), -- The Harpy Problem — Shuja Grimaxe
    (167225, 59949, 58911); -- Who Lurks in the Pit — Lana Jordan

DELETE FROM `creature_questender` WHERE
    (`id`=46642 AND `quest`=60359) OR
    (`id`=168551 AND `quest`=60347) OR
    (`id`=168540 AND `quest`=60344) OR
    (`id`=168441 AND `quest`=60343) OR
    (`id`=168431 AND `quest`=59985) OR
    (`id`=167631 AND `quest`=59980) OR
    (`id`=167215 AND `quest` IN (60162,59953,59952));

INSERT INTO `creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
    (46642, 60359, 58911), -- Home Is Where the Hearth Is — Innkeeper Nufa
    (168551, 60347, 58911), -- What's Your Specialty? — Tamanji
    (168540, 60344, 58911), -- Finding Your Way — Rohaka Tuskmaul
    (168441, 60343, 58911), -- Welcome to Orgrimmar — Cork Fizzlepop
    (168431, 59985, 58911), -- An End to Beginnings — Warlord Breka Grimaxe
    (167631, 59980, 58911), -- Catapult Destruction — Herbert Gloomburst
    (167215, 60162, 58911), -- The Art of Taming — Mithdran Dawntracker
    (167215, 59953, 58911), -- Hunting the Stalker — Mithdran Dawntracker
    (167215, 59952, 58911); -- A Hunter's Trap — Mithdran Dawntracker
