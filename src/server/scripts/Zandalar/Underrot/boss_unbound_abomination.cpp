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

#include "AreaTrigger.h"
#include "AreaTriggerAI.h"
#include "Creature.h"
#include "InstanceScript.h"
#include "MotionMaster.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "SpellAuraEffects.h"
#include "SpellAuras.h"
#include "SpellScript.h"
#include "underrot.h"

#include <cmath>

enum UnboundAbominationSpells
{
    // Unbound Abomination
    SPELL_BLOOD_BARRIER                     = 269185,
    SPELL_PUTRID_BLOOD_AURA                 = 269303,
    SPELL_VILE_EXPULSION                    = 269843,
    SPELL_VILE_EXPULSION_SPORE_DEATH_DAMAGE = 250950,
    SPELL_VILE_EXPULSION_AT_DAMAGE          = 269838,
    SPELL_VILE_EXPULSION_MISSILE_SPAWN      = 269813,
    SPELL_VILE_EXPULSION_SPAWN              = 269836,
    SPELL_ROTTING_SPORE_SPAWN               = 270104,
    SPELL_ROTTING_SPORE_FIXATE              = 270107,
    SPELL_ROTTING_SPORE_DAMAGE              = 270108,

    // Blood Visage
    SPELL_BLOOD_CLONE_COSMETIC              = 272663,
    SPELL_FATAL_LINK                        = 269692,

    // Titan Keeper Hezrel
    SPELL_SHADOW_VISUAL                     = 279551,
    SPELL_HOLY_CHANNEL                      = 279250,
    SPELL_OPEN_WEB_DOOR                     = 279271,
    SPELL_HOLY_BOLT                         = 269312,
    SPELL_CLEANSING_LIGHT                   = 269310,
    SPELL_PURGE_CORRUPTION                  = 269406,
    SPELL_PERMANENT_FEIGN_DEATH             = 29266
};

enum UnboundAbominationEvents
{
    EVENT_VILE_EXPULSION = 1
};

enum UnboundAbominationActions
{
    ACTION_BLOOD_VISAGE = 1
};

enum HezrelEvents
{
    EVENT_HOLY_BOLT = 1,
    EVENT_PURGE_CORRUPTION,
    EVENT_CLEANSING_LIGHT
};

enum HezrelTalks
{
    TALK_BREACH_DETECTED        = 0,
    TALK_MOTHER_NO_RESPONDING   = 1,
    TALK_PLANETARY_INFECTION    = 2,
    TALK_SPECIMEN_DETECTED      = 3,
    TALK_CLEANSING_LIGHT        = 4,
    TALK_PURGE_PROTOCOL_ENGAGED = 6,
    TALK_CONTAGION_DETECTED     = 7,
    TALK_DEATH                  = 8
};

enum HezrelMovement
{
    POINT_HEZREL_WAYPOINT   = 1,
    POINT_PURGE_CORRUPTION  = 2,

    PATH_NONE               = 0,
    PATH_FIRST              = 1,
    PATH_SECOND             = 2
};

// 133007 - Unbound Abomination
struct boss_unbound_abomination : public BossAI
{
    boss_unbound_abomination(Creature* creature) : BossAI(creature, DATA_UNBOUND_ABOMINATION) { }

    void Reset() override
    {
        _Reset();

        me->RemoveAurasDueToSpell(SPELL_PUTRID_BLOOD_AURA);
        me->CastSpell(me, SPELL_BLOOD_BARRIER, true);
        me->SetPowerType(POWER_ENERGY);
        me->SetPower(POWER_ENERGY, 0);

        if (Creature* hezrel = GetBossHezrel())
        {
            if (!hezrel->IsAlive())
                hezrel->Respawn(true);

            hezrel->AI()->SetData(DATA_UNBOUND_ABOMINATION, NOT_STARTED);
        }
    }

    void JustEngagedWith(Unit* who) override
    {
        BossAI::JustEngagedWith(who);

        me->CastSpell(me, SPELL_PUTRID_BLOOD_AURA, true);

        if (Creature* hezrel = GetBossHezrel())
            hezrel->AI()->SetData(DATA_UNBOUND_ABOMINATION, IN_PROGRESS);

        events.ScheduleEvent(EVENT_VILE_EXPULSION, 15s);
    }

