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
#include "AreaTriggerAI.h"
#include "Containers.h"
#include "CreatureTextMgr.h"
#include "InstanceScript.h"
#include "MotionMaster.h"
#include "Player.h"
#include "ScriptedCreature.h"
#include "shrine_of_the_storm.h"
#include "SpellAuraEffects.h"

#include <algorithm>

enum VolzithSpells
{
    SPELL_VOID_ENERGY_DISABLE_REGEN             = 267255,
    SPELL_VOID_ENERGY_DO_REGEN                  = 267260,

    SPELL_YAWNING_GATE                          = 269399,
    SPELL_YAWNING_GATE_AURA                     = 269419,

    SPELL_TENTACLE_SLAM                         = 267364,
    SPELL_TENTACLE_SLAM_SUMMON                  = 267382,
    SPELL_TENTACLE_SLAM_DAMAGE                  = 267385,

    SPELL_WHISPERS_OF_POWER                     = 267034,
    SPELL_WHISPERS_OF_POWER_AURA                = 267037,
    SPELL_OLD_TONGUE                            = 274551,

    SPELL_GRASP_OF_THE_SUNKEN_CITY              = 267360,
    SPELL_GRASP_OF_THE_SUNKEN_CITY_CHANNEL      = 267444,
    SPELL_GRASP_OF_THE_SUNKEN_CITY_DPS_PHASE    = 278209,
    SPELL_GRASP_OF_THE_SUNKEN_CITY_TANK_PHASE   = 274556,

    SPELL_CALL_THE_ABYSS                        = 267299,
    SPELL_CALL_THE_ABYSS_SUMMON                 = 267306,

    SPELL_THE_SUNKEN_CITY                       = 267524,
    SPELL_CONSUME_ESSENCE                       = 267809,

    SPELL_LEVIATHANS_WAKE                       = 267548,

    SPELL_ABYSSAL_ERUPTION_DAMAGE               = 267310,
    SPELL_ABYSSAL_ERUPTION_ENERGIZE             = 267311
};

enum VolzithCreatures
{
    NPC_FORGOTTEN_DENIZEN           = 136297,
    NPC_SUNKEN_DENIZEN              = 136100,
    NPC_TENTACLE                    = 135987,
    NPC_MANIFESTATION_OF_THE_DEEP   = 135903
};

enum VolzithEvents
{
    EVENT_YAWNING_GATE = 1,
    EVENT_TENTACLE_SUMMON,
    EVENT_WHISPERS_OF_POWER,
    EVENT_ADD_POWER,
    EVENT_GRASP_OF_THE_SUNKEN_CITY,
    EVENT_CALL_THE_ABYSS,
    EVENT_TENTACLE_SLAM,
    EVENT_CONSUME_ESSENCE
};

enum VolzithActions
{
    ACTION_COUNT_DPS_PHASE      = 1,
    ACTION_COUNT_TANK_HEAL_PHASE
};

// creature_text groups: common-tongue line first, then the Old God tongue line.
enum VolzithTexts
{
    TEXT_INTRO_WHISPER  = 0,
    TEXT_INTRO_YELL     = 1,
    TEXT_AGGRO_WHISPER  = 2,
    TEXT_AGGRO_YELL     = 3,
    TEXT_ABYSS_WHISPER  = 4,
    TEXT_ABYSS_YELL     = 5,
    TEXT_DEATH_WHISPER  = 6,
    TEXT_DEATH_YELL     = 7,
    TEXT_KILL_WHISPER   = 8,
    TEXT_KILL_YELL      = 9,
    TEXT_GRASP_WHISPER  = 10,
    TEXT_GRASP_YELL     = 11
};

constexpr Position ForgottenDenizenSpawnPoints[3] =
{
    { 3658.58f, -1715.67f, 85.89f },
    { 3603.31f, -1742.71f, 85.82f },
    { 3619.73f, -1709.18f, 86.14f }
};

