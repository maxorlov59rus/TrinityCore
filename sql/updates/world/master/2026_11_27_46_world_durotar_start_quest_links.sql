-- Стартовая зона орков, Дюротар (#30694): недостающие привязки квестодателей и квестополучателей.
-- Все ID ниже сверены со сниффом WPP V11_0_7_58911 и текущей TDB 1210.
-- VERIFY: не переносятся спавны, GUID, фазы, waypoints, gossip, quest=0 и спорные концовки;
-- NPC 214477, 214591, 214707 и 37172 не имеют подтверждённых локальных спавнов, поэтому
-- одни quest-link строки не делают их видимыми в мире. Изменения creature_template.npcflag
-- и несовместимые со схемой PhaseId оставлены вне этого минимального коммита.

DELETE FROM `creature_queststarter` WHERE
    (`id`=214591 AND `quest`=78989) OR
    (`id`=37172 AND `quest`=78982) OR
    (`id`=214477 AND `quest`=78980);

INSERT INTO `creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
    (214591, 78989, 58911), -- Ning — The Gift of Self-Care
    (37172, 78982, 58911), -- Detective Snap Snagglebolt — I Smell Trouble
    (214477, 78980, 58911); -- Mahaja Cloudsong — Take a Look Around

DELETE FROM `creature_questender` WHERE (`id`=214477 AND `quest`=78980);

INSERT INTO `creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
    (214477, 78980, 58911); -- Mahaja Cloudsong — Take a Look Around
