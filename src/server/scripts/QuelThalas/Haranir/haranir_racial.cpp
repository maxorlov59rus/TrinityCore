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

// Расовые способности Харанира.
// VERIFY: идентификаторы 477000/477001/477002 требуют сверки с локальными DB2.
// Мгновенный урон и лечение приходят из DBC-эффектов самого 477000, поэтому
// скрипт не накладывает их повторно: он отвечает только за капы 8/8 и за ауры
// DoT/HoT, которых в «голых» эффектах нет.

#include "CellImpl.h"
#include "GridNotifiers.h"
#include "GridNotifiersImpl.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "SpellScript.h"

#include <algorithm>
#include <vector>

namespace HaranirConfig
{
    // VERIFY — сверить с локальными DB2 перед включением SQL-бинда.
    constexpr uint32 THORN_BLOOM = 477000; // активная расовая способность
    constexpr uint32 THORN_DOT   = 477001; // DoT на врагов, 12 с
    constexpr uint32 THORN_HOT   = 477002; // HoT на союзников, 12 с

    constexpr float  RADIUS     = 10.0f;  // ярды от точки каста
    constexpr uint32 MAX_ENEMIES = 8;
    constexpr uint32 MAX_ALLIES  = 8;
}

namespace
{
    struct ThornBloomTargetCheck
    {
        WorldLocation const* Center;
        Unit const* Caster;
        bool Enemy;

        bool operator()(Unit const* unit) const
        {
            if (!unit || !unit->IsAlive() || unit == Caster)
                return false;

            // Дистанция считается от точки каста, а не от кастера.
            if (unit->GetExactDistSq(Center) > HaranirConfig::RADIUS * HaranirConfig::RADIUS)
                return false;

            if (Enemy)
                return Caster->IsValidAttackTarget(unit);

            return Caster->IsFriendlyTo(unit) && unit->IsPlayer() == Caster->IsPlayer();
        }
    };
}

// 477000 - Thorn Bloom
class spell_haranir_thorn_bloom : public SpellScript
{
    PrepareSpellScript(spell_haranir_thorn_bloom);

    bool Validate(SpellInfo const* /*spellInfo*/) override
    {
        return ValidateSpellInfo({ HaranirConfig::THORN_DOT, HaranirConfig::THORN_HOT });
    }

    void HandleCast()
    {
        Unit* caster = GetCaster();
        if (!caster)
            return;

        WorldLocation const* dest = GetExplTargetDest();
        WorldLocation center = dest ? *dest : caster->GetWorldLocation();

        CastSpellExtraArgs args(TRIGGERED_FULL_MASK);

        // Ближайшие 8 врагов: только аура DoT. Урон из DBC-эффектов 477000
        // Повторный каст не нужен — он дал бы двойные цифры.
        std::vector<Unit*> enemies;
        ThornBloomTargetCheck enemyCheck{ &center, caster, true };
        Trinity::UnitListSearcher enemySearcher(caster->GetPhaseShift(), enemies, enemyCheck);
        Cell::VisitAllObjects(center.GetPositionX(), center.GetPositionY(), caster->GetMap(), enemySearcher, HaranirConfig::RADIUS);

        std::sort(enemies.begin(), enemies.end(), [&center](Unit* a, Unit* b)
        {
            return a->GetExactDistSq(&center) < b->GetExactDistSq(&center);
        });

        for (std::size_t i = 0; i < enemies.size() && i < HaranirConfig::MAX_ENEMIES; ++i)
            caster->CastSpell(enemies[i], HaranirConfig::THORN_DOT, args);

        // Ближайшие 8 союзников: только аура HoT; мгновенное лечение уже
        // применяется эффектами 477000.
        std::vector<Unit*> allies;
        ThornBloomTargetCheck allyCheck{ &center, caster, false };
        Trinity::UnitListSearcher allySearcher(caster->GetPhaseShift(), allies, allyCheck);
        Cell::VisitAllObjects(center.GetPositionX(), center.GetPositionY(), caster->GetMap(), allySearcher, HaranirConfig::RADIUS);

        std::sort(allies.begin(), allies.end(), [&center](Unit* a, Unit* b)
        {
            return a->GetExactDistSq(&center) < b->GetExactDistSq(&center);
        });

        for (std::size_t i = 0; i < allies.size() && i < HaranirConfig::MAX_ALLIES; ++i)
            caster->CastSpell(allies[i], HaranirConfig::THORN_HOT, args);
    }

    void Register() override
    {
        AfterCast += SpellCastFn(spell_haranir_thorn_bloom::HandleCast);
    }
};

void AddSC_haranir_racial()
{
    RegisterSpellScript(spell_haranir_thorn_bloom);
}
