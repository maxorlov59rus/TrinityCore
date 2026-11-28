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

// Перенесено из DekkCore/Legion/WorldBosses/boss_nithogg.cpp.
// Исправления порта: снятие phase по убыванию порогов вместо else-if (иначе всегда был 80%),
// убран несуществующий в ядре SetSummonerGUID, GetAttackableUnitListInRange заменён на GridNotifiers,
// сигнатуры AT-хуков приведены к ядру (Spell const*, AreaTriggerExitReason),
// неиспользуемый spell_nithogg_crackling_jolt_damage (Register() пустой) не портируется.

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "AreaTrigger.h"
#include "AreaTriggerAI.h"
#include "CellImpl.h"
#include "GridNotifiers.h"
#include "GridNotifiersImpl.h"
#include "ObjectAccessor.h"
#include "ObjectMgr.h"
#include "PhasingHandler.h"
#include "SpellScript.h"
#include "TemporarySummon.h"

enum Spells
{
    SPELL_TAIL_LASH                     = 212836,
    SPELL_ELECTRICAL_STORM_AT           = 212885,
    SPELL_ELECTRICAL_STORM_DAMAGE       = 212884,
    SPELL_ELECTRICAL_STORM_VISUAL       = 198900,
    SPELL_ELECTRICAL_STORM_TARGET       = 212867,
    SPELL_STATIC_CHARGE_SUMMON          = 212889,
    SPELL_STATIC_CHARGE_TARGETED        = 212943,
    SPELL_STATIC_CHARGE_EXPLOSION       = 212948,
    SPELL_STATIC_CHARGE                 = 212887,
    SPELL_CRACKLING_JOLT_TARGET_PICKER  = 212837,
    SPELL_CRACKLING_JOLT_MISSILE        = 212838,
    SPELL_STORM_BREATH                  = 212852
};

enum NPCs
{
    NPC_STATIC_ORB          = 107353,
    NPC_ELECTRICAL_STORM    = 107338
};

enum Phases
{
    PHASE_NORMAL = 0,
    PHASE_80PCT  = 1,
    PHASE_60PCT  = 2,
    PHASE_40PCT  = 3,
    PHASE_20PCT  = 4
};

enum Events
{
    EVENT_CRACKLING_JOLT    = 1,
    EVENT_TAIL_LASH         = 2,
    EVENT_ELECTRICAL_STORM  = 3,
    EVENT_STATIC_CHARGE     = 4,
    EVENT_STORM_BREATH      = 5
};

// 107544
class boss_nithogg : public CreatureScript
{
public:
    boss_nithogg() : CreatureScript("boss_nithogg") { }

    struct boss_nithoggAI : WorldBossAI
    {
        boss_nithoggAI(Creature* creature) : WorldBossAI(creature), phase(0) { }

        uint8 phase;

        void Reset() override
        {
            _Reset();
            me->SetFullHealth();
            me->GetMotionMaster()->MoveTargetedHome();
            phase = 0;
            events.SetPhase(PHASE_NORMAL);
            events.Reset();
        }

        void JustEngagedWith(Unit* who) override
        {
            if (!who)
                return;

            me->setActive(true);
            DoZoneInCombat();
            events.Reset();
            events.SetPhase(PHASE_NORMAL);
            events.ScheduleEvent(EVENT_TAIL_LASH,        7s);
            events.ScheduleEvent(EVENT_CRACKLING_JOLT,   12s);
            events.ScheduleEvent(EVENT_ELECTRICAL_STORM, 20s);
            events.ScheduleEvent(EVENT_STATIC_CHARGE,    15s);
            events.ScheduleEvent(EVENT_STORM_BREATH,     7s);
            me->SetFullHealth();
        }

        void EnterEvadeMode(EvadeReason /*why*/) override
        {
            Reset();
        }