    void ExecuteEvent(uint32 eventId) override
    {
        switch (eventId)
        {
            case EVENT_VILE_EXPULSION:
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                    me->CastSpell(target, SPELL_VILE_EXPULSION, false);

                events.Repeat(15s);
                break;
            default:
                break;
        }
    }

    void JustDied(Unit* /*killer*/) override
    {
        _JustDied();

        if (Creature* hezrel = GetBossHezrel())
            hezrel->AI()->SetData(DATA_UNBOUND_ABOMINATION, DONE);
    }

    void DoAction(int32 action) override
    {
        if (action != ACTION_BLOOD_VISAGE)
            return;

        Position centerPosition = { 1199.420044f, 1481.939941f, -181.505997f };
        Position summonPosition = me->GetRandomPoint(centerPosition, 40.f);

        me->SetPower(POWER_ENERGY, 0);
        me->SummonCreature(NPC_BLOOD_VISAGE, summonPosition, TEMPSUMMON_CORPSE_TIMED_DESPAWN, 2s);

        me->RemoveAurasDueToSpell(SPELL_BLOOD_BARRIER);
        me->CastSpell(me, SPELL_BLOOD_BARRIER, true);
    }

private:
    Creature* GetBossHezrel() const
    {
        return instance ? instance->GetCreature(DATA_BOSS_HERZEL) : nullptr;
    }
};

// 134419 - Titan Keeper Hezrel (event NPC at z > -100, encounter helper at z < -100)
struct npc_underrot_titan_keeper_hezrel : public ScriptedAI
{
    npc_underrot_titan_keeper_hezrel(Creature* creature) : ScriptedAI(creature), _event(creature->GetPositionZ() > -100.f) { }

    static constexpr Position FirstWaypoints[8] =
    {
        { 1034.255737f, 1169.260742f, 12.140393f },
        { 1034.920898f, 1164.862305f, 14.614284f },
        { 1042.535156f, 1145.444458f, 14.607360f },
        { 1063.567749f, 1144.828491f, 14.760351f },
        { 1077.910767f, 1157.091553f, 14.991093f },
        { 1077.984619f, 1160.333862f, 17.224142f },
        { 1077.937378f, 1188.073486f, 20.141348f },
        { 1075.895142f, 1226.188599f, 15.822451f }
    };

    static constexpr Position SecondWaypoints[3] =
    {
        { 1056.437012f, 1260.391968f, 11.439587f },
        { 1068.353882f, 1286.912842f,  9.131060f },
        { 1100.847412f, 1331.036255f,  5.608679f }
    };

    void Reset() override
    {
        events.Reset();
        _path = PATH_NONE;
        _waypointIndex = 0;

        if (_event)
            me->CastSpell(me, SPELL_SHADOW_VISUAL, true);
        else
            me->CastSpell(me, SPELL_HOLY_CHANNEL, true);
    }

    void SetData(uint32 type, uint32 action) override
    {
        if (type == DATA_EVENT_HERZEL)
        {
            if (!_event)
                return;

            if (action == 1)
            {
                Talk(TALK_BREACH_DETECTED);
                me->RemoveAurasDueToSpell(SPELL_SHADOW_VISUAL);
                me->SetAIAnimKitId(0);
                StartPath(PATH_FIRST);
            }
            else if (action == 2)
            {
                Talk(TALK_PLANETARY_INFECTION);
                StartPath(PATH_SECOND);
            }
        }
        else if (type == DATA_UNBOUND_ABOMINATION)
        {
            if (_event)
                return;

            switch (action)
            {
                case NOT_STARTED:
                case FAIL:
                    events.Reset();
                    me->GetMotionMaster()->MoveTargetedHome();
                    break;
                case IN_PROGRESS:
                    Talk(TALK_PURGE_PROTOCOL_ENGAGED);
                    events.ScheduleEvent(EVENT_HOLY_BOLT, 5s);
                    events.ScheduleEvent(EVENT_PURGE_CORRUPTION, 15s);
                    events.ScheduleEvent(EVENT_CLEANSING_LIGHT, 20s);
                    break;
                case DONE:
                    events.Reset();
                    Talk(TALK_DEATH);
                    me->CastSpell(me, SPELL_PERMANENT_FEIGN_DEATH, true);
                    break;
                default:
                    break;
            }
        }
    }

