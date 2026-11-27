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

#include "CellImpl.h"
#include "Creature.h"
#include "GridNotifiersImpl.h"
#include "InstanceScript.h"
#include "MotionMaster.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "atal_dazar.h"

enum YazmaSpells
{
    SPELL_SOULREND               = 249923,
    SPELL_SOULREND_EXPLODE       = 256577,
    SPELL_WRACKING_PAIN          = 250096,
    SPELL_SKEWER                 = 249919,
    SPELL_ECHOES_OF_SHADOW       = 250050,
    SPELL_ECHOES_OF_SHADOW_SPAWN = 257291,
    SPELL_SHADRA_EMPOWERED       = 258612,
    SPELL_SHADRA_AREA_TRIGGER    = 250022
};

enum YazmaNpcs
{
    // Реальный спавн в map 1763 и ритейл 12.1.5.70961; BOSS_YAZMA из заголовка — 129412.
    NPC_YAZMA          = 122968,
    NPC_SOULSPAWN      = 125828,
    NPC_ECHO_OF_SHADRA = 125868
};

enum YazmaEvents
{
    EVENT_SKEWER = 1,
    EVENT_WRACKING_PAIN,
    EVENT_ECHOES_OF_SHADOW,
    EVENT_SOULREND
};

enum EchoOfShadraEvents
{
    EVENT_SHADRA_EMPOWER = 1,
    EVENT_SHADRA_EMPOWER_STOP
};

enum YazmaTexts
{
    SAY_AGGRO = 0,
    SAY_DEATH = 6
};

// 122968 - Yazma
struct boss_ataldazar_yazma : public BossAI
{
    boss_ataldazar_yazma(Creature* creature) : BossAI(creature, DATA_YAZMA) { }

    void Reset() override
    {
        BossAI::Reset();
    }

    void JustEngagedWith(Unit* who) override
    {
        BossAI::JustEngagedWith(who);

        Talk(SAY_AGGRO);

        events.ScheduleEvent(EVENT_WRACKING_PAIN, 3s);
        events.ScheduleEvent(EVENT_SKEWER, 5s);
        events.ScheduleEvent(EVENT_SOULREND, 10s);
        events.ScheduleEvent(EVENT_ECHOES_OF_SHADOW, 16s);
    }

    void SpellHitTarget(WorldObject* target, SpellInfo const* spell) override
    {
        if (spell->Id == SPELL_ECHOES_OF_SHADOW)
            me->CastSpell(target, SPELL_ECHOES_OF_SHADOW_SPAWN);
        else if (spell->Id == SPELL_SOULREND)
            me->SummonCreature(NPC_SOULSPAWN, target->GetPosition(), TEMPSUMMON_MANUAL_DESPAWN, 0s);
    }

    void JustDied(Unit* killer) override
    {
        Talk(SAY_DEATH);
        BossAI::JustDied(killer);
    }

    void ExecuteEvent(uint32 eventId) override
    {
        switch (eventId)
        {
            case EVENT_SOULREND:
            {
                if (IsHeroicOrHigher())
                {
                    std::list<Player*> playerList;
                    me->GetPlayerListInGrid(playerList, 100.0f);
                    for (Player* player : playerList)
                        if (player != me->GetVictim())
                            me->CastSpell(player, SPELL_SOULREND);
                }
                else if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, NonTankTargetSelector(me)))
                    me->CastSpell(target, SPELL_SOULREND);

                events.Repeat(41s);
                break;
            }
            case EVENT_WRACKING_PAIN:
            {
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                    me->CastSpell(target, SPELL_WRACKING_PAIN);

                events.Repeat(23s);
                break;
            }
            case EVENT_SKEWER:
            {
                me->CastSpell(me->GetVictim(), SPELL_SKEWER);
                events.Repeat(32s);
                break;
            }
            case EVENT_ECHOES_OF_SHADOW:
            {
                std::list<Player*> playerList;
                me->GetPlayerListInGrid(playerList, 100.0f);

                uint8 count = 0;
                for (Player* player : playerList)
                {
                    if (count == 4)
                        break;

                    me->CastSpell(player, SPELL_ECHOES_OF_SHADOW);
                    ++count;
                }

                events.Repeat(12s);
                break;
            }
            default:
                break;
        }
    }
};

