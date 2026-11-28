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

// Перенесено из DekkCore/Legion/WorldBosses/boss_the_soultakers.cpp.
// Исправления порта:
// - удалён не-Blizzlike блок DamageTaken (передача урона между боссами отсутствует в Wowpedia;
//   в источнике он к тому же пытался убить attacker);
// - target->ToPlayer()->IsAlive() заменено на проверку через ToUnit() (цель — Creature);
// - Restore/энергия: счётчик увеличивается один раз за тик, событие 10 только проверяет 100;
// - три рывка Reaver Jdorn реализованы событием вместо закомментированных AddDelayedEvent;
// - DoMeleeAttackIfReady() вызван через me->.

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "Player.h"

enum SoultakerSpells
{
    SPELL_TENTACLE_BASH         = 213420,
    SPELL_SHATTER_CREWMEN       = 213532,
    SPELL_CURSED_CREW           = 213522,
    SPELL_MARAUDING_MISTS       = 213665,
    SPELL_SEADOG_SCUTTLE_COST   = 213580,
    SPELL_SEADOG_SCUTTLE        = 213584,
    SPELL_SEADOG_SCUTTLE_TRIG   = 213588,
    SPELL_TELEPORT              = 215681,
    SPELL_EXPEL_SOUL            = 213625,
    SPELL_SOUL_REND             = 213605,
    SPELL_SOUL_REND_TRIG        = 213638,
    SPELL_RIFT_ERUPTION         = 213648,
    SPELL_SHATTER_CREWMEN_ADD   = 213533
};

enum SoultakerNPCs
{
    NPC_CAPTAIN_HRING   = 106981,
    NPC_REAVER_JDORN    = 106982,
    NPC_SOULTRAPPER_MEVRA = 106984,
    NPC_CURSED_CREWMAN  = 107569
};

uint32 const soultakerBosses[3] =
{
    NPC_CAPTAIN_HRING,
    NPC_REAVER_JDORN,
    NPC_SOULTRAPPER_MEVRA
};

Position const mevraTeleportPos[6] =
{
    { 4930.69f, 489.92f, -53.34f, 2.71f },
    { 4904.75f, 471.04f, -53.34f, 2.21f },
    { 4863.42f, 449.40f, -53.34f, 1.36f },
    { 4840.75f, 476.77f, -53.34f, 0.60f },
    { 4820.06f, 510.35f, -53.34f, 0.11f },
    { 4878.81f, 524.31f, -48.90f, 4.52f }
};

enum SoultakerEvents
{
    EVENT_TENTACLE_OR_MISTS     = 1,
    EVENT_SHATTER_CREWMEN       = 2,
    EVENT_TELEPORT_AND_EXPEL    = 3,
    EVENT_ENERGY_CHECK          = 10,
    EVENT_SEADOG_CHARGE         = 11
};

// 106981, 106982, 106984
class boss_soultakers : public CreatureScript
{
public:
    boss_soultakers() : CreatureScript("boss_soultakers") { }

    struct boss_soultakersAI : ScriptedAI
    {
        boss_soultakersAI(Creature* creature) : ScriptedAI(creature), energyTimer(1000), chargeCount(0) { }

        EventMap events;
        uint32 energyTimer;
        uint8 chargeCount;

        void Reset() override
        {
            events.Reset();
            energyTimer = 1000;
            chargeCount = 0;
            me->SetPower(POWER_ENERGY, 0);
            me->SetReactState(REACT_AGGRESSIVE);
        }

        void JustEngagedWith(Unit* unit) override
        {
            if (!unit)
                return;

            if (me->GetEntry() == NPC_CAPTAIN_HRING || me->GetEntry() == NPC_REAVER_JDORN)
                events.ScheduleEvent(EVENT_TENTACLE_OR_MISTS, 16s);
            if (me->GetEntry() == NPC_SOULTRAPPER_MEVRA)
                events.ScheduleEvent(EVENT_TELEPORT_AND_EXPEL, 1s);

            events.ScheduleEvent(EVENT_ENERGY_CHECK, 1s);

            for (uint32 entry : soultakerBosses)
            {
                if (me->GetEntry() == entry)
                    continue;

                if (Creature* ally = me->FindNearestCreature(entry, 100.0f))
                {
                    if (ally->IsAlive())
                        ally->AI()->AttackStart(unit);
                    else
                        ally->Respawn(false);
                }
            }
        }

