-- Драктэрская стартовая цепочка, орда (#30660): оставшиеся привязки квестодателей и квестополучателей.
-- ID сверены с WPP-дампом V11_0_7_58867 (dump_11.0.7.58867_2025-02-01_14-51-43.pkt)
-- и локальной TDB_full_world_1210.26091: квесты 65701/65071 и NPC 182258/184166/184212 существуют.
-- Добавляются только отсутствующие пары; спавны, GUID, npcflag и фазы не переносятся.

-- VERIFY (в этот SQL не включается):
--   карта 2570 из WPP помечена как "Child of 2444", PhaseId — строка из нескольких фаз;
--   SET @CGUID := SET_VALUE_MANUALLY_HERE запрещает копировать WPP-GUID без перебазирования;
--   у NPC 182258/184166/184212 локально нет спавнов и npcflag=0, поэтому иконки появятся
--   только после отдельного подтверждённого порта;
--   184793/65443 и 184786/72256 относятся к более поздней кампании Драконьих островов,
--   их ендеры уже есть на 197279 с VerifiedBuild=56647;
--   15891/8873 — праздничный квест, а quest=0 и quest=8192 — артефакты WPP;
--   Alliance-ветка 65286/66513/65101 и не-Evoker цепочка 84423→84424→85026
--   остаются неподтверждёнными и в SQL не добавляются.

DELETE FROM `creature_queststarter` WHERE
    (`id`=182258 AND `quest`=65701) OR (`id`=184166 AND `quest`=65071);

INSERT INTO `creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
    (182258, 65701, 58867), -- Scalecommander Emberthal — "Preservation, Augmentation, or Devastation"
    (184166, 65071, 58867); -- To'no — "Halp!"

DELETE FROM `creature_questender` WHERE
    (`id`=182258 AND `quest`=65701) OR (`id`=184212 AND `quest`=65071);

INSERT INTO `creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
    (182258, 65701, 58867), -- Scalecommander Emberthal — "Preservation, Augmentation, or Devastation"
    (184212, 65071, 58867); -- Explorer Ko'nali — "Halp!"
