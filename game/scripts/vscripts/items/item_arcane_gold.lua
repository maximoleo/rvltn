
LinkLuaModifier("modifier_item_arcane_gold","items/item_arcane_gold.lua", LUA_MODIFIER_MOTION_NONE)


item_arcane_gold = class({})

function item_arcane_gold:GetIntrinsicModifierName()
    return "modifier_item_arcane_gold"
end

function item_arcane_gold:OnSpellStart()
  local caster = self:GetCaster()

  -- Prevent Meepo Clones from activating Greater Arcane Boots
  if caster:IsIllusion() or caster:IsTempestDouble() or caster:IsClone() then
    return false
  end

  local heroes = FindUnitsInRadius(
    caster:GetTeamNumber(),
    caster:GetAbsOrigin(),
    nil,
    self:GetSpecialValueFor("radius"),
    DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
    DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MANA_ONLY,
    FIND_ANY_ORDER,
    false
  )

  local function ReplenishMana(hero)
    local manaReplenishAmount = self:GetSpecialValueFor("mana")
    hero:GiveMana(manaReplenishAmount)

    local particleManaGainName = "particles/items_fx/arcane_boots_recipient.vpcf"

    SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_MANA_ADD, hero, manaReplenishAmount, caster:GetPlayerOwner())

    if hero ~= caster then
      SendOverheadEventMessage(hero:GetPlayerOwner(), OVERHEAD_ALERT_MANA_ADD, hero, manaReplenishAmount, caster:GetPlayerOwner())
    end

    local particleManaGain = ParticleManager:CreateParticle(particleManaGainName, PATTACH_ABSORIGIN_FOLLOW, hero)
    ParticleManager:SetParticleControl(particleManaGain, 1, hero:GetOrigin())
    ParticleManager:SetParticleControl(particleManaGain, 2, hero:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particleManaGain)
  end

  for _,v in pairs(heroes) do
  local particleArcaneActivateName = "particles/items_fx/arcane_boots.vpcf"
  local particleArcaneActivate = ParticleManager:CreateParticle(particleArcaneActivateName, PATTACH_ABSORIGIN_FOLLOW, caster)
  ParticleManager:ReleaseParticleIndex(particleArcaneActivate)

  caster:EmitSound("DOTA_Item.ArcaneBoots.Activate")
  end
end



modifier_item_arcane_gold = class({
	  IsHidden = function() return true end,
	  IsDebuff = function() return false end,
	  IsPurgable = function() return false end,
	  RemoveOnDeath = function() return false end,
})


function modifier_item_arcane_gold:OnCreated()
    self:StartIntervalThink(1)
end


function modifier_item_arcane_gold:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_item_arcane_gold:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor('movespeed')
end

function modifier_item_arcane_gold:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana_stat')
end

if IsServer() then
    function modifier_item_arcane_gold:OnIntervalThink()
    	  if not PlayerResource then
            -- sometimes for no reason the player resource isn't there, usually only at the start of games in tools mode
            return
        end
        local caster = self:GetCaster()
        local gpm = self:GetAbility():GetSpecialValueFor('inc_gpm')

        -- Don't give gold on illusions, Tempest Doubles, or Meepo clones
        if caster:IsIllusion() or caster:IsTempestDouble() or caster:IsClone() then
          return
        end
        Gold:ModifyGold(caster:GetPlayerOwnerID(), gpm / 60, true, DOTA_ModifyGold_GameTick)
    end
end

function modifier_item_arcane_gold:OnDestroy()
	  self:StartIntervalThink(-1)
end