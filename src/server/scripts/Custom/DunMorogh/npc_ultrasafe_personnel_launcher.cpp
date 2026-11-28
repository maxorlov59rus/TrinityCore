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

/*
 * Quest 25839 - The Ultrasafe Personnel Launcher.
 *
 * Ported from aquadeus/TrinityCore, branch quest_25839, commit 6add93bf04,
 * where the AI lived in EasternKingdoms/zone_dun_morogh.cpp. It is kept in
 * Custom/DunMorogh instead so no files shipped by master have to be edited.
 *
 * Verified against client 12.1.5.70961: QuestV2.db2 has quest 25839 and
 * SpellName.db2 has 50630, 77424, 77431 and 96003. The old spellclick on
 * NPC 41327 used 59099, which the client calls "Destroy Platform".
 *
 * ---------------------------------------------------------------------------
 * HOW THIS DIRECTORY GETS BUILT (read before adding another file)
 *
 * 1. cmake/macros/AutoCollect.cmake CollectAndAddSourceFiles() recurses into
 *    subdirectories and file(GLOB)s *.cpp, so Custom/DunMorogh/*.cpp is picked
 *    up without a CMakeLists.txt of its own.
 *
 * 2. That file(GLOB) has NO CONFIGURE_DEPENDS. A brand new .cpp file therefore
 *    enters the build only after a fresh configure via reconfigure_build.cmd.
 *
 * 3. custom_script_loader.cpp has to call AddSC_quest_25839_launcher(),
 *    otherwise RegisterCreatureAI() never runs and the NPC stays inert.
 * ---------------------------------------------------------------------------
 */

#include "CombatAI.h"
#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "SpellDefines.h"
#include "Vehicle.h"

enum UltrasafeMisc
{
    // Spells
    SPELL_EJECT_ALL_PASSENGERS     = 50630,
    SPELL_PREPARE_FOR_LAUNCH       = 96003,
    SPELL_FORCE_CAST_DEPLOY_A_TRON = 77431,

    // Vehicle
    SEAT_PLAYER = 0
};

// 41398 - Ultrasafe Personnel Launcher
struct npc_ultrasafe_personnel_launcher : public VehicleAI
{
    npc_ultrasafe_personnel_launcher(Creature* creature) : VehicleAI(creature) { }

    void PassengerBoarded(Unit* passenger, int8 /*seat*/, bool apply) override
    {
        if (!apply || !passenger)
            return;

        _scheduler.Schedule(2s, [this](TaskContext& /*task*/)
        {
            Vehicle* vehicleKit = me->GetVehicleKit();
            if (!vehicleKit)
                return;

            Unit* player = vehicleKit->GetPassenger(SEAT_PLAYER);
            if (!player)
                return;

            DoCastSelf(SPELL_EJECT_ALL_PASSENGERS);
            player->CastSpell(player, SPELL_PREPARE_FOR_LAUNCH, false);
            player->CastSpell(player, SPELL_FORCE_CAST_DEPLOY_A_TRON, TRIGGERED_IGNORE_CASTER_AURAS);
        });
    }

    void UpdateAI(uint32 diff) override
    {
        _scheduler.Update(diff);
    }

private:
    TaskScheduler _scheduler;
};

void AddSC_quest_25839_launcher()
{
    RegisterCreatureAI(npc_ultrasafe_personnel_launcher);
}
