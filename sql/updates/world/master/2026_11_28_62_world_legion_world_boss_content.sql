-- VERIFY: дозагрузка стоковых данных Legion для 14 мировых боссов и их помощников.
-- Источники: полная БД LegionCore 7.3.5V2 (creature_loot_template, creature_text,
-- creature_template_spell, creature_template_addon) и полная БД WarAxe_Legion 7.3.5.
-- Таблицы loot LegionCore и WarAxe для целевых entry совпадают построчно; все положительные
-- Item.rst проверены по клиентским Item.csv и ItemSparse.csv сборки 12.1.5.70961.
--
-- Преобразования в схему текущего ядра:
--   LegionCore.ChanceOrQuestChance < 0 -> QuestRequired=1, Chance=abs(значения);
--   ChanceOrQuestChance = 0 -> Chance=100 (в LegionCore/WarAxe это гарантированная выпадка;
--     текущий LootStoreItem::IsValid явно отклоняет Chance=0 с GroupId=0);
--   lootmode = 0 -> LootMode=1 (текущий LootTemplate::Process не выбирает режим 0);
--   отрицательный Item (ссылка 1155) пропущен: reference_loot_template в живой БД пуст;
--   creature_template_difficulty.LootID выставлен равным entry (в WarAxe lootid=entry),
--     иначе loot загружается, но никогда не выдаётся.
--   Ускоритель душа Withered J'im: спавн 102075 уже добавлен ранее.
--
-- Реплики: BroadcastTextId проверены в hotfixes.broadcast_text (база enUS) и
-- hotfixes.broadcast_text_locale (ruRU) живой БД. Эти ID отсутствуют в серверном
-- BroadcastText.db2 и в hotfix_blob, поэтому BT обнуляется, а проверенный RU-текст
-- переносится в world.creature_text_locale; дублей готовых строк в живой БД нет.
-- Исключены: 108879 group 2 "Get an ice fist!" (BroadcastTextId=0, RU не подтверждён),
-- 107023 как неиспользуемый alternate entry Nithogg (реплика BT 111614 перенесена на 107544),
-- 117470/107569/110772 как не портированные NPC, 117303 (нет подтверждённой реплики).
--
-- creature_template_spell: исходная колонка difficultyMask отсутствует в живой схеме;
-- Index назначен последовательно в порядке строк источника, VerifiedBuild=69497 из источника.
-- creature_template_addon: перенесена только aura 223355 для 112128; запись 107544
-- (упакованный bytes1=33554432) не переносится из-за неоднозначного соответствия полям
-- текущей схемы и риска сделать босса постоянно невидимым.
--
-- Gossip-строк и AT-биндингов для целевых entry в авторитетных источниках нет;
-- кастомные AT 7053/7411/7480/7630/7640/7650/7873/9466 не добавляются.
--
-- Исправление старой опечатки: spell_flotsam_getsam_damage привязан к 220377,
-- хотя код boss_flotsam.cpp использует 220367 (оба ID есть в SpellName.csv).

-- Исправляем привязку spell_flotsam_getsam_damage.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_flotsam_getsam_damage' AND `spell_id` IN (220367, 220377);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
    (220367, 'spell_flotsam_getsam_damage');

-- LootID обязателен: без него creature_loot_template не участвует в генерации лута.
UPDATE `creature_template_difficulty` SET `LootID` = `Entry`
WHERE `DifficultyID` = 0 AND `Entry` IN (99929, 102075, 106981, 106982, 106984, 107544, 108678, 108829, 108879, 109331, 109943, 110321, 110378, 117239, 117303, 121124);

-- Loot: до удаления в живой БД было 0 строк для перечисленных entry.
DELETE FROM `creature_loot_template` WHERE `Entry` IN (99929, 102075, 106981, 106982, 106984, 107544, 108678, 108829, 108879, 109331, 109943, 110321, 110378, 117239, 117303, 121124);