        void SpellHitTarget(WorldObject* target, SpellInfo const* spellInfo) override
        {
            if (!target)
                return;

            if (me->GetEntry() == NPC_CAPTAIN_HRING && spellInfo->Id == SPELL_SHATTER_CREWMEN)
            {
                if (Unit* unit = target->ToUnit())
                {
                    if (unit->GetTypeId() == TYPEID_UNIT && unit->ToCreature()->GetEntry() == NPC_CURSED_CREWMAN && unit->IsAlive())
                    {
                        unit->CastSpell(unit, SPELL_SHATTER_CREWMEN_ADD);
                        unit->ToCreature()->DespawnOrUnsummon(500ms);
                    }
                }
            }

            if (me->GetEntry() == NPC_SOULTRAPPER_MEVRA && spellInfo->Id == SPELL_SOUL_REND_TRIG)
                me->CastSpell(target, SPELL_RIFT_ERUPTION, true);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (energyTimer <= diff)
            {
                if (me->GetPower(POWER_ENERGY) < 100)
                    me->SetPower(POWER_ENERGY, me->GetPower(POWER_ENERGY) + 1);
                energyTimer = urand(1000, 1300);
            }
            else
                energyTimer -= diff;

            events.Update(diff);

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_TENTACLE_OR_MISTS:
                    if (me->GetEntry() == NPC_CAPTAIN_HRING)
                        DoCast(SPELL_TENTACLE_BASH);
                    else
                        DoCast(SPELL_MARAUDING_MISTS);
                    events.ScheduleEvent(EVENT_TENTACLE_OR_MISTS, 17s);
                    break;
                case EVENT_SHATTER_CREWMEN:
                    DoCast(SPELL_SHATTER_CREWMEN);
                    break;
                case EVENT_TELEPORT_AND_EXPEL:
                {
                    me->CastSpell(mevraTeleportPos[urand(0, 5)], SPELL_TELEPORT);
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, 70.0f, true))
                        me->CastSpell(target, SPELL_EXPEL_SOUL);
                    events.ScheduleEvent(EVENT_TELEPORT_AND_EXPEL, 8s);
                    break;
                }
                case EVENT_ENERGY_CHECK:
                    if (me->GetPower(POWER_ENERGY) >= 100)
                    {
                        switch (me->GetEntry())
                        {
                        case NPC_CAPTAIN_HRING:
                            DoCast(SPELL_CURSED_CREW);
                            events.ScheduleEvent(EVENT_SHATTER_CREWMEN, 4s);
                            break;
                        case NPC_REAVER_JDORN:
                            chargeCount = 3;
                            me->SetReactState(REACT_PASSIVE);
                            DoCast(SPELL_SEADOG_SCUTTLE_COST);
                            events.ScheduleEvent(EVENT_SEADOG_CHARGE, 1s);
                            break;
                        case NPC_SOULTRAPPER_MEVRA:
                            DoCast(SPELL_SOUL_REND);
                            break;
                        default:
                            break;
                        }
                        me->SetPower(POWER_ENERGY, 0);
                    }
                    events.ScheduleEvent(EVENT_ENERGY_CHECK, 11s);
                    break;
                case EVENT_SEADOG_CHARGE:
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, 70.0f, true))
                    {
                        me->CastSpell(target, SPELL_SEADOG_SCUTTLE);
                        me->CastSpell(target, SPELL_SEADOG_SCUTTLE_TRIG);
                    }
                    if (--chargeCount > 0)
                        events.ScheduleEvent(EVENT_SEADOG_CHARGE, 5s);
                    else
                        me->SetReactState(REACT_AGGRESSIVE);
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
        return new boss_soultakersAI(creature);
    }
};

void AddSC_boss_the_soultakers()
{
    new boss_soultakers();
}
