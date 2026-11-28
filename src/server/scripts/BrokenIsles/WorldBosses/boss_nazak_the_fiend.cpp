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

enum NazakSpells
{
    SPELL_CORRODING_SPRAY       = 219349,
    SPELL_WEB_WRAP              = 219861,
    SPELL_FOUNDATIONAL_COLLAPSE = 219591,
    SPELL_ABSORB_LEYSTONES      = 219813,
    SPELL_LEY_INFUSION          = 219836
};

enum NazakEvents
{
    EVENT_CORRODING_SPRAY = 1,
    EVENT_WEB_WRAP = 2,
    EVENT_FOUNDATIONAL_COLLAPSE = 3,
    EVENT_ABSORB_LEYSTONES = 4
};

// 110321
class boss_nazak_the_fiend : public CreatureScript
{
public:
    boss_nazak_the_fiend() : CreatureScript("boss_nazak_the_fiend") { }

    struct boss_nazak_the_fiendAI : public ScriptedAI
    {
        boss_nazak_the_fiendAI(Creature* creature) : ScriptedAI(creature), summons(me) { }

        EventMap events;
        SummonList summons;

        void Reset() override
        {
            events.Reset();
            summons.DespawnAll();
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.RescheduleEvent(EVENT_CORRODING_SPRAY, 23s);
            events.RescheduleEvent(EVENT_WEB_WRAP, 42s);
            events.RescheduleEvent(EVENT_FOUNDATIONAL_COLLAPSE, 57s);
        }

        void JustDied(Unit* /*killer*/) override
        {
            summons.DespawnAll();
        }

        void JustSummoned(Creature* summon) override
        {
            summons.Summon(summon);
        }

        void SpellHitTarget(WorldObject* /*target*/, SpellInfo const* spell) override
        {
            if (spell->Id != SPELL_ABSORB_LEYSTONES)
                return;

            std::list<Creature*> adds;
            GetCreatureListWithEntryInGrid(adds, me, 110417, 60.0f);
            for (Creature* add : adds)
            {
                if (!add->IsAlive())
                    continue;

                add->DespawnOrUnsummon(1s);
                DoCast(me, SPELL_LEY_INFUSION, true);
            }
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
                case EVENT_CORRODING_SPRAY:
                    DoCast(SPELL_CORRODING_SPRAY);
                    events.RescheduleEvent(EVENT_CORRODING_SPRAY, 23s);
                    break;
                case EVENT_WEB_WRAP:
                    DoCast(SPELL_WEB_WRAP);
                    events.RescheduleEvent(EVENT_WEB_WRAP, 42s);
                    break;
                case EVENT_FOUNDATIONAL_COLLAPSE:
                    DoCast(SPELL_FOUNDATIONAL_COLLAPSE);
                    events.RescheduleEvent(EVENT_FOUNDATIONAL_COLLAPSE, 57s);
                    events.RescheduleEvent(EVENT_ABSORB_LEYSTONES, 2s);
                    break;
                case EVENT_ABSORB_LEYSTONES:
                    DoCast(SPELL_ABSORB_LEYSTONES);
                    break;
                }
            }

            me->DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_nazak_the_fiendAI(creature);
    }
};

void AddSC_boss_nazak_the_fiend()
{
    new boss_nazak_the_fiend();
}