    void MovementInform(uint32 type, uint32 pointId) override
    {
        if (type != POINT_MOTION_TYPE)
            return;

        if (pointId == POINT_HEZREL_WAYPOINT)
        {
            AdvanceWaypoint();
            return;
        }

        if (pointId == POINT_PURGE_CORRUPTION)
        {
            if (Creature* bloodVisage = me->FindNearestCreature(NPC_BLOOD_VISAGE, 25.f, true))
                me->CastSpell(bloodVisage, SPELL_PURGE_CORRUPTION, true);
        }
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_event && !UpdateVictim())
            return;

        events.Update(diff);

        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        switch (events.ExecuteEvent())
        {
            case EVENT_HOLY_BOLT:
                me->CastSpell(nullptr, SPELL_HOLY_BOLT, false);
                events.Repeat(5s);
                break;
            case EVENT_PURGE_CORRUPTION:
            {
                if (Creature* bloodVisage = me->FindNearestCreature(NPC_BLOOD_VISAGE, 25.f, true))
                {
                    if (me->GetDistance(bloodVisage) < 10.f)
                    {
                        Talk(TALK_CONTAGION_DETECTED);
                        me->CastSpell(bloodVisage, SPELL_PURGE_CORRUPTION, true);
                        events.Repeat(15s);
                    }
                    else
                    {
                        float x, y, z;
                        me->GetContactPoint(bloodVisage, x, y, z, 5.f);
                        me->GetMotionMaster()->MovePoint(POINT_PURGE_CORRUPTION, x, y, z);
                        events.Repeat(20s);
                    }
                }
                else
                    events.Repeat(5s);
                break;
            }
            case EVENT_CLEANSING_LIGHT:
            {
                InstanceScript* instance = me->GetInstanceScript();
                Creature* abomination = instance ? instance->GetCreature(DATA_UNBOUND_ABOMINATION) : nullptr;
                if (abomination && abomination->IsAIEnabled())
                {
                    if (Unit* player = abomination->AI()->SelectTarget(SelectTargetMethod::Random, 0, 0.f, true))
                    {
                        Talk(TALK_CLEANSING_LIGHT);
                        me->CastSpell(player, SPELL_CLEANSING_LIGHT, false);
                    }
                }

                events.Repeat(20s);
                break;
            }
            default:
                break;
        }
    }

private:
    void StartPath(uint8 path)
    {
        _path = path;
        _waypointIndex = 0;
        AdvanceWaypoint();
    }

    void AdvanceWaypoint()
    {
        Position const* waypoints = nullptr;
        uint8 waypointCount = 0;

        switch (_path)
        {
            case PATH_FIRST:
                waypoints = FirstWaypoints;
                waypointCount = 8;
                break;
            case PATH_SECOND:
                waypoints = SecondWaypoints;
                waypointCount = 3;
                break;
            default:
                break;
        }

        if (!waypoints || _waypointIndex >= waypointCount)
        {
            CompletePath();
            return;
        }

        me->GetMotionMaster()->MovePoint(POINT_HEZREL_WAYPOINT, waypoints[_waypointIndex]);
        ++_waypointIndex;
    }

    void CompletePath()
    {
        uint8 completedPath = _path;
        _path = PATH_NONE;
        _waypointIndex = 0;

        if (completedPath == PATH_FIRST)
            Talk(TALK_MOTHER_NO_RESPONDING);
        else if (completedPath == PATH_SECOND)
        {
            Talk(TALK_SPECIMEN_DETECTED);
            me->CastSpell(nullptr, SPELL_OPEN_WEB_DOOR, false);
        }
    }

    bool _event;
    uint8 _path;
    uint8 _waypointIndex;
    EventMap events;
};

