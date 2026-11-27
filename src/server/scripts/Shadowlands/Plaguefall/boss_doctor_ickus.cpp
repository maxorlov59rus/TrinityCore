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
#include "MotionMaster.h"
#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "SpellAuraEffects.h"
#include "SpellScript.h"
#include "plaguefall.h"

enum DoctorIckusSpells
{
    SPELL_SLIME_INJECTION       = 329110,
    SPELL_SLIME_INJECTION_SUMMON = 321320,
    SPELL_SLIME_LUNGE_CAST      = 329215,
    SPELL_SLIME_LUNGE_JUMP      = 329216,
    SPELL_SLIME_LUNGE_DAMAGE    = 329217
};

enum DoctorIckusEvents
{
    EVENT_SLIME_INJECTION = 1,
    EVENT_SLIME_LUNGE_CAST
};

// 164967 - Doctor Ickus
struct boss_doctor_ickus : public BossAI
{
    boss_doctor_ickus(Creature* creature) : BossAI(creature, DATA_DOCTOR_ICKUS) { }

    void JustEngagedWith(Unit* who) override
    {
        BossAI::JustEngagedWith(who);

        instance->SendEncounterUnit(ENCOUNTER_FRAME_ENGAGE, me, 1);
        instance->SetBossState(DATA_DOCTOR_ICKUS, IN_PROGRESS);

        events.ScheduleEvent(EVENT_SLIME_INJECTION, 5s);
        events.ScheduleEvent(EVENT_SLIME_LUNGE_CAST, 15s);
    }

    void ExecuteEvent(uint32 eventId) override
    {
        switch (eventId)
        {
            case EVENT_SLIME_INJECTION:
                DoCastVictim(SPELL_SLIME_INJECTION, false);
                events.Repeat(30s, 35s);
                break;
            case EVENT_SLIME_LUNGE_CAST:
                DoCastSelf(SPELL_SLIME_LUNGE_CAST, false);
                events.Repeat(20s, 25s);
                break;
            default:
                break;
        }
    }

    void OnSpellCast(SpellInfo const* spell) override
    {
        if (spell->Id != SPELL_SLIME_LUNGE_CAST)
            return;

        if (Unit* target = SelectTarget(SelectTargetMethod::MaxDistance, 0, 100.0f, true))
        {
            me->GetMotionMaster()->MoveJump(EVENT_JUMP, target->GetPosition(), 30.f, 30.f);
            me->CastSpell(target->GetPosition(), SPELL_SLIME_LUNGE_DAMAGE, false);
        }
    }

    void EnterEvadeMode(EvadeReason /*why*/) override
    {
        instance->SendEncounterUnit(ENCOUNTER_FRAME_DISENGAGE, me);
        instance->SetBossState(DATA_DOCTOR_ICKUS, FAIL);

        _EnterEvadeMode();
        _DespawnAtEvade();
    }

    void JustDied(Unit* /*killer*/) override
    {
        _JustDied();
        instance->SendEncounterUnit(ENCOUNTER_FRAME_DISENGAGE, me);
        instance->SetBossState(DATA_DOCTOR_ICKUS, DONE);
        me->RemoveAllAreaTriggers();
    }
};

// 329110 - Slime Injection
class aura_slime_injection : public AuraScript
{
    PrepareAuraScript(aura_slime_injection);

    void OnRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Aura* injection = GetTarget()->GetAura(SPELL_SLIME_INJECTION);
        if (!injection)
            return;

        if (GetCaster())
            GetCaster()->CastSpell(GetTarget()->GetPosition(), SPELL_SLIME_INJECTION_SUMMON, true);
    }

    void Register() override
    {
        OnEffectRemove += AuraEffectRemoveFn(aura_slime_injection::OnRemove, EFFECT_0, SPELL_AURA_PERIODIC_DAMAGE, AURA_EFFECT_HANDLE_REAL);
    }
};

void AddSC_boss_doctor_ickus()
{
    RegisterPlaguefallCreatureAI(boss_doctor_ickus);
    RegisterSpellScript(aura_slime_injection);
}
