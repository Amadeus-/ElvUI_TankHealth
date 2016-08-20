--Code adapted from weakaura by Hamsda (with permission)
--https://wago.io/profile/Hamsda

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local TH = E:GetModule("TankHealth");

local function GetArtifactMultiplier()
    local scatterTheShadowsRank = TH:GetArtifactTraitRank(209223)
    -- Scatter the Shadows multiplier is 10% * rank
    return 1 + scatterTheShadowsRank * 0.1
end

function TH:Calculate_Paladin()
    -- Get missing hp percentage
    local curHP = UnitHealth("player")
    local maxHP = UnitHealthMax("player")
    local missingHp = maxHP - curHP

    -- LOTP heals for 35% of missing health
    local healMulti = 0.35

    -- Stat multipliers
    local versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
    local versatilityMulti = 1 + (versatility / 100)

    -- Check if standing in Consecration or Consecrated Hammer is skilled
    local consMulti = ((select(4, GetTalentInfo(1,3,1))) or UnitBuff("player", GetSpellInfo(188370))) and 1.2 or 1

    -- Check for Avenging Wrath
    local awMulti = UnitBuff("player", GetSpellInfo(31884)) and (1 + (select(17, UnitBuff("player", GetSpellInfo(31884)))) / 100) or 1

    -- Check artifact traits

    local artifactMulti = 1 + 0.1 * currentRank


    -- Multiply everything
    local totalHeal = missingHp * healMulti * consMulti * versatilityMulti * awMulti * artifactMulti

    return totalHeal

end