// 137103 - Blood Visage
struct npc_underrot_blood_visage : public ScriptedAI
{
    npc_underrot_blood_visage(Creature* creature) : ScriptedAI(creature) { }

    void Reset() override
    {
        DoZoneInCombat();
        me->CastSpell(me, SPELL_BLOOD_CLONE_COSMETIC, true);
    }

    void JustDied(Unit* /*killer*/) override
    {
        me->CastSpell(me, SPELL_FATAL_LINK, true);
    }
};

// 137458 - Rotting Spore
struct npc_underrot_rotting_spore : public ScriptedAI
{
    npc_underrot_rotting_spore(Creature* creature) : ScriptedAI(creature) { }

    void Reset() override
    {
        _events.Reset();
        me->CastSpell(me, SPELL_ROTTING_SPORE_SPAWN, true);
        FixateNearPlayer();
        _events.ScheduleEvent(EVENT_SPORE_DAMAGE, 1s);
    }

    void UpdateAI(uint32 diff) override
    {
        _events.Update(diff);

        if (_events.ExecuteEvent() != EVENT_SPORE_DAMAGE)
            return;

        if (Player* player = me->SelectNearestPlayer(3.f))
        {
            me->CastSpell(player, SPELL_ROTTING_SPORE_DAMAGE, true);
            me->KillSelf();
        }
        else
            _events.Repeat(1s);

        if (me->GetMotionMaster()->GetCurrentMovementGeneratorType() == IDLE_MOTION_TYPE)
            FixateNearPlayer();
    }

    void JustDied(Unit* /*killer*/) override
    {
        me->CastSpell(nullptr, SPELL_VILE_EXPULSION_SPORE_DEATH_DAMAGE, true);

        if (InstanceScript* instance = me->GetInstanceScript())
            if (Creature* abomination = instance->GetCreature(DATA_UNBOUND_ABOMINATION))
                abomination->CastSpell(me->GetPosition(), SPELL_VILE_EXPULSION_SPAWN, true);
    }

private:
    enum RottingSporeEvents
    {
        EVENT_SPORE_DAMAGE = 1
    };

    void FixateNearPlayer()
    {
        if (Player* player = me->SelectNearestPlayer(50.f))
        {
            me->CastSpell(player, SPELL_ROTTING_SPORE_FIXATE, false);
            me->GetMotionMaster()->MoveChase(player);
        }
    }

    EventMap _events;
};

// 269185 - Blood Barrier
class aura_unbound_abomination_blood_barrier : public AuraScript
{
    PrepareAuraScript(aura_unbound_abomination_blood_barrier);

    void HandleAbsorb(AuraEffect* aurEff, DamageInfo& dmgInfo, uint32& absorbAmount)
    {
        if (dmgInfo.GetSpellInfo() && dmgInfo.GetSpellInfo()->Id == SPELL_FATAL_LINK)
        {
            absorbAmount = 0;
            return;
        }

        int32 absorbLeft = aurEff->GetAmount();
        int32 totalAbsorb = aurEff->CalculateAmount(GetTarget());

        if (!totalAbsorb)
            return;

        int32 energy = int32(std::ceil(float(totalAbsorb - absorbLeft) / float(totalAbsorb) * 100.f));
        GetTarget()->SetPower(POWER_ENERGY, energy);

        absorbAmount = dmgInfo.GetDamage();
    }

    void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (GetTargetApplication()->GetRemoveMode() == AURA_REMOVE_BY_DEATH)
            return;

        if (Creature* targetCreature = GetTarget()->ToCreature())
            if (targetCreature->IsAIEnabled())
                targetCreature->AI()->DoAction(ACTION_BLOOD_VISAGE);
    }

    void Register() override
    {
        OnEffectAbsorb += AuraEffectAbsorbFn(aura_unbound_abomination_blood_barrier::HandleAbsorb, EFFECT_0);
        AfterEffectRemove += AuraEffectRemoveFn(aura_unbound_abomination_blood_barrier::AfterRemove, EFFECT_0, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }
};

