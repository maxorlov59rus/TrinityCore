/*
 * This file is part of the TrinityCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Одинокий Остров (Пандария) -- «Мудрость обезьяны», spell 104126.
 *
 * Адаптация DekkCore Source 10.1 (src/server/scripts/DekkCore/Pandaria/
 * zone_the_wandering_isle.cpp:1184-1225) под актуальный master API:
 *   SpellScriptLoader + GetSpellScript()  ->  RegisterSpellScript(SpellScript)
 *   HandleScript(SpellEffIndex)           ->  без изменений
 * Поведение НЕ изменено: EFFECT_0 / SPELL_EFFECT_SCRIPT_EFFECT выбирает
 * urand(0,7) и говорит реплику 54073..54080 через
 * Talk(..., CHAT_MSG_RAID_BOSS_WHISPER, 0.0f, GetHitPlayer()).
 *
 * Источники:
 *  - DekkCore Source 10.1, spell_script_names.sql: 104126 -> spell_monkey_wisdom_text
 *  - Клиент 12.1.5.70961, SpellEffect.csv: SpellID=104126, EffectIndex=0,
 *    Effect=77 (SPELL_EFFECT_SCRIPT_EFFECT)
 *  - broadcast_text 54073..54080 и их ruRU-строки уже присутствуют в БД,
 *    поэтому дублирующих локализационных INSERT здесь нет.
 */

#include "ScriptMgr.h"
#include "DB2Stores.h"
#include "Player.h"
#include "SpellInfo.h"
#include "SpellScript.h"
#include "Util.h"

enum MonkeyWisdomTexts
{
    TEXT_MONKEY_WISDOM_1 = 54073,
    TEXT_MONKEY_WISDOM_2 = 54074,
    TEXT_MONKEY_WISDOM_3 = 54075,
    TEXT_MONKEY_WISDOM_4 = 54076,
    TEXT_MONKEY_WISDOM_5 = 54077,
    TEXT_MONKEY_WISDOM_6 = 54078,
    TEXT_MONKEY_WISDOM_7 = 54079,
    TEXT_MONKEY_WISDOM_8 = 54080
};

class spell_monkey_wisdom_text : public SpellScript
{
    PrepareSpellScript(spell_monkey_wisdom_text);

    bool Validate(SpellInfo const* /*spellInfo*/) override
    {
        return sBroadcastTextStore.LookupEntry(TEXT_MONKEY_WISDOM_1) &&
               sBroadcastTextStore.LookupEntry(TEXT_MONKEY_WISDOM_2) &&
               sBroadcastTextStore.LookupEntry(TEXT_MONKEY_WISDOM_3) &&
               sBroadcastTextStore.LookupEntry(TEXT_MONKEY_WISDOM_4) &&
               sBroadcastTextStore.LookupEntry(TEXT_MONKEY_WISDOM_5) &&
               sBroadcastTextStore.LookupEntry(TEXT_MONKEY_WISDOM_6) &&
               sBroadcastTextStore.LookupEntry(TEXT_MONKEY_WISDOM_7) &&
               sBroadcastTextStore.LookupEntry(TEXT_MONKEY_WISDOM_8);
    }

    bool Load() override
    {
        // Дословно из DekkCore 10.1: реплики голосуют только от имени игрока;
        // у не-игрового кастера GetHitPlayer() был бы пустым.
        return GetCaster()->IsPlayer();
    }

    void HandleScript(SpellEffIndex /*effIndex*/)
    {
        GetCaster()->Talk(TEXT_MONKEY_WISDOM_1 + urand(0, 7), CHAT_MSG_RAID_BOSS_WHISPER, 0.0f, GetHitPlayer());
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_monkey_wisdom_text::HandleScript, EFFECT_0, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

void AddSC_spell_monkey_wisdom_text()
{
    RegisterSpellScript(spell_monkey_wisdom_text);
}
