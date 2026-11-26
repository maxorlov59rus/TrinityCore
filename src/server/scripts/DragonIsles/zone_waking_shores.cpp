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

#include "Player.h"
#include "ScriptMgr.h"
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

void AddSC_zone_waking_shores()
{
    new transport_to_waking_shore();
}
