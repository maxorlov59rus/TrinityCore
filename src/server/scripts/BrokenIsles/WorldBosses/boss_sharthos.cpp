/*
 * Copyright 2021
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

// Перенесено из DekkCore/Legion/WorldBosses/boss_sharthos.cpp.
// Исправления порта: список игроков очищается перед каждым Use (в источнике он накапливался),
// new (boss_sharthos) заменён на корректный new boss_sharthos(),
// DoMeleeAttackIfReady() вызван через me->, AT-хуки приведены к сигнатурам ядра,
// добавлены проверки на nullptr у caster.

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "AreaTrigger.h"
#include "AreaTriggerAI.h"
#include "Containers.h"
#include "ObjectAccessor.h"
#include "ObjectMgr.h"

enum Spells
{
    SPELL_NIGHTMARE_BREATH    = 215821,
    SPELL_TAIL_LASH           = 215806,
    SPELL_BURNING_EARTH_DOT   = 215876,
    SPELL_BURNING_EARTH_AT    = 215872,
    SPELL_DREAD_FLAME         = 216043,
    SPELL_CRY_OF_THE_TORMENTED = 216044
};

enum Events
{
    EVENT_TAIL_LASH          = 1,
    EVENT_NIGHTMARE_BREATH   = 2,
    EVENT_DREAD_FLAME        = 3,
    EVENT_BURNING_EARTH      = 4,
    EVENT_CRY_OF_THE_TORMENTED = 5
};

// 108678
class boss_sharthos : public CreatureScript
{
public:
    boss_sharthos() : CreatureScript("boss_sharthos") { }

    struct boss_sharthosAI : WorldBossAI
    {
        boss_sharthosAI(Creature* creature) : WorldBossAI(creature) { }

        void Reset() override
        {
            _Reset();
            me->SetFullHealth();
            me->GetMotionMaster()->MoveTargetedHome();
            events.Reset();
        }

        void JustEngagedWith(Unit* who) override
        {
            if (!who)
                return;

            me->setActive(true);
            me->SetFullHealth();
            DoZoneInCombat();

            events.ScheduleEvent(EVENT_TAIL_LASH, 8s);
            events.ScheduleEvent(EVENT_DREAD_FLAME, 11s);
            events.ScheduleEvent(EVENT_NIGHTMARE_BREATH, 16s);
            events.ScheduleEvent(EVENT_BURNING_EARTH, 28s);
            events.ScheduleEvent(EVENT_CRY_OF_THE_TORMENTED, 63s);
        }

        void EnterEvadeMode(EvadeReason /*why*/) override
        {
            _EnterEvadeMode();
            Reset();
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            events.Update(diff);

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_TAIL_LASH:
                    DoCastAOE(SPELL_TAIL_LASH);
                    events.ScheduleEvent(EVENT_TAIL_LASH, 8s);
                    break;
                case EVENT_DREAD_FLAME:
                    if (Unit* victim = me->GetVictim())
                        me->CastSpell(victim, SPELL_DREAD_FLAME);
                    events.ScheduleEvent(EVENT_DREAD_FLAME, 25s);
                    break;
                case EVENT_NIGHTMARE_BREATH:
                    DoCastAOE(SPELL_NIGHTMARE_BREATH);
                    events.ScheduleEvent(EVENT_NIGHTMARE_BREATH, 18s);
                    break;
                case EVENT_BURNING_EARTH:
                {
                    std::list<Player*> nearbyPlayers;
                    me->GetPlayerListInGrid(nearbyPlayers, 50.0f);
                    if (!nearbyPlayers.empty())
                        Trinity::Containers::RandomResize(nearbyPlayers, 1);

                    for (Player* target : nearbyPlayers)
                        me->CastSpell(target, SPELL_BURNING_EARTH_AT);

                    events.ScheduleEvent(EVENT_BURNING_EARTH, 28s);
                    break;
                }
                case EVENT_CRY_OF_THE_TORMENTED:
                    DoCastAOE(SPELL_CRY_OF_THE_TORMENTED);
                    events.ScheduleEvent(EVENT_CRY_OF_THE_TORMENTED, 63s);
                    break;
                default:
                    break;
                }
            }
            me->DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_sharthosAI(creature);
    }
};

// 215872 — AreaTrigger HOT; привязка добавляется только если ID есть вliving DB.
class at_sharthos_burning_earth : public AreaTriggerEntityScript
{
public:
    at_sharthos_burning_earth() : AreaTriggerEntityScript("at_sharthos_burning_earth") { }

    struct at_sharthos_burning_earthAI : AreaTriggerAI
    {
        at_sharthos_burning_earthAI(AreaTrigger* areatrigger) : AreaTriggerAI(areatrigger), checkTimer(1000) { }

        uint32 checkTimer;

        void OnUpdate(uint32 diff) override
        {
            Unit* caster = at->GetCaster();
            if (!caster)
                return;

            if (checkTimer <= diff)
            {
                float yards = at->GetTimeSinceCreated() / IN_MILLISECONDS * 1.1f;

                for (ObjectGuid guid : at->GetInsideUnits())
                {
                    if (Unit* target = ObjectAccessor::GetUnit(*caster, guid))
                    {
                        if (!target->IsPlayer())
                            continue;

                        if (target->GetDistance(at->GetPosition()) <= yards && !target->HasAura(SPELL_BURNING_EARTH_DOT))
                            caster->AddAura(SPELL_BURNING_EARTH_DOT, target);
                        else if (target->GetDistance(at->GetPosition()) > yards && target->HasAura(SPELL_BURNING_EARTH_DOT))
                            target->RemoveAurasDueToSpell(SPELL_BURNING_EARTH_DOT);
                    }
                }
                checkTimer = 1000;
            }
            else
                checkTimer -= diff;
        }

        void OnUnitExit(Unit* unit, AreaTriggerExitReason /*reason*/) override
        {
            if (unit && unit->IsPlayer() && unit->HasAura(SPELL_BURNING_EARTH_DOT))
                unit->RemoveAurasDueToSpell(SPELL_BURNING_EARTH_DOT);
        }
    };

    AreaTriggerAI* GetAI(AreaTrigger* areatrigger) const override
    {
        return new at_sharthos_burning_earthAI(areatrigger);
    }
};

void AddSC_boss_sharthos()
{
    new boss_sharthos();
    new at_sharthos_burning_earth();
}
