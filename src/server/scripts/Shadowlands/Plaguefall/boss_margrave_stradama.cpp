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
#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "plaguefall.h"

enum MargraveStradamaSpells
{
    SPELL_INFECTION_RAIN        = 322232,
    SPELL_PLAGUE_CRASH_MAIN_LAND = 322475
};

enum MargraveStradamaEvents
{
    EVENT_INFECTION_RAIN = 1,
    EVENT_PLAGUE_CRASH_END
};

enum MargraveStradamaMisc
{
    NPC_MALIGNANT_SPAWN    = 165430,
    NPC_TELEPORT_STALKER   = 137623,
    NPC_PLAGUE_DEVOTED     = 163857
};

// 164267 - Margrave Stradama
struct boss_margrave_stradama : public BossAI
{
    boss_margrave_stradama(Creature* creature) : BossAI(creature, DATA_MARGRAVE_STRADAMA), _hp66(false), _hp33(false) { }

    void Reset() override
    {
        BossAI::Reset();

        _hp66 = false;
        _hp33 = false;
        SetCombatMovement(false);
        me->SetPowerType(POWER_MANA);
        me->SetMaxPower(POWER_MANA, 100);
    }

    void JustEngagedWith(Unit* who) override
    {
        BossAI::JustEngagedWith(who);

        instance->SendEncounterUnit(ENCOUNTER_FRAME_ENGAGE, me, 1);
        instance->SetBossState(DATA_MARGRAVE_STRADAMA, IN_PROGRESS);

        me->SummonCreature(NPC_MALIGNANT_SPAWN, me->GetRandomNearPosition(15.0f), TEMPSUMMON_MANUAL_DESPAWN);
        events.ScheduleEvent(EVENT_INFECTION_RAIN, 15s);
    }

    void ExecuteEvent(uint32 eventId) override
    {
        switch (eventId)
        {
            case EVENT_INFECTION_RAIN:
                DoCastSelf(SPELL_INFECTION_RAIN, false);
                events.Repeat(25s, 30s);
                break;
            case EVENT_PLAGUE_CRASH_END:
                me->RemoveUnitFlag(UNIT_FLAG_UNINTERACTIBLE);
                me->SetReactState(REACT_AGGRESSIVE);
                me->SummonCreature(NPC_MALIGNANT_SPAWN, me->GetRandomNearPosition(15.0f), TEMPSUMMON_MANUAL_DESPAWN);
                events.ScheduleEvent(EVENT_INFECTION_RAIN, 15s);
                break;
            default:
                break;
        }
    }

    void DamageTaken(Unit* /*attacker*/, uint32& /*damage*/, DamageEffectType /*damageType*/, SpellInfo const* /*spellInfo*/) override
    {
        if ((!_hp66 && me->HealthBelowPct(66)) || (!_hp33 && me->HealthBelowPct(33)))
        {
            if (me->HealthBelowPct(33))
                _hp66 = _hp33 = true;
            else
                _hp66 = true;

            me->SetReactState(REACT_PASSIVE);
            events.Reset();
            me->SetUnitFlag(UNIT_FLAG_UNINTERACTIBLE);

            std::list<Creature*> teleportStalkers;
            me->GetCreatureListWithOptionsInGrid(teleportStalkers, 50.f, { .CreatureId = NPC_TELEPORT_STALKER });
            for (Creature* stalker : teleportStalkers)
                stalker->CastSpell(nullptr, SPELL_PLAGUE_CRASH_MAIN_LAND, false);

            for (uint8 i = 0; i < 4; ++i)
                me->SummonCreature(NPC_PLAGUE_DEVOTED, me->GetRandomNearPosition(25.0f), TEMPSUMMON_MANUAL_DESPAWN);

            events.ScheduleEvent(EVENT_PLAGUE_CRASH_END, 15s);
        }
    }

    void EnterEvadeMode(EvadeReason /*why*/) override
    {
        instance->SendEncounterUnit(ENCOUNTER_FRAME_DISENGAGE, me);
        instance->SetBossState(DATA_MARGRAVE_STRADAMA, FAIL);

        _EnterEvadeMode();
        _DespawnAtEvade();
    }

    void JustDied(Unit* /*killer*/) override
    {
        _JustDied();
        instance->SendEncounterUnit(ENCOUNTER_FRAME_DISENGAGE, me);
        instance->SetBossState(DATA_MARGRAVE_STRADAMA, DONE);
        me->RemoveAllAreaTriggers();
    }

private:
    bool _hp66;
    bool _hp33;
};

void AddSC_boss_margrave_stradama()
{
    RegisterPlaguefallCreatureAI(boss_margrave_stradama);
}