INSERT INTO `creature_loot_template`
(`Entry`, `ItemType`, `Item`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
VALUES
(99929, 0, 141466, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(99929, 0, 141470, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(99929, 0, 141475, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(99929, 0, 141476, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(99929, 0, 141516, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(99929, 0, 141539, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(99929, 0, 141544, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(102075, 0, 141449, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(102075, 0, 141453, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(102075, 0, 141455, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(102075, 0, 141459, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(102075, 0, 141482, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(102075, 0, 141492, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(102075, 0, 141543, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 124437, 46.2366, 0, 1, 0, 1, 3, 'Legion world boss loot'),
(106981, 0, 138000, 1.2, 0, 1, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 139529, 0.3421, 0, 1, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 139531, 0.3421, 0, 1, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 139547, 100, 0, 1, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 141434, 0.0978, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 141436, 0.0978, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 141442, 0.0978, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 141444, 0.0978, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 141506, 0.0978, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 141514, 0.0978, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 141537, 0.0978, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 144309, 1.2, 0, 1, 0, 1, 1, 'Legion world boss loot'),
(106981, 0, 144363, 0.5132, 0, 1, 0, 1, 1, 'Legion world boss loot'),
(106982, 0, 124437, 1.3514, 0, 1, 0, 1, 1, 'Legion world boss loot'),
(106982, 0, 141434, 5.4054, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106982, 0, 141436, 5.4054, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106982, 0, 141442, 5.4054, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106982, 0, 141444, 5.4054, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106982, 0, 141506, 5.4054, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106982, 0, 141514, 5.4054, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106982, 0, 141537, 5.4054, 1, 23, 0, 1, 1, 'Legion world boss loot'),
(106984, 0, 141434, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(106984, 0, 141436, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(106984, 0, 141442, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(106984, 0, 141444, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(106984, 0, 141506, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(106984, 0, 141514, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(106984, 0, 141537, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(107544, 0, 141414, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(107544, 0, 141418, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(107544, 0, 141420, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(107544, 0, 141424, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(107544, 0, 141519, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(107544, 0, 141541, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(107544, 0, 141546, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108678, 0, 141481, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108678, 0, 141487, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108678, 0, 141491, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108678, 0, 141495, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108678, 0, 141518, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108678, 0, 141542, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108678, 0, 141547, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108829, 0, 141431, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108829, 0, 141435, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108829, 0, 141440, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108829, 0, 141441, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108829, 0, 141473, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108829, 0, 141523, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108829, 0, 141545, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108879, 0, 139895, 100, 0, 3, 0, 1, 1, 'Legion world boss loot'),
(108879, 0, 141416, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108879, 0, 141422, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108879, 0, 141426, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108879, 0, 141445, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108879, 0, 141521, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108879, 0, 141536, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(108879, 0, 141540, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109331, 0, 132233, 18.4615, 0, 3, 0, 1, 1, 'Legion world boss loot'),
(109331, 0, 132234, 10.7692, 0, 3, 0, 1, 1, 'Legion world boss loot'),
(109331, 0, 138839, 3.0769, 0, 3, 0, 1, 1, 'Legion world boss loot'),
(109331, 0, 141430, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109331, 0, 141432, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109331, 0, 141437, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109331, 0, 141438, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109331, 0, 141443, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109331, 0, 141522, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109331, 0, 141533, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109331, 0, 141877, 3.0769, 0, 3, 0, 1, 1, 'Legion world boss loot'),
(109943, 0, 141413, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109943, 0, 141419, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109943, 0, 141423, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109943, 0, 141427, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109943, 0, 141448, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109943, 0, 141486, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(109943, 0, 141520, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110321, 0, 141415, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110321, 0, 141417, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110321, 0, 141421, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110321, 0, 141425, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110321, 0, 141488, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110321, 0, 141515, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110321, 0, 141534, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110321, 0, 142121, 100, 0, 1, 0, 1, 1, 'Legion world boss loot'),
(110378, 0, 141428, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110378, 0, 141429, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110378, 0, 141433, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110378, 0, 141439, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110378, 0, 141517, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110378, 0, 141535, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(110378, 0, 141538, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117239, 0, 147732, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117239, 0, 147739, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117239, 0, 147742, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117239, 0, 147747, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117239, 0, 147748, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117239, 0, 147749, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117239, 0, 147755, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117239, 0, 147756, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117239, 0, 147765, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117303, 0, 147733, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117303, 0, 147735, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117303, 0, 147740, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117303, 0, 147741, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117303, 0, 147744, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117303, 0, 147745, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117303, 0, 147750, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117303, 0, 147754, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117303, 0, 147758, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(117303, 0, 147764, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(121124, 0, 147730, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(121124, 0, 147734, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(121124, 0, 147738, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(121124, 0, 147743, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(121124, 0, 147753, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(121124, 0, 147759, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(121124, 0, 147760, 100, 0, 23, 0, 1, 1, 'Legion world boss loot'),
(121124, 0, 147766, 100, 0, 23, 0, 1, 1, 'Legion world boss loot')
;


-- Реплики: EN-текст из WarAxe_Legion 7.3.5, RU из hotfixes.broadcast_text_locale (ruRU).
-- BroadcastTextId в авторитетных дампах есть, но в клиентском BroadcastText.db2 и в hotfix_blob
-- текущей сборки этих 13 ID нет; ядро обнулило бы ссылку и выдало ошибки загрузки. Поэтому BT=0,
-- а локализация берётся из creature_text_locale. Повторных *_locale-строк нет.
DELETE FROM `creature_text` WHERE `CreatureID` IN (99929,107544,108879,110378,121124);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundPlayType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(99929, 0, 0, 'Why I eat so many murlocs?', 14, 0, 100, 0, 0, 0, 0, 0, 0, 'Обломок — случайная реплика'),
(99929, 0, 1, 'Tummy too rumbly...', 14, 0, 100, 0, 0, 0, 0, 0, 0, 'Обломок — случайная реплика'),
(99929, 1, 0, 'Eternal... slumber...', 12, 0, 100, 0, 0, 0, 0, 0, 0, 'Обломок — смерть'),
(108879, 0, 0, 'Make the boomy fire thing! Make the boom!', 14, 0, 100, 0, 0, 0, 0, 0, 0, 'Хумонгрис — Fire Boom'),
(108879, 1, 0, 'I want Snow! Make it snow! Make it Snow! Make it Snow!', 14, 0, 100, 0, 0, 0, 0, 0, 0, 'Хумонгрис — Make the Snow'),
(108879, 1, 1, 'I want snow! Make the snow!', 14, 0, 100, 0, 0, 0, 0, 0, 0, 'Хумонгрис — Make the Snow'),
(110378, 0, 0, 'Oooh shiny!', 14, 0, 100, 0, 0, 0, 0, 0, 0, 'Драгон Зиморожденный — случайная реплика'),
(110378, 0, 1, 'That one mine!', 14, 0, 100, 0, 0, 0, 0, 0, 0, 'Драгон Зиморожденный — случайная реплика'),
(110378, 1, 0, 'Pfff... too ugly.', 14, 0, 100, 0, 0, 0, 0, 0, 0, 'Драгон Зиморожденный — случайная реплика'),
(110378, 1, 1, 'Yuck... too hairy.', 14, 0, 100, 0, 0, 0, 0, 0, 0, 'Драгон Зиморожденный — случайная реплика'),
(110378, 1, 2, 'Ew... too stinky.', 14, 0, 100, 0, 0, 0, 0, 0, 0, 'Драгон Зиморожденный — случайная реплика'),
(107544, 0, 0, '|TINTERFACE\\ICONS\\warrior_talent_icon_thunderstruck:20|t Nithogg unleashes a |cFFFF0404|Hspell:212841|h[Crackling Jolt]|h|r!', 42, 0, 100, 0, 0, 0, 0, 0, 0, 'Нитхёгг — Crackling Jolt; перенесено с alternate entry 107023'),
(121124, 0, 0, 'Annihilate!', 12, 0, 100, 0, 0, 0, 0, 0, 0, 'Апокрон — случайная реплика')
;

DELETE FROM `creature_text_locale` WHERE `CreatureID` IN (99929,107544,108879,110378,121124);
INSERT INTO `creature_text_locale` (`CreatureID`,`GroupID`,`ID`,`Locale`,`Text`) VALUES
(99929, 1, 0, 'ruRU', 'Вечный... сон...'),
(107544, 0, 0, 'ruRU', '|TINTERFACE\\ICONS\\warrior_talent_icon_thunderstruck:20|t Нитхегг высвобождает |cFFFF0404|Hspell:212841|h["Сотрясающий разряд"]|h|r!'),
(108879, 0, 0, 'ruRU', 'Сделать взрывной огонь! Сделать бум!'),
(108879, 1, 0, 'ruRU', 'Хочу снега! Пусть будет снег! Пусть будет снег! Пусть будет снег!'),
(108879, 1, 1, 'ruRU', 'Хочу снега! Сделать снег!'),
(99929, 0, 1, 'ruRU', 'В животе урчит.'),
(99929, 0, 0, 'ruRU', 'Не стоило есть столько мурлоков...'),
(110378, 0, 0, 'ruRU', 'Ой, блестяшка!'),
(110378, 0, 1, 'ruRU', 'А вот это мне!'),
(110378, 1, 2, 'ruRU', 'Фу... воняет.'),
(110378, 1, 1, 'ruRU', 'Жуть, ну и космы.'),
(110378, 1, 0, 'ruRU', 'Пф! Какое уродство.'),
(121124, 0, 0, 'ruRU', 'Аннигиляция!')
;

-- creature_template_spell: 77 уникальных ID из LegionCore; все есть в SpellName.csv.
DELETE FROM `creature_template_spell` WHERE `CreatureID` IN (99929,102075,106981,106982,106984,107353,108678,108829,108879,109331,109943,110321,110378,112128,117239,117303,121124);
INSERT INTO `creature_template_spell` (`CreatureID`,`Index`,`Spell`,`VerifiedBuild`) VALUES
(99929, 0, 220295, 69497),
(99929, 1, 220340, 69497),
(99929, 2, 223317, 69497),
(99929, 3, 223373, 69497),
(102075, 0, 213738, 69497),
(102075, 1, 215377, 69497),
(102075, 2, 223614, 69497),
(102075, 3, 223623, 69497),
(102075, 4, 223632, 69497),
(102075, 5, 223689, 69497),
(102075, 6, 223715, 69497),
(106981, 0, 213420, 69497),
(106981, 1, 213522, 69497),
(106981, 2, 213532, 69497),
(106981, 3, 213738, 69497),
(106982, 0, 213588, 69497),
(106982, 1, 213590, 69497),
(106982, 2, 213665, 69497),
(106982, 3, 213738, 69497),
(106984, 0, 213606, 69497),
(106984, 1, 213625, 69497),
(106984, 2, 213738, 69497),
(107353, 0, 212943, 69497),
(107353, 1, 212948, 69497),
(108678, 0, 215806, 69497),
(108678, 1, 215860, 69497),
(108678, 2, 215821, 69497),
(108829, 0, 217229, 69497),
(108829, 1, 217235, 69497),
(108829, 2, 217249, 69497),
(108829, 3, 217344, 69497),
(108829, 4, 217352, 69497),
(108829, 5, 217362, 69497),
(108829, 6, 223971, 69497),
(108879, 0, 216428, 69497),
(108879, 1, 216430, 69497),
(108879, 2, 216432, 69497),
(108879, 3, 216467, 69497),
(108879, 4, 216817, 69497),
(109331, 0, 217874, 69497),
(109331, 1, 217877, 69497),
(109331, 2, 217893, 69497),
(109331, 3, 217966, 69497),
(109331, 4, 217986, 69497),
(109331, 5, 218012, 69497),
(109331, 6, 225832, 69497),
(109943, 0, 207995, 69497),
(109943, 1, 207998, 69497),
(109943, 2, 207999, 69497),
(109943, 3, 218823, 69497),
(109943, 4, 218888, 69497),
(109943, 5, 219045, 69497),
(109943, 6, 219254, 69497),
(109943, 7, 224762, 69497),
(110321, 0, 213738, 69497),
(110321, 1, 219349, 69497),
(110321, 2, 219591, 69497),
(110321, 3, 219813, 69497),
(110321, 4, 219861, 69497),
(110321, 5, 224762, 69497),
(110378, 0, 219493, 69497),
(110378, 1, 219542, 69497),
(110378, 2, 219601, 69497),
(110378, 3, 219602, 69497),
(110378, 4, 219610, 69497),
(110378, 5, 219625, 69497),
(110378, 6, 219803, 69497),
(112128, 0, 213738, 69497),
(112128, 1, 215377, 69497),
(112128, 2, 223350, 69497),
(112128, 3, 223355, 69497),
(117239, 0, 233484, 69497),
(117239, 1, 233515, 69497),
(117239, 2, 233519, 69497),
(117239, 3, 233566, 69497),
(117239, 4, 234389, 69497),
(117239, 5, 234394, 69497),
(117303, 0, 233570, 69497),
(117303, 1, 233614, 69497),
(117303, 2, 234452, 69497),
(121124, 0, 241458, 69497),
(121124, 1, 241498, 69497),
(121124, 2, 241506, 69497),
(121124, 3, 241518, 69497)
;

-- creature_template_addon: aura Regurgitated Marshstomper (112128) из LegionCore.
-- Запись 107544 с bytes1=33554432 не переносится: в текущей схеме это VisFlags STEALTHED
-- без снятия stealth в исходном скрипте, что сделало бы босса постоянно невидимым.
DELETE FROM `creature_template_addon` WHERE `entry` IN (112128);
INSERT INTO `creature_template_addon` (`entry`,`PathId`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(112128, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '223355');

-- VERIFY запросы (ожидаемые значения):
-- SELECT COUNT(*) FROM creature_loot_template WHERE Entry IN (99929,102075,106981,106982,106984,107544,108678,108829,108879,109331,109943,110321,110378,117239,117303,121124); -- 132
-- SELECT COUNT(*) FROM creature_text WHERE CreatureID IN (99929,107544,108879,110378,121124); -- 13
-- SELECT COUNT(*) FROM creature_text_locale WHERE CreatureID IN (99929,107544,108879,110378,121124) AND Locale='ruRU'; -- 13
-- SELECT COUNT(*) FROM creature_template_spell WHERE CreatureID IN (99929,102075,106981,106982,106984,107353,108678,108829,108879,109331,109943,110321,110378,112128,117239,117303,121124); -- 84
-- SELECT entry, auras FROM creature_template_addon WHERE entry = 112128; -- 223355
-- SELECT COUNT(*) FROM creature_template_difficulty WHERE DifficultyID = 0 AND LootID = Entry AND Entry IN (99929,102075,106981,106982,106984,107544,108678,108829,108879,109331,109943,110321,110378,117239,117303,121124); -- 16
-- SELECT spell_id FROM spell_script_names WHERE ScriptName = 'spell_flotsam_getsam_damage'; -- 220367