constexpr Position ManifestationSpawnPoints[15] =
{
    { 3675.83f, -1688.60f, 83.4349f },
    { 3656.23f, -1675.91f, 83.8259f },
    { 3636.15f, -1673.52f, 83.3167f },
    { 3621.70f, -1673.33f, 84.4263f },
    { 3611.91f, -1678.02f, 83.5110f },
    { 3593.11f, -1687.05f, 84.3794f },
    { 3575.16f, -1698.99f, 83.5286f },
    { 3570.94f, -1714.89f, 83.6414f },
    { 3570.48f, -1730.42f, 83.3317f },
    { 3576.01f, -1751.30f, 83.4642f },
    { 3581.68f, -1761.81f, 83.5611f },
    { 3594.58f, -1772.18f, 83.6898f },
    { 3610.53f, -1783.90f, 83.6852f },
    { 3624.24f, -1788.61f, 82.8457f },
    { 3635.22f, -1786.49f, 84.6600f }
};

static bool IsTankOrHealer(Player const* player)
{
    switch (player->GetPrimarySpecialization())
    {
        case ChrSpecialization::PriestDiscipline:
        case ChrSpecialization::PriestHoly:
        case ChrSpecialization::DruidRestoration:
        case ChrSpecialization::MonkMistweaver:
        case ChrSpecialization::ShamanRestoration:
        case ChrSpecialization::WarriorProtection:
        case ChrSpecialization::DeathKnightBlood:
        case ChrSpecialization::PaladinProtection:
        case ChrSpecialization::MonkBrewmaster:
        case ChrSpecialization::DemonHunterVengeance:
        case ChrSpecialization::DruidGuardian:
            return true;
        default:
            return false;
    }
}

static bool IsHealer(Player const* player)
{
    switch (player->GetPrimarySpecialization())
    {
        case ChrSpecialization::PriestDiscipline:
        case ChrSpecialization::PriestHoly:
        case ChrSpecialization::DruidRestoration:
        case ChrSpecialization::MonkMistweaver:
        case ChrSpecialization::ShamanRestoration:
            return true;
        default:
            return false;
    }
}

struct boss_volzith_the_whisperer : public BossAI
{
    boss_volzith_the_whisperer(Creature* creature) : BossAI(creature, DATA_VOLZITH_THE_WHISPERER)
    {
        me->RemoveUnitFlag2(UNIT_FLAG2_REGENERATE_POWER);
    }

    uint8 dpsAddsKilled = 0;
        uint8 tankHealAddsKilled = 0;
        bool introTextPlayed = false;

        void Reset() override
        {
            BossAI::Reset();

            instance->SendEncounterUnit(ENCOUNTER_FRAME_DISENGAGE, me);

            me->SetPowerType(POWER_ENERGY);
            me->SetMaxPower(POWER_ENERGY, 100);
            me->SetPower(POWER_ENERGY, 60);
            me->RemoveAllAreaTriggers();

            dpsAddsKilled = 0;
            tankHealAddsKilled = 0;
            introTextPlayed = false;

            DespawnAdds();
        }

        void DespawnAdds()
        {
            for (uint32 entry : { NPC_SUNKEN_DENIZEN, NPC_TENTACLE, NPC_FORGOTTEN_DENIZEN, NPC_MANIFESTATION_OF_THE_DEEP })
            {
                std::list<Creature*> creatures;
                me->GetCreatureListWithEntryInGrid(creatures, entry, 500.0f);
                for (Creature* creature : creatures)
                    creature->DespawnOrUnsummon();
            }
        }

        void MoveInLineOfSight(Unit* /*who*/) override
        {
            if (introTextPlayed)
                return;

            for (auto const& ref : me->GetMap()->GetPlayers())
            {
                Player* player = ref.GetSource();
                if (player && player->IsAlive() && player->IsWithinDist(me, 50.0f))
                {
                    Talk(TEXT_INTRO_WHISPER);
                    Talk(TEXT_INTRO_YELL);
                    introTextPlayed = true;
                    return;
                }
            }
        }

        void KilledUnit(Unit* /*victim*/) override
        {
            Talk(TEXT_KILL_WHISPER);
            Talk(TEXT_KILL_YELL);
        }

