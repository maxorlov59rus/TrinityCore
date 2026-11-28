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

// Перенесено из DekkCore/Legion/WorldBosses/boss_levantus.cpp.
// Исправления порта: обход массива точек был i=1..6 при размере 6 (выход за границы);
// GetAttackableUnitListInRange заменён на штатный поиск через GridNotifiers;
// DoMeleeAttackIfReady() вызван через me->.

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "AreaTrigger.h"
#include "AreaTriggerAI.h"
#include "CellImpl.h"
#include "GridNotifiers.h"
#include "GridNotifiersImpl.h"
#include "ObjectAccessor.h"

Position const Waypointspawn[6] =
{
    { -1110.553f, 6949.951f, 0.0006f },
    { -1082.276f, 7001.35f,  0.0006f },
    { -1131.501f, 7029.581f, 0.0006f },
    { -1175.358f, 6998.841f, 0.0006f },
    { -1173.099f, 6950.416f, 0.0006f },
    { -1106.778f, 6947.764f, 0.0006f },
};

class boss_levantus : public CreatureScript
{
public:
    boss_levantus() : CreatureScript("boss_levantus") { }

    struct boss_levantusAI : ScriptedAI
    {
        boss_levantusAI(Creature* creature) : ScriptedAI(creature) { }

        EventMap events;

        void Reset() override
        {
            me->SetControlled(true, UNIT_STATE_ROOT);
            me->SetHealth(me->GetMaxHealth());
            me->GetMotionMaster()->MoveTargetedHome();
            events.Reset();
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.ScheduleEvent(1, 5s);
            events.ScheduleEvent(2, 8s);
            events.ScheduleEvent(4, 35s);
            events.ScheduleEvent(5, 15s);
            events.ScheduleEvent(6, 25s);
        }

        void EnterEvadeMode(EvadeReason /*why*/) override
        {
            me->SetControlled(false, UNIT_STATE_ROOT);
            me->GetMotionMaster()->MoveTargetedHome();
            Reset();
            _EnterEvadeMode();
        }

        void UpdateAI(uint32 diff) override
        {
            events.Update(diff);

            if (!UpdateVictim())
                return;

            if (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case 1:
                    for (uint8 i = 0; i < 6; ++i)
                        me->CastSpell(Position(Waypointspawn[i].GetPositionX() + urand(0, 25),
                            Waypointspawn[i].GetPositionY() + urand(0, 25), Waypointspawn[i].GetPositionZ()), 217212, true);
                    events.ScheduleEvent(1, 10s);
                    break;
                case 2:
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random))
                        me->CastSpell(target, 217361, true);
                    events.ScheduleEvent(2, 5s);
                    break;
                case 3:
                    if (Unit* target = SelectTarget(SelectTargetMethod::MaxDistance))
                        me->CastSpell(target, 217229, true);
                    break;
                case 4:
                    if (Unit* target = SelectTarget(SelectTargetMethod::MinDistance))
                    {
                        if (target->GetDistance(me) < 30.0f)
                            me->CastSpell(target, 217249, true);
                        else
                            events.ScheduleEvent(3, 1s);
                    }
                    events.ScheduleEvent(4, 60s);
                    break;
                case 5:
                    DoCast(217344);
                    events.ScheduleEvent(5, 30s);
                    break;
                case 6:
                    DoCast(217235);
                    events.ScheduleEvent(6, 30s);
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
        return new boss_levantusAI(creature);
    }
};

// 217212 создаёт AreaTrigger 22 (проверено по SpellEffect.db2 клиента 12.1.5).
class areatrigger_gen_gust_of_wind : public AreaTriggerEntityScript
{
public:
    areatrigger_gen_gust_of_wind() : AreaTriggerEntityScript("areatrigger_gen_gust_of_wind") { }

    struct areatrigger_gen_gust_of_windAI : AreaTriggerAI
    {
        areatrigger_gen_gust_of_windAI(AreaTrigger* areatrigger) : AreaTriggerAI(areatrigger), timer(0) { }

        void OnInitialize() override
        {
            timer = 500;
        }