// 269843 - Vile Expulsion
class spell_underrot_vile_expulsion : public SpellScript
{
    PrepareSpellScript(spell_underrot_vile_expulsion);

    void HandleAfterCast()
    {
        for (uint8 i = 0; i < 5; ++i)
            GetCaster()->CastSpell(nullptr, SPELL_VILE_EXPULSION_MISSILE_SPAWN, true);
    }

    void Register() override
    {
        AfterCast += SpellCastFn(spell_underrot_vile_expulsion::HandleAfterCast);
    }
};

// 269310 - Cleansing Light
class spell_underrot_cleansing_light : public SpellScript
{
    PrepareSpellScript(spell_underrot_cleansing_light);

    void HandleDummy(SpellEffIndex /*effIndex*/)
    {
        WorldLocation* dest = GetHitDest();
        if (!dest)
            return;

        for (AreaTrigger* at : GetCaster()->GetAreaTriggers(SPELL_VILE_EXPULSION_SPAWN))
            if (at->GetDistance(*dest) < 10.f)
                at->SetDuration(0);
    }

    void Register() override
    {
        OnEffectHit += SpellEffectFn(spell_underrot_cleansing_light::HandleDummy, EFFECT_0, SPELL_EFFECT_REMOVE_AURA);
    }
};

// 279271 - Open Web Door
class aura_underrot_open_web_door : public AuraScript
{
    PrepareAuraScript(aura_underrot_open_web_door);

    void HandleEffectRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (InstanceScript* instance = GetTarget()->GetInstanceScript())
            instance->SetData(DATA_EVENT_HERZEL, DONE);
    }

    void Register() override
    {
        AfterEffectRemove += AuraEffectRemoveFn(aura_underrot_open_web_door::HandleEffectRemove, EFFECT_0, SPELL_AURA_PERIODIC_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }
};

// 269836 - Vile Expulsion (AreaTrigger 17928, when the matching create-properties row is present)
struct at_underrot_vile_expulsion : AreaTriggerAI
{
    at_underrot_vile_expulsion(AreaTrigger* areatrigger) : AreaTriggerAI(areatrigger) { }

    void OnInitialize() override
    {
        _periodicTimer = urand(20000, 40000);
    }

    void OnUpdate(uint32 diff) override
    {
        if (_periodicTimer > diff)
        {
            _periodicTimer -= diff;
            return;
        }

        _periodicTimer = 0;
        at->SetDuration(0);

        Unit* caster = at->GetCaster();
        if (caster && caster->GetMap()->IsHeroic())
            caster->SummonCreature(NPC_ROTTING_SPORE, at->GetPosition(), TEMPSUMMON_CORPSE_DESPAWN);
    }

    void OnUnitEnter(Unit* unit) override
    {
        Unit* caster = at->GetCaster();
        if (caster && caster->IsValidAttackTarget(unit))
            unit->CastSpell(unit, SPELL_VILE_EXPULSION_AT_DAMAGE, true);
    }

    void OnUnitExit(Unit* unit, AreaTriggerExitReason /*reason*/) override
    {
        unit->RemoveAurasDueToSpell(SPELL_VILE_EXPULSION_AT_DAMAGE);
    }

private:
    uint32 _periodicTimer = 0;
};

void AddSC_boss_unbound_abomination()
{
    RegisterUnderrotCreatureAI(boss_unbound_abomination);
    RegisterUnderrotCreatureAI(npc_underrot_titan_keeper_hezrel);
    RegisterUnderrotCreatureAI(npc_underrot_blood_visage);
    RegisterUnderrotCreatureAI(npc_underrot_rotting_spore);

    RegisterSpellScript(aura_unbound_abomination_blood_barrier);
    RegisterSpellScript(spell_underrot_vile_expulsion);
    RegisterSpellScript(spell_underrot_cleansing_light);
    RegisterSpellScript(aura_underrot_open_web_door);

    RegisterAreaTriggerAI(at_underrot_vile_expulsion);
}