        void EnterEvadeMode(EvadeReason why) override
        {
            instance->SendEncounterUnit(ENCOUNTER_FRAME_DISENGAGE, me);
            DespawnAdds();
            me->RemoveAllAreaTriggers();

            me->SetPowerType(POWER_ENERGY);
            me->SetMaxPower(POWER_ENERGY, 100);
            me->SetPower(POWER_ENERGY, 60);
            me->CastStop();

            BossAI::EnterEvadeMode(why);
            _DespawnAtEvade(15s);
        }

        void JustSummoned(Creature* summon) override
        {
            BossAI::JustSummoned(summon);

            switch (summon->GetEntry())
            {
                case NPC_TENTACLE:
                case NPC_SUNKEN_DENIZEN:
                case NPC_FORGOTTEN_DENIZEN:
                    DoZoneInCombat(summon);
                    break;
                default:
                    break;
            }
        }

        void HandleSunkenPhase()
        {
            std::vector<Player*> tanksAndHealers;
            std::vector<Player*> damageDealers;

            for (auto const& ref : me->GetMap()->GetPlayers())
            {
                Player* player = ref.GetSource();
                if (!player || !player->IsAlive())
                    continue;

                if (IsTankOrHealer(player))
                    tanksAndHealers.push_back(player);
                else
                    damageDealers.push_back(player);
            }

            for (Player* player : tanksAndHealers)
                if (Aura* aura = player->AddAura(SPELL_GRASP_OF_THE_SUNKEN_CITY_TANK_PHASE, player))
                {
                    aura->SetMaxDuration(10 * MINUTE);
                    aura->SetDuration(10 * MINUTE);
                }

            for (Player* player : damageDealers)
                if (Aura* aura = player->AddAura(SPELL_GRASP_OF_THE_SUNKEN_CITY_DPS_PHASE, player))
                {
                    aura->SetMaxDuration(10 * MINUTE);
                    aura->SetDuration(10 * MINUTE);
                }
        }

        void DoAction(int32 action) override
        {
            switch (action)
            {
                case ACTION_COUNT_DPS_PHASE:
                    ++dpsAddsKilled;
                    break;
                case ACTION_COUNT_TANK_HEAL_PHASE:
                    ++tankHealAddsKilled;
                    break;
                default:
                    return;
            }

            if (dpsAddsKilled + tankHealAddsKilled >= 3)
                EndSunkenPhase();
        }

        void EndSunkenPhase()
        {
            for (auto const& ref : me->GetMap()->GetPlayers())
                if (Player* player = ref.GetSource())
                {
                    player->RemoveAurasDueToSpell(SPELL_GRASP_OF_THE_SUNKEN_CITY_DPS_PHASE);
                    player->RemoveAurasDueToSpell(SPELL_GRASP_OF_THE_SUNKEN_CITY_TANK_PHASE);
                }

            me->CastStop();
        }

        void CheckSunkenPhase()
        {
            if (!me->HasAura(SPELL_GRASP_OF_THE_SUNKEN_CITY_CHANNEL))
                return;

            bool anyPlayerAlive = false;
            for (auto const& ref : me->GetMap()->GetPlayers())
            {
                Player* player = ref.GetSource();
                if (player && player->IsAlive() &&
                    (player->HasAura(SPELL_GRASP_OF_THE_SUNKEN_CITY_DPS_PHASE) ||
                     player->HasAura(SPELL_GRASP_OF_THE_SUNKEN_CITY_TANK_PHASE)))
                {
                    anyPlayerAlive = true;
                    break;
                }
            }

            if (!anyPlayerAlive)
                EnterEvadeMode(EvadeReason::NoHostiles);
        }

        void CheckDpsRoom()
        {
            if (!me->HasAura(SPELL_GRASP_OF_THE_SUNKEN_CITY_CHANNEL))
                return;

            std::list<Creature*> dpsRoom;
            me->GetCreatureListWithEntryInGrid(dpsRoom, NPC_FORGOTTEN_DENIZEN, 500.0f);
            if (!dpsRoom.empty())
                return;

            for (auto const& ref : me->GetMap()->GetPlayers())
                if (Player* player = ref.GetSource())
                {
                    player->AddAura(SPELL_GRASP_OF_THE_SUNKEN_CITY_TANK_PHASE, player);
                    player->RemoveAurasDueToSpell(SPELL_GRASP_OF_THE_SUNKEN_CITY_DPS_PHASE);
                }
        }

