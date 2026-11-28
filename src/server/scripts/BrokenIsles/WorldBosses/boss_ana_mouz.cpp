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

enum AnaMouzSpells
{
    SPELL_FEL_GEYZER       = 218823,
    SPELL_IMPISH_FLAMES    = 218888,
    SPELL_GASEOUS_BREATH   = 219255,
    SPELL_MOTHERS_EMBRACE  = 219045,
    SPELL_REMOVE_CHARM     = 227351,
    SPELL_CHARM_TRIGGER    = 219068
};

enum AnaMouzEvents
{
    EVENT_FEL_GEYZER = 1,
    EVENT_IMPISH_FLAMES = 2,
    EVENT_GASEOUS_BREATH = 3,
    EVENT_MOTHERS_EMBRACE = 4
};

// 109943
class boss_ana_muz : public CreatureScript
{
public:
    boss_ana_muz() : CreatureScript("boss_ana_muz") { }

    struct boss_ana_muzAI : public ScriptedAI
    {
        boss_ana_muzAI(Creature* creature) : ScriptedAI(creature), summons(me)
        {
            me->SetUnitFlag(UNIT_FLAG_REMOVE_CLIENT_CONTROL);
        }

        EventMap events;
        SummonList summons;

        void Reset() override
        {
            events.Reset();
            summons.DespawnAll();
            DoCast(SPELL_REMOVE_CHARM);
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.RescheduleEvent(EVENT_FEL_GEYZER, 4s);
            events.RescheduleEvent(EVENT_GASEOUS_BREATH, 7s);
            events.RescheduleEvent(EVENT_MOTHERS_EMBRACE, 31s);
        }

        void JustDied(Unit* /*killer*/) override
        {
            summons.DespawnAll();
            DoCast(SPELL_REMOVE_CHARM);
        }

        void JustSummoned(Creature* summon) override
        {
            summons.Summon(summon);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            events.Update(diff);

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_FEL_GEYZER:
                    DoCast(SPELL_FEL_GEYZER);
                    events.RescheduleEvent(EVENT_FEL_GEYZER, 22s);
                    events.RescheduleEvent(EVENT_IMPISH_FLAMES, 3s);
                    break;
                case EVENT_IMPISH_FLAMES:
                    DoCast(SPELL_IMPISH_FLAMES);
                    break;
                case EVENT_GASEOUS_BREATH:
                    DoCast(SPELL_GASEOUS_BREATH);
                    events.RescheduleEvent(EVENT_GASEOUS_BREATH, 31s);
                    break;
                case EVENT_MOTHERS_EMBRACE:
                    DoCast(SPELL_MOTHERS_EMBRACE);
                    events.RescheduleEvent(EVENT_MOTHERS_EMBRACE, 65s);
                    break;
                }
            }

            me->DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_ana_muzAI(creature);
    }
};

// 219045
class spell_mothers_embrace : public SpellScriptLoader
{
public:
    spell_mothers_embrace() : SpellScriptLoader("spell_mothers_embrace") { }

    class spell_mothers_embrace_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_mothers_embrace_AuraScript);

        void OnRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
        {
            if (!GetCaster() || !GetTarget())
                return;

            if (GetCaster()->IsAlive() && GetTarget()->IsAlive())
                GetCaster()->CastSpell(GetTarget(), SPELL_CHARM_TRIGGER, true);
        }

        void Register() override
        {
            OnEffectRemove += AuraEffectRemoveFn(spell_mothers_embrace_AuraScript::OnRemove, EFFECT_0, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
        }
    };

    AuraScript* GetAuraScript() const override
    {
        return new spell_mothers_embrace_AuraScript();
    }
};

void AddSC_boss_ana_mouz()
{
    new boss_ana_muz();
    new spell_mothers_embrace();
}
