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

#include "GameObjectAI.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "Transport.h"

enum WakingShoresQuests
{
    QUEST_TO_THE_DRAGON_ISLES_ALLIANCE = 67700,
    QUEST_TO_THE_DRAGON_ISLES_HORDE    = 65444,

    CREDIT_TO_THE_DRAGON_ISLES_ALLIANCE = 194131,
    CREDIT_TO_THE_DRAGON_ISLES_HORDE    = 184805
};

// 375041 - The Defiant Dragonscale
// 375073 - The Rugged Dragonscale
class transport_to_waking_shore : public TransportScript
{
public:
    transport_to_waking_shore() : TransportScript("transport_to_waking_shore") { }

    void OnAddPassenger(Transport* /*transport*/, Player* player) override
    {
        if (player->GetQuestStatus(QUEST_TO_THE_DRAGON_ISLES_ALLIANCE) == QUEST_STATUS_INCOMPLETE)
            player->KilledMonsterCredit(CREDIT_TO_THE_DRAGON_ISLES_ALLIANCE);

        if (player->GetQuestStatus(QUEST_TO_THE_DRAGON_ISLES_HORDE) == QUEST_STATUS_INCOMPLETE)
            player->KilledMonsterCredit(CREDIT_TO_THE_DRAGON_ISLES_HORDE);
    }
};

enum WakingShoresQuestInteractions
{
    QUEST_EXPLORERS_IN_PERIL_ALLIANCE = 70122,
    QUEST_EXPLORERS_IN_PERIL_HORDE    = 65452,
    QUEST_LIBRARY_OF_ALEXSTRASZA      = 66000,
    QUEST_FROM_SUCH_GREAT_HEIGHTS     = 66101,
    QUEST_THE_SPARK                   = 66354,
    QUEST_A_LAST_HOPE                 = 66001
};

enum WakingShoresQuestCredits
{
    SPELL_LIBRARY_CREDIT_1 = 373082,
    SPELL_LIBRARY_CREDIT_2 = 373992,
    SPELL_LIBRARY_CREDIT_3 = 373993,
    SPELL_LIBRARY_CREDIT_4 = 373994,
    SPELL_LIBRARY_CREDIT_5 = 373995,
    SPELL_LIBRARY_CREDIT_6 = 373996,

    CREDIT_EXPLORERS_IN_PERIL_ALLIANCE = 194139,
    CREDIT_EXPLORERS_IN_PERIL_HORDE    = 189838
};

// 376502 - Protodragon Rib Cage (Alliance)
class go_protodragon_rib_cage : public GameObjectScript
{
public:
    go_protodragon_rib_cage() : GameObjectScript("go_protodragon_rib_cage") { }

    struct go_protodragon_rib_cageAI : public GameObjectAI
    {
        go_protodragon_rib_cageAI(GameObject* go) : GameObjectAI(go) { }

        bool OnGossipHello(Player* player) override
        {
            if (player->GetQuestStatus(QUEST_EXPLORERS_IN_PERIL_ALLIANCE) == QUEST_STATUS_INCOMPLETE)
                player->KilledMonsterCredit(CREDIT_EXPLORERS_IN_PERIL_ALLIANCE);

            return true;
        }
    };

    GameObjectAI* GetAI(GameObject* go) const override
    {
        return new go_protodragon_rib_cageAI(go);
    }
};

// 379137 - Protodragon Rib Cage (Horde)
class go_protodragon_rib_cage_379137 : public GameObjectScript
{
public:
    go_protodragon_rib_cage_379137() : GameObjectScript("go_protodragon_rib_cage_379137") { }

    struct go_protodragon_rib_cage_379137AI : public GameObjectAI
    {
        go_protodragon_rib_cage_379137AI(GameObject* go) : GameObjectAI(go) { }

        bool OnGossipHello(Player* player) override
        {
            if (player->GetQuestStatus(QUEST_EXPLORERS_IN_PERIL_HORDE) == QUEST_STATUS_INCOMPLETE)
                player->KilledMonsterCredit(CREDIT_EXPLORERS_IN_PERIL_HORDE);

            return true;
        }
    };

    GameObjectAI* GetAI(GameObject* go) const override
    {
        return new go_protodragon_rib_cage_379137AI(go);
    }
};

// 376941 - The Titanic Comedy
class go_titanic_comedy : public GameObjectScript
{
public:
    go_titanic_comedy() : GameObjectScript("go_titanic_comedy") { }