        void DamageTaken(Unit* /*attacker*/, uint32& damage, DamageEffectType /*damageType*/, SpellInfo const* /*spellInfo*/) override
        {
            if (me->HasAura(SPELL_GRASP_OF_THE_SUNKEN_CITY_CHANNEL))
                damage = 0;
        }

        void JustDied(Unit* killer) override
        {
            BossAI::JustDied(killer);
            instance->SendEncounterUnit(ENCOUNTER_FRAME_DISENGAGE, me);
            DespawnAdds();
            me->RemoveAllAreaTriggers();
            Talk(TEXT_DEATH_WHISPER);
            Talk(TEXT_DEATH_YELL);
        }

        void JustEngagedWith(Unit* who) override
        {
            BossAI::JustEngagedWith(who);

            Talk(TEXT_AGGRO_WHISPER);
            Talk(TEXT_AGGRO_YELL);

            dpsAddsKilled = 0;
            tankHealAddsKilled = 0;

            instance->SendEncounterUnit(ENCOUNTER_FRAME_ENGAGE, me);

            events.ScheduleEvent(EVENT_ADD_POWER, 10s);
            events.ScheduleEvent(EVENT_YAWNING_GATE, 12s);
            events.ScheduleEvent(EVENT_TENTACLE_SUMMON, 8s);
            events.ScheduleEvent(EVENT_WHISPERS_OF_POWER, 18s);

            if (me->GetMap()->IsHeroic() || me->GetMap()->IsMythic())
                events.ScheduleEvent(EVENT_CALL_THE_ABYSS, 19s);
        }

        void SelectHealerOrOther()
        {
            Player* target = nullptr;

            for (auto const& ref : me->GetMap()->GetPlayers())
            {
                Player* player = ref.GetSource();
                if (!player || !player->IsAlive())
                    continue;

                if (IsHealer(player))
                {
                    target = player;
                    break;
                }
            }

            if (!target)
                for (auto const& ref : me->GetMap()->GetPlayers())
                {
                    Player* player = ref.GetSource();
                    if (player && player->IsAlive())
                    {
                        target = player;
                        break;
                    }
                }

            if (target)
                me->AddAura(SPELL_WHISPERS_OF_POWER_AURA, target);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            events.Update(diff);

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            if (me->IsInCombat())
                CheckSunkenPhase();

            CheckDpsRoom();

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                    case EVENT_ADD_POWER:
                    {
                        uint32 power = std::min<uint32>(100, me->GetPower(POWER_ENERGY) + urand(2, 5));
                        me->SetPower(POWER_ENERGY, power);
                        if (power >= 100)
                        {
                            me->SetPower(POWER_ENERGY, 0);
                            events.ScheduleEvent(EVENT_GRASP_OF_THE_SUNKEN_CITY, 1s);
                        }
                        events.ScheduleEvent(EVENT_ADD_POWER, 10s);
                        break;
                    }
                    case EVENT_GRASP_OF_THE_SUNKEN_CITY:
                        Talk(TEXT_GRASP_WHISPER);
                        Talk(TEXT_GRASP_YELL);
                        me->CastSpell(me, SPELL_GRASP_OF_THE_SUNKEN_CITY_CHANNEL);
                        HandleSunkenPhase();
                        me->SummonCreature(NPC_FORGOTTEN_DENIZEN, ForgottenDenizenSpawnPoints[0], TEMPSUMMON_CORPSE_DESPAWN);
                        me->SummonCreature(NPC_FORGOTTEN_DENIZEN, ForgottenDenizenSpawnPoints[1], TEMPSUMMON_CORPSE_DESPAWN);
                        me->SummonCreature(NPC_SUNKEN_DENIZEN, ForgottenDenizenSpawnPoints[2], TEMPSUMMON_CORPSE_DESPAWN);
                        break;
                    case EVENT_YAWNING_GATE:
                        me->CastSpell(me, SPELL_YAWNING_GATE);
                        events.ScheduleEvent(EVENT_YAWNING_GATE, 15s);
                        break;
                    case EVENT_TENTACLE_SUMMON:
                        if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, 100.0f, true))
                            me->CastSpell(target, SPELL_TENTACLE_SLAM_SUMMON, true);
                        events.ScheduleEvent(EVENT_TENTACLE_SUMMON, 14s);
                        break;
                    case EVENT_WHISPERS_OF_POWER:
                        SelectHealerOrOther();
                        events.ScheduleEvent(EVENT_WHISPERS_OF_POWER, 19s);
                        break;
                    case EVENT_CALL_THE_ABYSS:
                        Talk(TEXT_ABYSS_WHISPER);
                        Talk(TEXT_ABYSS_YELL);
                        me->CastSpell(me, SPELL_CALL_THE_ABYSS);
                        events.ScheduleEvent(EVENT_CALL_THE_ABYSS, 13s);
                        break;
                    default:
                        break;
                }
            }

        me->DoMeleeAttackIfReady();
    }
};