        void DamageTaken(Unit* /*attacker*/, uint32& damage, DamageEffectType /*damageType*/, SpellInfo const* /*spellInfo*/) override
        {
            uint8 newPhase = 0;
            if (me->HealthBelowPctDamaged(80, damage))
                newPhase = PHASE_80PCT;
            if (me->HealthBelowPctDamaged(60, damage))
                newPhase = PHASE_60PCT;
            if (me->HealthBelowPctDamaged(40, damage))
                newPhase = PHASE_40PCT;
            if (me->HealthBelowPctDamaged(20, damage))
                newPhase = PHASE_20PCT;

            if (newPhase <= phase)
                return;

            phase = newPhase;
            events.SetPhase(newPhase);
            if (newPhase >= PHASE_60PCT)
                DoCast(me, SPELL_CRACKLING_JOLT_TARGET_PICKER);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            if (me->IsInCombat() && events.Empty())
            {
                events.ScheduleEvent(EVENT_TAIL_LASH,        7s);
                events.ScheduleEvent(EVENT_CRACKLING_JOLT,   12s);
                events.ScheduleEvent(EVENT_ELECTRICAL_STORM, 20s);
                events.ScheduleEvent(EVENT_STATIC_CHARGE,    15s);
                events.ScheduleEvent(EVENT_STORM_BREATH,     7s);
            }

            events.Update(diff);

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_TAIL_LASH:
                    DoCastAOE(SPELL_TAIL_LASH);
                    events.ScheduleEvent(EVENT_TAIL_LASH, 8s);
                    break;
                case EVENT_CRACKLING_JOLT:
                    if (TempSummon* trigger = me->SummonCreature(WORLD_TRIGGER, me->GetPositionX(), me->GetPositionY(),
                        me->GetPositionZ() + 14.0f, 0.0f, TEMPSUMMON_TIMED_DESPAWN, 10s))
                    {
                        trigger->SetFaction(me->GetFaction());
                        PhasingHandler::InheritPhaseShift(trigger, me);
                        trigger->SetLevel(me->GetLevel());
                        trigger->SetName(me->GetName());
                        trigger->CastSpell(trigger, SPELL_CRACKLING_JOLT_TARGET_PICKER, true);
                    }
                    events.ScheduleEvent(EVENT_CRACKLING_JOLT, 15s);
                    break;
                case EVENT_ELECTRICAL_STORM:
                    DoCastAOE(SPELL_ELECTRICAL_STORM_TARGET);
                    events.ScheduleEvent(EVENT_ELECTRICAL_STORM, 30s);
                    break;
                case EVENT_STORM_BREATH:
                    DoCastVictim(SPELL_STORM_BREATH);
                    events.ScheduleEvent(EVENT_STORM_BREATH, 23s);
                    break;
                case EVENT_STATIC_CHARGE:
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, 0.0f, true))
                        DoCast(target, SPELL_STATIC_CHARGE);
                    events.ScheduleEvent(EVENT_STATIC_CHARGE, 40s);
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
        return new boss_nithoggAI(creature);
    }
};

// 212867
class spell_nithogg_electrical_storm_target : public SpellScriptLoader
{
public:
    spell_nithogg_electrical_storm_target() : SpellScriptLoader("spell_nithogg_electrical_storm_target") { }

    class spell_nithogg_electrical_storm_target_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_nithogg_electrical_storm_target_SpellScript);

        bool Validate(SpellInfo const* spellInfo) override
        {
            return ValidateSpellInfo({ uint32(spellInfo->GetEffect(EFFECT_0).BasePoints) });
        }

        void HandleHitTarget(SpellEffIndex effIndex)
        {
            if (Unit* target = GetHitUnit())
                if (Unit* caster = GetCaster())
                    caster->CastSpell(target, GetSpellInfo()->GetEffect(effIndex).BasePoints, true);
        }

        void Register() override
        {
            OnEffectHitTarget += SpellEffectFn(spell_nithogg_electrical_storm_target_SpellScript::HandleHitTarget, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_nithogg_electrical_storm_target_SpellScript();
    }
};

// 107338
class npc_nithogg_electrical_storm : public CreatureScript
{
public:
    npc_nithogg_electrical_storm() : CreatureScript("npc_nithogg_electrical_storm") { }

