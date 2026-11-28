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

enum WitheredJimSpells
{
    SPELL_MORE_MORE_MORE      = 223715,
    SPELL_NIGHTSHIFTED_BOLTS  = 223623,
    SPELL_RESONANCE           = 223614,
    SPELL_NIGHTSTABLE_ENERGY  = 223689,
    SPELL_RESONANCE_TRIGGER   = 223616,
    SPELL_CLONE_BUFF          = 223723
};

enum WitheredJimEvents
{
    EVENT_NIGHTSHIFTED_BOLTS = 1,
    EVENT_RESONANCE = 2,
    EVENT_NIGHTSTABLE_ENERGY = 3,
    EVENT_MORE_MORE_MORE = 4,
    EVENT_SUMMON_CLONE = 5
};

// 102075
class boss_withered_jim : public CreatureScript
{
public:
    boss_withered_jim() : CreatureScript("boss_withered_jim") { }

    struct boss_withered_jimAI : public ScriptedAI
    {
        boss_withered_jimAI(Creature* creature) : ScriptedAI(creature), summons(me), cloneCount(0) { }

        EventMap events;
        SummonList summons;
        uint8 cloneCount;

        void Reset() override
        {
            events.Reset();
            summons.DespawnAll();
            cloneCount = 0;
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.RescheduleEvent(EVENT_NIGHTSHIFTED_BOLTS, 18s);
            events.RescheduleEvent(EVENT_RESONANCE, 24s);
            events.RescheduleEvent(EVENT_NIGHTSTABLE_ENERGY, 22s);

            if (me->GetEntry() == 102075)
                events.RescheduleEvent(EVENT_MORE_MORE_MORE, 30s);

            DoCast(223632); // Area trigger
            DoCast(223599);
        }

        void JustSummoned(Creature* summon) override
        {
            summons.Summon(summon);
            DoZoneInCombat();

            if (summon->GetEntry() == 112350)
                summon->CastSpell(summon, 223599);

            if (summon->GetEntry() == 112342)
                summon->DespawnOrUnsummon(9s);
        }

        void JustDied(Unit* /*killer*/) override
        {
            summons.DespawnAll();
        }

        void UpdateAI(uint32 diff) override
        {
            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            if (!UpdateVictim())
                return;

            events.Update(diff);

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_NIGHTSHIFTED_BOLTS:
                    DoCast(SPELL_NIGHTSHIFTED_BOLTS);
                    events.RescheduleEvent(EVENT_NIGHTSHIFTED_BOLTS, 30s);
                    break;
                case EVENT_RESONANCE:
                    DoCast(SPELL_RESONANCE);
                    events.RescheduleEvent(EVENT_RESONANCE, 30s);
                    break;
                case EVENT_NIGHTSTABLE_ENERGY:
                    DoCast(SPELL_NIGHTSTABLE_ENERGY);
                    events.RescheduleEvent(EVENT_NIGHTSTABLE_ENERGY, 34s);
                    break;
                case EVENT_MORE_MORE_MORE:
                    ++cloneCount;
                    DoCast(SPELL_MORE_MORE_MORE);
                    if (cloneCount < 5)
                        events.RescheduleEvent(EVENT_MORE_MORE_MORE, 30s);
                    events.RescheduleEvent(EVENT_SUMMON_CLONE, 1s);
                    break;
                case EVENT_SUMMON_CLONE:
                    if (me->HasAura(SPELL_MORE_MORE_MORE))
                        events.RescheduleEvent(EVENT_SUMMON_CLONE, 1s);
                    else if (Creature* clone = me->SummonCreature(112350, me->GetPositionX(), me->GetPositionY(), me->GetPositionZ(), me->GetOrientation()))
                        clone->CastSpell(clone, SPELL_CLONE_BUFF);
                    break;
                }
            }

            me->DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_withered_jimAI(creature);
    }
};

// 223614
class spell_resonance : public SpellScriptLoader
{
public:
    spell_resonance() : SpellScriptLoader("spell_resonance") { }

    class spell_resonance_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_resonance_AuraScript);

        void OnProc(AuraEffect* /*aurEff*/, ProcEventInfo& /*eventInfo*/)
        {
            PreventDefaultAction();

            if (Unit* target = GetTarget())
                target->CastSpell(target, SPELL_RESONANCE_TRIGGER, true);
        }

        void Register() override
        {
            OnEffectProc += AuraEffectProcFn(spell_resonance_AuraScript::OnProc, EFFECT_0, SPELL_AURA_MOD_DAMAGE_PERCENT_TAKEN);
        }
    };

    AuraScript* GetAuraScript() const override
    {
        return new spell_resonance_AuraScript();
    }
};

void AddSC_boss_withered_jim()
{
    new boss_withered_jim();
    new spell_resonance();
}
