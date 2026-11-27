-- Сюжет Драконьих островов, часть 1 (#30696): недостающие привязки квестодателей и квестополучателей.
-- Все ID ниже сверены со сниффом WPP V11_0_7_58911 и текущей TDB 1210.26091.
-- VERIFY: не переносятся спавны, GUID, фазы, waypoints, gossip и строки с quest=0;
-- NPC 190155, 186767, 187406 и 188297 не имеют подтверждённых локальных спавнов и флагов
-- квестодателя, поэтому одни quest-link строки не делают цепочку видимой в мире.
-- Фазовые дубли NPC (Wrathion 186640/194772, Sendrax 193362/193363, Naleidea 184841/197279
-- и др.) оставлены вне коммита: без данных о фазах выбрать корректный вариант нельзя.
-- Изменения creature_template.npcflag и PhaseId также не переносятся.

DELETE FROM `creature_queststarter` WHERE
    (`id`=190155 AND `quest`=65997) OR
    (`id`=186767 AND `quest`=65996) OR
    (`id`=188297 AND `quest`=66998);

INSERT INTO `creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
    (190155, 65997, 58911), -- Caretaker Azkra — Chasing Sendrax
    (186767, 65996, 58911), -- Majordomo Selistra — Veteran Reinforcements
    (188297, 66998, 58911); -- Caretaker Ventraz — Fighting Fire with... Water

DELETE FROM `creature_questender` WHERE
    (`id`=187406 AND `quest`=65997) OR
    (`id`=190155 AND `quest`=65996) OR
    (`id`=188297 AND `quest`=66998);

INSERT INTO `creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
    (187406, 65997, 58911), -- Sendrax — Chasing Sendrax
    (190155, 65996, 58911), -- Caretaker Azkra — Veteran Reinforcements
    (188297, 66998, 58911); -- Caretaker Ventraz — Fighting Fire with... Water
