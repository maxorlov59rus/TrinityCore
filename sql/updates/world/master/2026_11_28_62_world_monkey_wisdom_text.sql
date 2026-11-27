-- VERIFY: привязка spell 104126 к spell_monkey_wisdom_text взята из DekkCore Source 10.1
-- (sql/base/world/spell_script_names.sql); клиент 12.1.5.70961 (SpellEffect.csv) подтверждает
-- SpellID=104126, EffectIndex=0, Effect=77 = SPELL_EFFECT_SCRIPT_EFFECT; живая БД проверена,
-- существующей строки для 104126 нет; SpellInfo/флаги не изменяются — скрипт только реагирует на эффект.

DELETE FROM `spell_script_names` WHERE `spell_id`=104126 AND `ScriptName`='spell_monkey_wisdom_text';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(104126, 'spell_monkey_wisdom_text');
