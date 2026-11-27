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

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "SpellInfo.h"

enum KraulokSpells
{
    SPELL_SHAKE_LOSE          = 276046,
    SPELL_PRIMAL_RAGE         = 275200,
    SPELL_SONIC_BELLOW        = 275175,
    SPELL_SHAKE_LOSE_DMG      = 276055,
    SPELL_SHAKE_LOSE_SUMMON   = 276053,
    SPELL_SONIC_BELLOW_VISUAL = 275177
};

enum KraulokEvents
{
    EVENT_SHAKE_LOSE = 1,
    EVENT_PRIMAL_RAGE,
    EVENT_SONIC_BELLOW
};

// 138794 - Dunegorger Kraulok
struct boss_dunegorger_kraulok : public WorldBossAI
{
    boss_dunegorger_kraulok(Creature* creature) : WorldBossAI(creature) { }

    void Reset() override
    {
        WorldBossAI::Reset();
    }

    void JustEngagedWith(Unit* who) override
    {
        WorldBossAI::JustEngagedWith(who);

        events.ScheduleEvent(EVENT_SONIC_BELLOW, 9s);
        events.ScheduleEvent(EVENT_SHAKE_LOSE, 25s);
        events.ScheduleEvent(EVENT_PRIMAL_RAGE, 39s);
    }

    void SpellHitTarget(WorldObject* target, SpellInfo const* spell) override
    {
        if (spell->Id == SPELL_SHAKE_LOSE)
        {
            me->CastSpell(target, SPELL_SHAKE_LOSE_DMG);
            me->CastSpell(target, SPELL_SHAKE_LOSE_SUMMON);
        }
        else if (spell->Id == SPELL_SONIC_BELLOW)
            me->CastSpell(target, SPELL_SONIC_BELLOW_VISUAL);
    }

    void ExecuteEvent(uint32 eventId) override
    {
        switch (eventId)
        {
            case EVENT_SHAKE_LOSE:
                me->CastSpell(me, SPELL_SHAKE_LOSE);
                events.Repeat(me->HasAura(SPELL_PRIMAL_RAGE) ? 15s : 28s);
                break;

            case EVENT_PRIMAL_RAGE:
                me->CastSpell(me, SPELL_PRIMAL_RAGE);
                events.Repeat(33s);
                break;

            case EVENT_SONIC_BELLOW:
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, 50.0f, true))
                    me->CastSpell(target, SPELL_SONIC_BELLOW);
                events.Repeat(me->HasAura(SPELL_PRIMAL_RAGE) ? 20s : 30s);
                break;

            default:
                break;
        }
    }
};

void AddSC_boss_dunegorger_kraulok()
{
    RegisterCreatureAI(boss_dunegorger_kraulok);
}