    struct go_titanic_comedyAI : public GameObjectAI
    {
        go_titanic_comedyAI(GameObject* go) : GameObjectAI(go) { }

        bool OnGossipHello(Player* player) override
        {
            if (player->GetQuestStatus(QUEST_LIBRARY_OF_ALEXSTRASZA) == QUEST_STATUS_INCOMPLETE)
                player->CastSpell(player, SPELL_LIBRARY_CREDIT_1, true);

            return true;
        }
    };

    GameObjectAI* GetAI(GameObject* go) const override
    {
        return new go_titanic_comedyAI(go);
    }
};

// 376942 - The Scales of Wrath
class go_scales_of_wrath : public GameObjectScript
{
public:
    go_scales_of_wrath() : GameObjectScript("go_scales_of_wrath") { }

    struct go_scales_of_wrathAI : public GameObjectAI
    {
        go_scales_of_wrathAI(GameObject* go) : GameObjectAI(go) { }

        bool OnGossipHello(Player* player) override
        {
            if (player->GetQuestStatus(QUEST_LIBRARY_OF_ALEXSTRASZA) == QUEST_STATUS_INCOMPLETE)
                player->CastSpell(player, SPELL_LIBRARY_CREDIT_2, true);

            return true;
        }
    };

    GameObjectAI* GetAI(GameObject* go) const override
    {
        return new go_scales_of_wrathAI(go);
    }
};

// 376943 - Dracuixote
class go_Dracuixote : public GameObjectScript
{
public:
    go_Dracuixote() : GameObjectScript("go_Dracuixote") { }

    struct go_DracuixoteAI : public GameObjectAI
    {
        go_DracuixoteAI(GameObject* go) : GameObjectAI(go) { }

        bool OnGossipHello(Player* player) override
        {
            if (player->GetQuestStatus(QUEST_LIBRARY_OF_ALEXSTRASZA) == QUEST_STATUS_INCOMPLETE)
            {
                player->CastSpell(player, SPELL_LIBRARY_CREDIT_3, true);
                player->CompleteQuest(QUEST_LIBRARY_OF_ALEXSTRASZA);
            }

            return true;
        }
    };

    GameObjectAI* GetAI(GameObject* go) const override
    {
        return new go_DracuixoteAI(go);
    }
};

// 376944 - The Lord of the Wings
class go_lord_of_the_wings : public GameObjectScript
{
public:
    go_lord_of_the_wings() : GameObjectScript("go_lord_of_the_wings") { }

    struct go_lord_of_the_wingsAI : public GameObjectAI
    {
        go_lord_of_the_wingsAI(GameObject* go) : GameObjectAI(go) { }

        bool OnGossipHello(Player* player) override
        {
            if (player->GetQuestStatus(QUEST_LIBRARY_OF_ALEXSTRASZA) == QUEST_STATUS_INCOMPLETE)
                player->CastSpell(player, SPELL_LIBRARY_CREDIT_4, true);

            return true;
        }
    };

    GameObjectAI* GetAI(GameObject* go) const override
    {
        return new go_lord_of_the_wingsAI(go);
    }
};

// 376945 - The Red and the Black Flights
class go_red_and_black_flights : public GameObjectScript
{
public:
    go_red_and_black_flights() : GameObjectScript("go_red_and_black_flights") { }

    struct go_red_and_black_flightsAI : public GameObjectAI
    {
        go_red_and_black_flightsAI(GameObject* go) : GameObjectAI(go) { }

        bool OnGossipHello(Player* player) override
        {
            if (player->GetQuestStatus(QUEST_LIBRARY_OF_ALEXSTRASZA) == QUEST_STATUS_INCOMPLETE)
                player->CastSpell(player, SPELL_LIBRARY_CREDIT_5, true);

            return true;
        }
    };

    GameObjectAI* GetAI(GameObject* go) const override
    {
        return new go_red_and_black_flightsAI(go);
    }
};

// 376946 - Pride and Protodrakes
class go_pride_and_protodrakes : public GameObjectScript
{
public:
    go_pride_and_protodrakes() : GameObjectScript("go_pride_and_protodrakes") { }

    struct go_pride_and_protodrakesAI : public GameObjectAI
    {
        go_pride_and_protodrakesAI(GameObject* go) : GameObjectAI(go) { }