    struct npc_nithogg_electrical_stormAI : ScriptedAI
    {
        npc_nithogg_electrical_stormAI(Creature* creature) : ScriptedAI(creature), timer(0), tick(200) { }

        uint32 timer;
        uint32 tick;

        void Reset() override
        {
            me->CastSpell(me, SPELL_ELECTRICAL_STORM_AT, true);
        }

        void UpdateAI(uint32 diff) override
        {
            timer += diff;
            if (timer < tick)
                return;

            me->CastSpell(me, SPELL_ELECTRICAL_STORM_VISUAL, true);
            timer = 0;
            tick = urand(250, 550);
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_nithogg_electrical_stormAI(creature);
    }
};

// AreaTrigger 7053 отсутствует в текущих DB2 и в живой БД: скрипт зарегистрирован без привязки.
class at_nithogg_electrical_storm : public AreaTriggerEntityScript
{
public:
    at_nithogg_electrical_storm() : AreaTriggerEntityScript("at_nithogg_electrical_storm") { }

    struct at_nithogg_electrical_stormAI : AreaTriggerAI
    {
        at_nithogg_electrical_stormAI(AreaTrigger* areatrigger) : AreaTriggerAI(areatrigger), interval(0) { }

        int32 interval;

        void OnCreate(Spell const* /*creatingSpell*/) override
        {
            if (Unit* caster = at->GetCaster())
                caster->CastSpell(caster, SPELL_ELECTRICAL_STORM_DAMAGE, true);
        }

        void OnUpdate(uint32 diff) override
        {
            Unit* caster = at->GetCaster();
            if (!caster)
                return;

            interval += diff;
            if (interval < 2000)
                return;

            caster->RemoveAura(SPELL_ELECTRICAL_STORM_DAMAGE);
            caster->CastSpell(caster, SPELL_ELECTRICAL_STORM_DAMAGE, true);
            interval -= 2000;
        }

        void OnUnitExit(Unit* unit, AreaTriggerExitReason /*reason*/) override
        {
            if (unit && unit->HasAura(SPELL_ELECTRICAL_STORM_DAMAGE))
                unit->RemoveAura(SPELL_ELECTRICAL_STORM_DAMAGE);
        }

        void OnRemove() override
        {
            Unit* caster = at->GetCaster();
            if (!caster)
                return;

            for (ObjectGuid guid : at->GetInsideUnits())
                if (Unit* unit = ObjectAccessor::GetUnit(*caster, guid))
                    unit->RemoveAura(SPELL_ELECTRICAL_STORM_DAMAGE);
        }
    };

    AreaTriggerAI* GetAI(AreaTrigger* areatrigger) const override
    {
        return new at_nithogg_electrical_stormAI(areatrigger);
    }
};

// 212889
class spell_nithogg_static_charge_summon : public SpellScriptLoader
{
public:
    spell_nithogg_static_charge_summon() : SpellScriptLoader("spell_nithogg_static_charge_summon") { }

    class spell_nithogg_static_charge_summon_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_nithogg_static_charge_summon_SpellScript);

        void HandleHitTarget(SpellEffIndex /*effIndex*/)
        {
            Unit* caster = GetCaster();
            Unit* target = GetHitUnit();
            if (!caster || !target)
                return;

            if (Unit* summoned = caster->SummonCreature(NPC_STATIC_ORB, caster->GetPositionX(), caster->GetPositionY(),
                caster->GetPositionZ(), caster->GetOrientation(), TEMPSUMMON_TIMED_DESPAWN, 12s))
            {
                summoned->SetTarget(target->GetGUID());
                summoned->CastSpell(target, SPELL_STATIC_CHARGE_TARGETED, true);
                summoned->AddUnitState(UNIT_STATE_FOLLOW);
                summoned->GetMotionMaster()->MoveFollow(target, 0.0f, 0.0f);
            }
        }

