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
#include "SpellInfo.h"
#include "waycrest_manor.h"

#include <list>

enum GorakTulSpells
{
    SPELL_DARKENED_LIGHTNING            = 266225,
    SPELL_DARKENED_LIGHTNING_2          = 270464,
    SPELL_SUMMON_DEATHTOUCHED_SLAVER    = 266266,
    SPELL_SUMMON_DEATHTOUCHED_SLAVER_MISSILE = 266260,
    SPELL_DARK_LEAP                     = 273657,
    SPELL_DARK_LEAP_2                   = 273658,
    SPELL_DREAD_BOLT                    = 266460,
    SPELL_DREAD_ESSENCE                 = 266181,
    // SPELL_DREAD_ESSENCE_DISPELL      = 272829,
    // Heroic+
    SPELL_DEATH_LENS                    = 268202,
    SPELL_DEATH_LENS_PERIODIC           = 266724
};

enum GorakTulEvents
{
    EVENT_DARKENED_LIGHTNING = 1,
    EVENT_DEATHTOUCHED_SLAVER,
    EVENT_DREAD_ESSENCE,
    EVENT_DARK_LEAP,
    EVENT_DREAD_BOLT,
    EVENT_DEATH_LENS
};

enum GorakTulTexts
{
    SAY_AGGRO = 0,
    SAY_RISE  = 1,
    SAY_DEATH = 2
};

// 131864 - Gorak Tul
struct boss_gorak_tul : public BossAI
{
    boss_gorak_tul(Creature* creature) : BossAI(creature, DATA_GORAK_TUL) { }

    void Reset() override
    {
        BossAI::Reset();
        me->SetPowerType(POWER_LUNAR_POWER);
        me->SetPower(POWER_LUNAR_POWER, 1);
    }

    void JustEngagedWith(Unit* who) override
    {
        BossAI::JustEngagedWith(who);
        Talk(SAY_AGGRO);
        events.ScheduleEvent(EVENT_DARKENED_LIGHTNING, 8s);
        events.ScheduleEvent(EVENT_DEATHTOUCHED_SLAVER, 13s);
        events.ScheduleEvent(EVENT_DREAD_ESSENCE, 24s);
    }

    void JustDied(Unit* /*killer*/) override
    {
        _JustDied();
        Talk(SAY_DEATH);

        std::list<Creature*> slavers;
        me->GetCreatureListWithEntryInGrid(slavers, NPC_DEATHTOUCHED_SLAVER, 150.0f);
        for (Creature* slaver : slavers)
            slaver->DespawnOrUnsummon();
    }

    void ExecuteEvent(uint32 eventId) override
    {
        switch (eventId)
        {
            case EVENT_DARKENED_LIGHTNING:
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, 100.0f, true))
                {
                    DoCast(target, SPELL_DARKENED_LIGHTNING);
                    DoCast(target, SPELL_DARKENED_LIGHTNING_2);
                }
                events.Repeat(15s);
                break;

            case EVENT_DEATHTOUCHED_SLAVER:
                DoCast(SPELL_SUMMON_DEATHTOUCHED_SLAVER);
                if (Creature* portal = me->FindNearestCreature(NPC_DRUSTWAR_SUMMONING_PORTAL, 100.0f, true))
                    me->CastSpell(portal, SPELL_SUMMON_DEATHTOUCHED_SLAVER_MISSILE);
                events.Repeat(20s);
                break;

            case EVENT_DREAD_ESSENCE:
                Talk(SAY_RISE);
                DoCastAOE(SPELL_DREAD_ESSENCE);
                events.Repeat(25s);
                break;

            default:
                break;
        }
    }

    void OnSpellCast(SpellInfo const* spellInfo) override
    {
        if (spellInfo->Id == SPELL_DREAD_ESSENCE)
            ReviveSlavers();
    }

private:
    void ReviveSlavers()
    {
        std::list<Creature*> slavers;
        me->GetCreatureListWithEntryInGrid(slavers, NPC_DEATHTOUCHED_SLAVER, 150.0f);
        for (Creature* slaver : slavers)
        {
            if (!slaver->isDead())
                continue;

            slaver->Respawn();
            slaver->AI()->DoZoneInCombat();
        }
    }
};

// 135552 - Deathtouched Slaver
struct npc_deathtouched_slaver : public ScriptedAI
{
    npc_deathtouched_slaver(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(WorldObject* /*summoner*/) override
    {
        DoZoneInCombat();
    }

    void JustEngagedWith(Unit* /*who*/) override
    {
        events.ScheduleEvent(EVENT_DARK_LEAP, 3s);
        events.ScheduleEvent(EVENT_DREAD_BOLT, 6s);
        if (IsHeroic() || IsMythic())
            events.ScheduleEvent(EVENT_DEATH_LENS, 9s);
    }

    void UpdateAI(uint32 diff) override
    {
        if (!UpdateVictim())
            return;

        events.Update(diff);

        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        switch (events.ExecuteEvent())
        {
            case EVENT_DARK_LEAP:
                if (Unit* target = SelectTarget(SelectTargetMethod::MaxDistance, 0, 100.0f, true))
                {
                    DoCast(target, SPELL_DARK_LEAP);
                    DoCast(target, SPELL_DARK_LEAP_2);
                }
                events.Repeat(15s);
                break;

            case EVENT_DREAD_BOLT:
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, 40.0f, true))
                    DoCast(target, SPELL_DREAD_BOLT);
                events.Repeat(2s);
                break;

            case EVENT_DEATH_LENS:
                if (Unit* target = SelectTarget(SelectTargetMethod::MaxDistance, 0, 50.0f, true))
                {
                    DoCast(target, SPELL_DEATH_LENS);
                    DoCast(target, SPELL_DEATH_LENS_PERIODIC);
                }
                events.Repeat(20s);
                break;

            default:
                break;
        }

        me->DoMeleeAttackIfReady();
    }

private:
    EventMap events;
};

void AddSC_boss_gorak_tul()
{
    RegisterWaycrestManorCreatureAI(boss_gorak_tul);
    RegisterCreatureAI(npc_deathtouched_slaver);
}