struct npc_volzith_tentacle : public ScriptedAI
{
    npc_volzith_tentacle(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override
        {
            me->AddUnitState(UNIT_STATE_ROOT);
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.ScheduleEvent(EVENT_TENTACLE_SLAM, 8s);
        }

        void UpdateAI(uint32 diff) override
        {
            events.Update(diff);

            if (!UpdateVictim())
                return;

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            while (uint32 eventId = events.ExecuteEvent())
            {
                if (eventId == EVENT_TENTACLE_SLAM)
                {
                    if (Unit* target = SelectTarget(SelectTargetMethod::MinDistance, 0, 100.0f))
                        me->CastSpell(target, SPELL_TENTACLE_SLAM_DAMAGE);
                    events.ScheduleEvent(EVENT_TENTACLE_SLAM, 8s);
                }
            }

            me->DoMeleeAttackIfReady();
        }

private:
    EventMap events;
};

struct npc_volzith_manifestation : public ScriptedAI
{
    npc_volzith_manifestation(Creature* creature) : ScriptedAI(creature) { }

    void UpdateAI(uint32 /*diff*/) override
    {
        Creature* volzith = me->FindNearestCreature(BOSS_VOLZITH_THE_WHISPERER, 500.0f, true);
        if (!volzith)
            return;

        me->GetMotionMaster()->MoveChase(volzith);
        if (me->GetDistance(volzith) <= 1.0f)
        {
            me->CastSpell(me, SPELL_ABYSSAL_ERUPTION_DAMAGE, true);
            volzith->SetPower(POWER_ENERGY, volzith->GetPower(POWER_ENERGY) + 1);
            me->DespawnOrUnsummon();
        }
    }
};

struct npc_volzith_forgotten_denizen : public ScriptedAI
{
    npc_volzith_forgotten_denizen(Creature* creature) : ScriptedAI(creature) { }

    void DamageTaken(Unit* attacker, uint32& damage, DamageEffectType /*damageType*/, SpellInfo const* /*spellInfo*/) override
    {
        bool lethal = damage >= me->GetHealth();

        if (!attacker || !attacker->HasAura(SPELL_GRASP_OF_THE_SUNKEN_CITY_DPS_PHASE))
            damage = 0;

        if (!lethal)
            return;

        if (Creature* volzith = me->FindNearestCreature(BOSS_VOLZITH_THE_WHISPERER, 500.0f, true))
            volzith->AI()->DoAction(ACTION_COUNT_DPS_PHASE);

        me->DespawnOrUnsummon(1s);
    }

    void JustEngagedWith(Unit* /*who*/) override
    {
        events.ScheduleEvent(EVENT_CONSUME_ESSENCE, 3s);
    }