        void Register() override
        {
            OnEffectHitTarget += SpellEffectFn(spell_nithogg_static_charge_summon_SpellScript::HandleHitTarget, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_nithogg_static_charge_summon_SpellScript();
    }
};

// 212837
class spell_nithogg_crackling_jolt_target : public SpellScriptLoader
{
public:
    spell_nithogg_crackling_jolt_target() : SpellScriptLoader("spell_nithogg_crackling_jolt_target") { }

    class spell_nithogg_crackling_jolt_target_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_nithogg_crackling_jolt_target_SpellScript);

        void HandleHitTarget(SpellEffIndex /*effIndex*/)
        {
            Unit* target = GetHitUnit();
            if (!target)
                return;

            if (Unit* caster = GetCaster())
                caster->CastSpell(target, SPELL_CRACKLING_JOLT_MISSILE, false);
        }

        void Register() override
        {
            OnEffectHitTarget += SpellEffectFn(spell_nithogg_crackling_jolt_target_SpellScript::HandleHitTarget, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_nithogg_crackling_jolt_target_SpellScript();
    }
};

// 107353
class npc_nithogg_static_orb : public CreatureScript
{
public:
    npc_nithogg_static_orb() : CreatureScript("npc_nithogg_static_orb") { }

    struct npc_nithogg_static_orbAI : ScriptedAI
    {
        npc_nithogg_static_orbAI(Creature* creature) : ScriptedAI(creature), timer(0) { }

        uint32 timer;

        void Reset() override
        {
            me->SetSpeedRate(MOVE_RUN, 0.7f);
            me->SetSpeedRate(MOVE_WALK, 0.7f);
            me->SetReactState(REACT_PASSIVE);
        }

        void UpdateAI(uint32 diff) override
        {
            timer += diff;
            if (timer < 300)
                return;

            timer = 0;
            Unit* unit = ObjectAccessor::GetUnit(*me, me->GetTarget());
            if (!unit || !me->IsInDist(unit, 4.0f))
                return;

            me->SetReactState(REACT_AGGRESSIVE);
            DoCastAOE(SPELL_STATIC_CHARGE_EXPLOSION);
            unit->RemoveAura(SPELL_STATIC_CHARGE_TARGETED);
            me->KillSelf();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_nithogg_static_orbAI(creature);
    }
};

// 212836
class spell_nithogg_tail_lash : public SpellScriptLoader
{
public:
    spell_nithogg_tail_lash() : SpellScriptLoader("spell_nithogg_tail_lash") { }

    class spell_nithogg_tail_lash_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_nithogg_tail_lash_SpellScript);

        void FilterTargets(std::list<WorldObject*>& targets)
        {
            Unit* caster = GetCaster();
            if (!caster)
                return;

            targets.clear();
            std::list<Unit*> units;
            float radius = 30.0f;
            Trinity::AnyUnfriendlyUnitInObjectRangeCheck check(caster, caster, radius);
            Trinity::UnitListSearcher<Trinity::AnyUnfriendlyUnitInObjectRangeCheck> searcher(caster, units, check);
            Cell::VisitAllObjects(caster, searcher, radius);

            for (Unit* unit : units)
                if (caster->IsValidAttackTarget(unit) && caster->isInBack(unit, float(M_PI) / 6))
                    targets.push_back(unit);
        }

        void Register() override
        {
            OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_nithogg_tail_lash_SpellScript::FilterTargets, EFFECT_0, TARGET_UNIT_CONE_ENEMY_24);
            OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_nithogg_tail_lash_SpellScript::FilterTargets, EFFECT_1, TARGET_UNIT_CONE_ENEMY_24);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_nithogg_tail_lash_SpellScript();
    }
};

void AddSC_boss_nithogg()
{
    new boss_nithogg();
    new npc_nithogg_electrical_storm();
    new npc_nithogg_static_orb();
    new at_nithogg_electrical_storm();
    new spell_nithogg_electrical_storm_target();
    new spell_nithogg_static_charge_summon();
    new spell_nithogg_crackling_jolt_target();
    new spell_nithogg_tail_lash();
}