// 125828 - Soulspawn
struct npc_ataldazar_soulspawn : public ScriptedAI
{
    npc_ataldazar_soulspawn(Creature* creature) : ScriptedAI(creature) { }

    void InitializeAI() override
    {
        me->SetReactState(REACT_PASSIVE);
        SetCombatMovement(false);

        ScriptedAI::InitializeAI();
    }

    void Reset() override
    {
        ScriptedAI::Reset();

        if (Player* player = me->SelectNearestPlayer(10.0f))
            me->SetDisplayId(player->GetDisplayId());

        if (Creature* yazma = me->FindNearestCreature(NPC_YAZMA, 100.0f))
            me->GetMotionMaster()->MoveFollow(yazma, 0.0f, 0.0f);
    }

    void UpdateAI(uint32 diff) override
    {
        ScriptedAI::UpdateAI(diff);

        if (Creature* yazma = me->FindNearestCreature(NPC_YAZMA, 100.0f))
        {
            if (me->GetDistance(yazma) < 1.0f)
            {
                DoCastSelf(SPELL_SOULREND_EXPLODE);
                me->DespawnOrUnsummon();
            }
        }
    }
};

// 125868 - Echo of Shadra; Wago 12.1.5.70961 подтверждает 250028 как summon 125868.
struct npc_ataldazar_echo_of_shadra : public ScriptedAI
{
    npc_ataldazar_echo_of_shadra(Creature* creature) : ScriptedAI(creature) { }

    void Reset() override
    {
        ScriptedAI::Reset();
        events.Reset();
        closestPlayer = nullptr;
        me->SetReactState(REACT_PASSIVE);
        me->SetWalk(false);
        me->GetMotionMaster()->MoveRandom(15.0f);
    }

    void IsSummonedBy(WorldObject* /*summoner*/) override
    {
        events.ScheduleEvent(EVENT_SHADRA_EMPOWER, 5s);
    }

    void MovementInform(uint32 /*type*/, uint32 /*id*/) override
    {
        me->GetMotionMaster()->MoveRandom(10.0f);
    }

    void UpdateAI(uint32 diff) override
    {
        events.Update(diff);
        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        if (closestPlayer && me->GetDistance(closestPlayer) < 1.0f)
        {
            DoCastSelf(SPELL_SHADRA_AREA_TRIGGER);
            me->KillSelf();
            return;
        }

        while (uint32 eventId = events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_SHADRA_EMPOWER:
                    me->AddAura(SPELL_SHADRA_EMPOWERED, me);
                    me->GetMotionMaster()->Clear();
                    closestPlayer = me->SelectNearestPlayer(100.0f);
                    if (closestPlayer)
                        me->GetMotionMaster()->MoveFollow(closestPlayer, 0.0f, 0.0f);
                    events.ScheduleEvent(EVENT_SHADRA_EMPOWER_STOP, 3s);
                    break;
                case EVENT_SHADRA_EMPOWER_STOP:
                    me->RemoveAura(SPELL_SHADRA_EMPOWERED);
                    events.ScheduleEvent(EVENT_SHADRA_EMPOWER, 6s);
                    me->GetMotionMaster()->Clear();
                    me->GetMotionMaster()->MoveRandom(10.0f);
                    closestPlayer = nullptr;
                    break;
                default:
                    break;
            }
        }
    }

private:
    EventMap events;
    Player* closestPlayer = nullptr;
};

void AddSC_boss_yazma()
{
    RegisterAtalDazarCreatureAI(boss_ataldazar_yazma);
    RegisterAtalDazarCreatureAI(npc_ataldazar_soulspawn);
    RegisterAtalDazarCreatureAI(npc_ataldazar_echo_of_shadra);
}