        bool OnGossipHello(Player* player) override
        {
            if (player->GetQuestStatus(QUEST_LIBRARY_OF_ALEXSTRASZA) == QUEST_STATUS_INCOMPLETE)
                player->CastSpell(player, SPELL_LIBRARY_CREDIT_6, true);

            return true;
        }
    };

    GameObjectAI* GetAI(GameObject* go) const override
    {
        return new go_pride_and_protodrakesAI(go);
    }
};

// 190171 - Ruby Egg Guardian
class npc_ruby_egg_guardian : public CreatureScript
{
public:
    npc_ruby_egg_guardian() : CreatureScript("npc_ruby_egg_guardian") { }

    struct npc_ruby_egg_guardianAI : public ScriptedAI
    {
        npc_ruby_egg_guardianAI(Creature* creature) : ScriptedAI(creature) { }

        bool OnGossipHello(Player* player) override
        {
            if (me->IsQuestGiver())
                player->PrepareQuestMenu(me->GetGUID());

            if (player->GetQuestStatus(QUEST_LIBRARY_OF_ALEXSTRASZA) == QUEST_STATUS_INCOMPLETE)
                player->CompleteQuest(QUEST_LIBRARY_OF_ALEXSTRASZA);

            SendGossipMenuFor(player, player->GetGossipTextId(me), me->GetGUID());
            return true;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_ruby_egg_guardianAI(creature);
    }
};

// 193707 - Surveyor's Disc
class npc_surveyors_disk : public CreatureScript
{
public:
    npc_surveyors_disk() : CreatureScript("npc_surveyors_disk") { }

    struct npc_surveyors_diskAI : public ScriptedAI
    {
        npc_surveyors_diskAI(Creature* creature) : ScriptedAI(creature) { }

        bool OnGossipHello(Player* player) override
        {
            if (player->GetQuestStatus(QUEST_FROM_SUCH_GREAT_HEIGHTS) == QUEST_STATUS_INCOMPLETE)
                player->CompleteQuest(QUEST_FROM_SUCH_GREAT_HEIGHTS);

            return true;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_surveyors_diskAI(creature);
    }
};

// 377013 - Earth-Warder's Forge
class go_earthwardersforge_377013 : public GameObjectScript
{
public:
    go_earthwardersforge_377013() : GameObjectScript("go_earthwardersforge_377013") { }

    struct go_earthwardersforge_377013AI : public GameObjectAI
    {
        go_earthwardersforge_377013AI(GameObject* go) : GameObjectAI(go) { }

        bool OnGossipHello(Player* player) override
        {
            if (player->GetQuestStatus(QUEST_THE_SPARK) == QUEST_STATUS_INCOMPLETE)
                player->CompleteQuest(QUEST_THE_SPARK);

            return true;
        }
    };

    GameObjectAI* GetAI(GameObject* go) const override
    {
        return new go_earthwardersforge_377013AI(go);
    }
};

// 190155 - Caretaker Azkra
class npc_caretaker_azkra190155 : public CreatureScript
{
public:
    npc_caretaker_azkra190155() : CreatureScript("npc_caretaker_azkra190155") { }

    struct npc_caretaker_azkra190155AI : public ScriptedAI
    {
        npc_caretaker_azkra190155AI(Creature* creature) : ScriptedAI(creature) { }

        bool OnGossipHello(Player* player) override
        {
            if (me->IsQuestGiver())
                player->PrepareQuestMenu(me->GetGUID());

            if (player->GetQuestStatus(QUEST_A_LAST_HOPE) == QUEST_STATUS_INCOMPLETE)
                player->CompleteQuest(QUEST_A_LAST_HOPE);

            SendGossipMenuFor(player, player->GetGossipTextId(me), me->GetGUID());
            return true;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_caretaker_azkra190155AI(creature);
    }
};

void AddSC_zone_waking_shores()
{
    new transport_to_waking_shore();
    new go_protodragon_rib_cage();
    new go_protodragon_rib_cage_379137();
    new go_titanic_comedy();
    new go_scales_of_wrath();
    new go_Dracuixote();
    new go_lord_of_the_wings();
    new go_red_and_black_flights();
    new go_pride_and_protodrakes();
    new npc_ruby_egg_guardian();
    new npc_surveyors_disk();
    new go_earthwardersforge_377013();
    new npc_caretaker_azkra190155();
}
