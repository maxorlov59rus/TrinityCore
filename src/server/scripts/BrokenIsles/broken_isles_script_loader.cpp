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

// This is where scripts' loading functions should be declared:

// World bosses
void AddSC_boss_ana_mouz();             // WorldBosses/boss_ana_mouz.cpp
void AddSC_boss_apocron();              // WorldBosses/boss_apocron.cpp
void AddSC_boss_brutallus_legion();     // WorldBosses/boss_brutallus_legion.cpp
void AddSC_boss_calamir();              // WorldBosses/boss_calamir.cpp
void AddSC_boss_drugon_the_frostblood();// WorldBosses/boss_drugon_the_frostblood.cpp
void AddSC_boss_flotsam();              // WorldBosses/boss_flotsam.cpp
void AddSC_boss_humongris();            // WorldBosses/boss_humongris.cpp
void AddSC_boss_levantus();             // WorldBosses/boss_levantus.cpp
void AddSC_boss_malificus();            // WorldBosses/boss_malificus.cpp
void AddSC_boss_nazak_the_fiend();      // WorldBosses/boss_nazak_the_fiend.cpp
void AddSC_boss_nithogg();              // WorldBosses/boss_nithogg.cpp
void AddSC_boss_sharthos();             // WorldBosses/boss_sharthos.cpp
void AddSC_boss_the_soultakers();       // WorldBosses/boss_the_soultakers.cpp
void AddSC_boss_withered_jim();         // WorldBosses/boss_withered_jim.cpp

void AddSC_zone_dalaran_broken_isle();
void AddSC_zone_mardum();

// Maw of Souls
void AddSC_boss_ymiron_the_fallen_king();
void AddSC_instance_maw_of_souls();

// Trial of Valor
void AddSC_boss_guarm();
void AddSC_instance_trial_of_valor();

// Black Rook Hold
void AddSC_boss_amalgam_of_souls();
void AddSC_instance_black_rook_hold();

// Neltharion's Lair
void AddSC_boss_rokmora();
void AddSC_instance_neltharions_lair();

// Eye of Azshara
void AddSC_boss_king_deepbeard();
void AddSC_instance_eye_of_azshara();

// Orderhalls
void AddSC_orderhall_warrior();
void AddSC_orderhall_rogue();

// The name of this function should match:
// void Add${NameOfDirectory}Scripts()
void AddBrokenIslesScripts()
{
    // World bosses
    AddSC_boss_ana_mouz();
    AddSC_boss_apocron();
    AddSC_boss_brutallus_legion();
    AddSC_boss_calamir();
    AddSC_boss_drugon_the_frostblood();
    AddSC_boss_flotsam();
    AddSC_boss_humongris();
    AddSC_boss_levantus();
    AddSC_boss_malificus();
    AddSC_boss_nazak_the_fiend();
    AddSC_boss_nithogg();
    AddSC_boss_sharthos();
    AddSC_boss_the_soultakers();
    AddSC_boss_withered_jim();

    AddSC_zone_dalaran_broken_isle();
    AddSC_zone_mardum();

    // Maw of Souls
    AddSC_boss_ymiron_the_fallen_king();
    AddSC_instance_maw_of_souls();

    // Trial of Valor
    AddSC_boss_guarm();
    AddSC_instance_trial_of_valor();

    // Black Rook Hold
    AddSC_boss_amalgam_of_souls();
    AddSC_instance_black_rook_hold();

    // Neltharion's Lair
    AddSC_boss_rokmora();
    AddSC_instance_neltharions_lair();

    // Eye of Azshara
    AddSC_boss_king_deepbeard();
    AddSC_instance_eye_of_azshara();

    // Orderhalls
    AddSC_orderhall_warrior();
    AddSC_orderhall_rogue();
}