        void OnUpdate(uint32 diff) override
        {
            Unit* caster = at->GetCaster();
            if (!caster)
                return;

            if (timer > diff)
            {
                timer -= diff;
                return;
            }

            std::list<Unit*> targetList;
            float radius = 5.0f;
            Trinity::AnyFriendlyUnitInObjectRangeCheck check(at, caster, radius);
            Trinity::UnitListSearcher<Trinity::AnyFriendlyUnitInObjectRangeCheck> searcher(at, targetList, check);
            Cell::VisitAllObjects(at, searcher, radius);

            for (Unit* target : targetList)
                if (!target->HasAura(217206))
                    target->CastSpell(target, 217206, true);

            timer = 500;
        }

    private:
        uint32 timer;
    };

    AreaTriggerAI* GetAI(AreaTrigger* areatrigger) const override
    {
        return new areatrigger_gen_gust_of_windAI(areatrigger);
    }
};

// AreaTrigger этих двух эффектов отсутствует в актуальных DB2 и в живой БД,
// поэтому скрипты зарегистрированы, но привязки не добавляются без подтверждённых ID.
class areatrigger_gen_electrify : public AreaTriggerEntityScript
{
public:
    areatrigger_gen_electrify() : AreaTriggerEntityScript("areatrigger_gen_electrify") { }

    struct areatrigger_gen_electrifyAI : AreaTriggerAI
    {
        areatrigger_gen_electrifyAI(AreaTrigger* areatrigger) : AreaTriggerAI(areatrigger), timer(0) { }

        void OnInitialize() override
        {
            timer = 2 * IN_MILLISECONDS;
        }

        void OnUpdate(uint32 diff) override
        {
            Unit* caster = at->GetCaster();
            if (!caster)
                return;

            if (timer > diff)
            {
                timer -= diff;
                return;
            }

            std::list<Unit*> targetList;
            float radius = 100.0f;
            Trinity::AnyUnfriendlyUnitInObjectRangeCheck check(at, caster, radius);
            Trinity::UnitListSearcher<Trinity::AnyUnfriendlyUnitInObjectRangeCheck> searcher(at, targetList, check);
            Cell::VisitAllObjects(at, searcher, radius);

            for (Unit* target : targetList)
                if (!target->HasAura(217352) && target->IsInWater())
                    target->CastSpell(target, 217352, true);

            at->Remove();
        }

    private:
        uint32 timer;
    };

    AreaTriggerAI* GetAI(AreaTrigger* areatrigger) const override
    {
        return new areatrigger_gen_electrifyAI(areatrigger);
    }
};

class areatrigger_gen_massive_spout : public AreaTriggerEntityScript
{
public:
    areatrigger_gen_massive_spout() : AreaTriggerEntityScript("areatrigger_gen_massive_spout") { }

    struct areatrigger_gen_massive_spoutAI : AreaTriggerAI
    {
        areatrigger_gen_massive_spoutAI(AreaTrigger* areatrigger) : AreaTriggerAI(areatrigger), timer(0) { }

        void OnInitialize() override
        {
            timer = 2 * IN_MILLISECONDS;
        }

        void OnUpdate(uint32 diff) override
        {
            Unit* caster = at->GetCaster();
            if (!caster)
                return;

            if (timer > diff)
            {
                timer -= diff;
                return;
            }

            std::list<Unit*> targetList;
            float radius = 200.0f;
            Trinity::AnyUnfriendlyUnitInObjectRangeCheck check(at, caster, radius);
            Trinity::UnitListSearcher<Trinity::AnyUnfriendlyUnitInObjectRangeCheck> searcher(at, targetList, check);
            Cell::VisitAllObjects(at, searcher, radius);

            for (Unit* target : targetList)
                if (caster->isInFront(target))
                    caster->CastSpell(target, 217277, true);

            timer = 2 * IN_MILLISECONDS;
        }

    private:
        uint32 timer;
    };

    AreaTriggerAI* GetAI(AreaTrigger* areatrigger) const override
    {
        return new areatrigger_gen_massive_spoutAI(areatrigger);
    }
};

void AddSC_boss_levantus()
{
    new boss_levantus();
    new areatrigger_gen_gust_of_wind();
    new areatrigger_gen_electrify();
    new areatrigger_gen_massive_spout();
}
