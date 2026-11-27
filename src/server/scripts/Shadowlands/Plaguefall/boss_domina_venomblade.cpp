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

#include "Creature.h"
#include "InstanceScript.h"
#include "ObjectAccessor.h"
#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "plaguefall.h"

enum DominaVenombladeSpells
{
    SPELL_BROOD_ASSASSINS        = 332313,
    SPELL_SHADOW_AMBUSH_MARK     = 333353,
    SPELL_SHADOW_AMBUSH_DAMAGE   = 331818,
    SPELL_SHROUD_WEB_DECREASE_SPEED = 332397
};

enum DominaVenombladeEvents
{
    EVENT_BROOD_ASSASSINS = 1,
    EVENT_SHADOW_AMBUSH_MARK
};

enum DominaVenombladeMisc
{
    NPC_BROOD_ASSASSIN = 170474
};

// 164266 - Domina Venomblade
struct boss_domina_venomblade : public BossAI
{
    boss_domina_venomblade(Creature* creature) : BossAI(creature, DATA_DOMINA_VENOMBLADE) { }

    void JustEngagedWith(Unit* who) override
    {
        BossAI::JustEngagedWith(who);

        instance->SendEncounterUnit(ENCOUNTER_FRAME_ENGAGE, me, 1);
        instance->SetBossState(DATA_DOMINA_VENOMBLADE, IN_PROGRESS);

        events.ScheduleEvent(EVENT_BROOD_ASSASSINS, 1s);
        events.ScheduleEvent(EVENT_SHADOW_AMBUSH_MARK, 5s);
    }

    void JustSummoned(Creature* summon) override
    {
        BossAI::JustSummoned(summon);

        if (summon->GetEntry() == NPC_BROOD_ASSASSIN)
        {
            summon->SetFaction(14);
            summon->SetLevel(60);
            summon->AddAura(SPELL_SHROUD_WEB_DECREASE_SPEED, summon);
            SetCombatMovement(false);
        }
    }

    void ExecuteEvent(uint32 eventId) override
    {
        switch (eventId)
        {
            case EVENT_BROOD_ASSASSINS:
            {
                Position broodAssassinsPos = me->GetRandomNearPosition(urand(30, 40));
                for (uint8 i = 0; i < 4; ++i)
                    me->SummonCreature(NPC_BROOD_ASSASSIN, broodAssassinsPos, TEMPSUMMON_MANUAL_DESPAWN);

                events.Repeat(30s, 35s);
                break;
            }
            case EVENT_SHADOW_AMBUSH_MARK:
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, 100.0f, true))
                {
                    ObjectGuid targetGuid = target->GetGUID();
                    me->AddAura(SPELL_SHADOW_AMBUSH_MARK, target);

                    scheduler.Schedule(5100ms, [this, targetGuid](TaskContext const&)
                    {
                        Unit* target = ObjectAccessor::GetUnit(*me, targetGuid);
                        if (!target)
                            return;

                        Position targetPos = target->GetPosition();
                        me->NearTeleportTo(targetPos);
                        me->CastSpell(targetPos, SPELL_SHADOW_AMBUSH_DAMAGE, true);
                    });
                }
                events.Repeat(20s, 25s);
                break;
            default:
                break;
        }
    }

    void EnterEvadeMode(EvadeReason /*why*/) override
    {
        instance->SendEncounterUnit(ENCOUNTER_FRAME_DISENGAGE, me);
        instance->SetBossState(DATA_DOMINA_VENOMBLADE, FAIL);

        _EnterEvadeMode();
        _DespawnAtEvade();
    }

    void JustDied(Unit* /*killer*/) override
    {
        _JustDied();
        instance->SendEncounterUnit(ENCOUNTER_FRAME_DISENGAGE, me);
        instance->SetBossState(DATA_DOMINA_VENOMBLADE, DONE);
        me->RemoveAllAreaTriggers();
    }
};

void AddSC_boss_domina_venomblade()
{
    RegisterPlaguefallCreatureAI(boss_domina_venomblade);
}