    void UpdateAI(uint32 diff) override
    {
        events.Update(diff);

        if (!UpdateVictim())
            return;

        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        while (uint32 eventId = events.ExecuteEvent())
        {
            if (eventId == EVENT_CONSUME_ESSENCE)
            {
                me->CastSpell(me->GetVictim(), SPELL_CONSUME_ESSENCE);
                events.ScheduleEvent(EVENT_CONSUME_ESSENCE, 14s);
            }
        }

        me->DoMeleeAttackIfReady();
    }

private:
    EventMap events;
};

struct npc_volzith_sunken_denizen : public ScriptedAI
{
    npc_volzith_sunken_denizen(Creature* creature) : ScriptedAI(creature) { }

    void Reset() override
    {
        me->AddAura(SPELL_LEVIATHANS_WAKE, me);
    }

    void DamageTaken(Unit* attacker, uint32& damage, DamageEffectType /*damageType*/, SpellInfo const* /*spellInfo*/) override
    {
        bool lethal = damage >= me->GetHealth();

        if (!attacker || !attacker->HasAura(SPELL_GRASP_OF_THE_SUNKEN_CITY_TANK_PHASE))
            damage = 0;

        if (!lethal)
            return;

        if (Creature* volzith = me->FindNearestCreature(BOSS_VOLZITH_THE_WHISPERER, 500.0f, true))
            volzith->AI()->DoAction(ACTION_COUNT_TANK_HEAL_PHASE);

        for (auto const& ref : me->GetMap()->GetPlayers())
            if (Player* player = ref.GetSource())
            {
                player->AddAura(SPELL_GRASP_OF_THE_SUNKEN_CITY_DPS_PHASE, player);
                player->RemoveAurasDueToSpell(SPELL_GRASP_OF_THE_SUNKEN_CITY_TANK_PHASE);
            }

        me->DespawnOrUnsummon(1s);
    }

    void UpdateAI(uint32 /*diff*/) override
    {
        if (!me->IsInCombat())
            DoZoneInCombat();

        me->DoMeleeAttackIfReady();
    }
};

// 267299 - Call the Abyss
class spell_volzith_call_the_abyss : public AuraScript
{
    PrepareAuraScript(spell_volzith_call_the_abyss);

    void OnPeriodic(AuraEffect const* /*aurEff*/)
    {
        Unit* caster = GetCaster();
        if (!caster)
            return;

        Position const& pos = Trinity::Containers::SelectRandomContainerElement(ManifestationSpawnPoints);
        caster->CastSpell(pos, SPELL_CALL_THE_ABYSS_SUMMON, true);
    }

    void Register() override
    {
        OnEffectPeriodic += AuraEffectPeriodicFn(spell_volzith_call_the_abyss::OnPeriodic, EFFECT_0, SPELL_AURA_PERIODIC_TRIGGER_SPELL);
    }
};

// 13312 - Yawning Gate
struct at_volzith_yawning_gate : AreaTriggerAI
{
    at_volzith_yawning_gate(AreaTrigger* areatrigger) : AreaTriggerAI(areatrigger) { }

    void OnUnitEnter(Unit* unit) override
    {
        Player* player = unit->ToPlayer();
        if (!player || player->HasAura(SPELL_YAWNING_GATE_AURA))
            return;

        player->CastSpell(player, SPELL_YAWNING_GATE_AURA, true);
    }

    void OnUnitExit(Unit* unit, AreaTriggerExitReason /*reason*/) override
    {
        if (unit->IsPlayer())
            unit->RemoveAurasDueToSpell(SPELL_YAWNING_GATE_AURA);
    }
};

void AddSC_boss_volzith_the_whisperer()
{
    RegisterShrineOfTheStormCreatureAI(boss_volzith_the_whisperer);
    RegisterCreatureAI(npc_volzith_tentacle);
    RegisterCreatureAI(npc_volzith_manifestation);
    RegisterCreatureAI(npc_volzith_forgotten_denizen);
    RegisterCreatureAI(npc_volzith_sunken_denizen);

    RegisterSpellScript(spell_volzith_call_the_abyss);

    RegisterAreaTriggerAI(at_volzith_yawning_gate);
}
