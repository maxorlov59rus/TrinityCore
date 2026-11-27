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

#include "AreaBoundary.h"
#include "GameObject.h"
#include "InstanceScript.h"
#include "ScriptMgr.h"
#include "underrot.h"

BossBoundaryData const boundaries =
{
    { DATA_ELDER_LEAXA,          new CircleBoundary(Position(869.502014f, 1230.199951f), 58.0f) },
    { DATA_CRAGMAW_THE_INFESTED, new CircleBoundary(Position(852.797974f, 982.133545f), 90.0f) },
    { BOSS_SPORECALLER_ZANCHA,   new ZRangeBoundary(35.240f, 26.790f) },
    { DATA_UNBOUND_ABOMINATION,  new ZRangeBoundary(-200.f, -150.f) }
};

static constexpr ObjectData creatureData[] =
{
    { BOSS_ELDER_LEAXA,             DATA_ELDER_LEAXA            },
    { BOSS_SPORECALLER_ZANCHA,      DATA_SPORECALLER_ZANCHA     },
    { BOSS_CRAGMAW_THE_INFESTED,    DATA_CRAGMAW_THE_INFESTED   },
    { BOSS_UNBOUND_ABOMINATION,     DATA_UNBOUND_ABOMINATION    },
};

static constexpr ObjectData gameObjectData[] =
{
    { GO_PYRAMID_WEB,                           DATA_PYRAMID_WEB    },
    { GO_PYRAMID_DOOR_UNBOUND_ABOMINATION_ENTRANCE, DATA_PYRAMID_DOOR  }
};

static constexpr DoorData doorData[] =
{
    { GO_WALL_DOOR_SHORTCUT_ENTRANCE,        DATA_SPORECALLER_ZANCHA,  EncounterDoorBehavior::OpenWhenDone },
};

static constexpr DungeonEncounterData encounters[] =
{
    { DATA_ELDER_LEAXA,             {{ 2111 }} },
    { DATA_CRAGMAW_THE_INFESTED,    {{ 2118 }} },
    { DATA_SPORECALLER_ZANCHA,      {{ 2112 }} },
    { DATA_UNBOUND_ABOMINATION,     {{ 2123 }} },
};

class instance_underrot : public InstanceMapScript
{
public:
    instance_underrot() : InstanceMapScript(UnderrotScriptName, 1841) { }

    struct instance_underrot_InstanceMapScript : public InstanceScript
    {
        instance_underrot_InstanceMapScript(InstanceMap* map) : InstanceScript(map)
        {
            SetHeaders(DataHeader);
            SetBossNumber(EncounterCount);
            LoadObjectData(creatureData, gameObjectData);
            LoadDoorData(doorData);
            LoadBossBoundaries(boundaries);
            LoadDungeonEncounterData(encounters);

            _cragmawCrawgEating = false;
            _facelessCorruptorDeaths = 0;
            _hezrelEventDone = false;
        }

        uint32 GetData(uint32 dataId) const override
        {
            switch (dataId)
            {
                case DATA_CRAGMAW_CRAWG_EATING:
                    return _cragmawCrawgEating ? 1 : 0;
                case DATA_FACELESS_CORRUPTOR_1:
                    return _facelessCorruptorDeaths >= 1 ? 1 : 0;
                case DATA_FACELESS_CORRUPTOR_2:
                    return _facelessCorruptorDeaths >= 2 ? 1 : 0;
                case DATA_EVENT_HERZEL:
                    return _hezrelEventDone ? DONE : NOT_STARTED;
                default:
                    break;
            }
            return 0;
        }

        void SetData(uint32 dataId, uint32 value) override
        {
            switch (dataId)
            {
                case DATA_CRAGMAW_CRAWG_EATING:
                    _cragmawCrawgEating = true;
                    break;
                case DATA_EVENT_HERZEL:
                    if (value == DONE && !_hezrelEventDone)
                    {
                        _hezrelEventDone = true;

                        if (GameObject* web = GetGameObject(DATA_PYRAMID_WEB))
                            web->DestroyForNearbyPlayers();

                        HandleGameObject(ObjectGuid::Empty, true, GetGameObject(DATA_PYRAMID_DOOR));
                    }
                    break;
                default:
                    break;
            }
        }

        void OnCreatureCreate(Creature* creature) override
        {
            InstanceScript::OnCreatureCreate(creature);

            if (creature->GetEntry() == NPC_TITAN_KEEPER_HEZREL)
                AddObject(creature, creature->GetPositionZ() < -100.f ? DATA_BOSS_HERZEL : DATA_EVENT_HERZEL, true);
        }

        void OnUnitDeath(Unit* unit) override
        {
            if (unit->GetEntry() != NPC_FACELESS_CORRUPTOR || _facelessCorruptorDeaths >= 2)
                return;

            ++_facelessCorruptorDeaths;

            if (Creature* hezrel = GetCreature(DATA_EVENT_HERZEL))
            {
                if (_facelessCorruptorDeaths == 1)
                    hezrel->AI()->SetData(DATA_EVENT_HERZEL, 1);
                else if (_facelessCorruptorDeaths == 2)
                    hezrel->AI()->SetData(DATA_EVENT_HERZEL, 2);
            }
        }

    private:
        bool _cragmawCrawgEating;
        uint8 _facelessCorruptorDeaths;
        bool _hezrelEventDone;
    };

    InstanceScript* GetInstanceScript(InstanceMap* map) const override
    {
        return new instance_underrot_InstanceMapScript(map);
    }
};

void AddSC_instance_underrot()
{
    new instance_underrot();
}
