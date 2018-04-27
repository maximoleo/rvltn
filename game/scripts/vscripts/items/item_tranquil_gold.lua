LinkLuaModifier("modifier_item_tranquil_heal","items/item_tranquil_gold.lua", LUA_MODIFIER_MOTION_NONE)

item_tranquil_gold = class({})

function item_tranquil_gold:GetIntrinsicModifierName()
    return "modifier_item_tranquil_heal"
end



modifier_item_tranquil_heal = class({
    IsHidden = function() return true end,
    IsDebuff = function() return false end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end,})

function modifier_item_tranquil_heal:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_ATTACKED
  }
end

function modifier_item_tranquil_heal:GetModifierMoveSpeedBonus_Constant()
    if self:GetStackCount() < 2 then
        return self:GetAbility():GetSpecialValueFor('bonus_movement_speed')
    else
        return self:GetAbility():GetSpecialValueFor('broken_movement_speed')
    end
end

function modifier_item_tranquil_heal:GetModifierConstantHealthRegen()
    if self:GetStackCount() < 2 then
        return self:GetAbility():GetSpecialValueFor('bonus_health_regen')
    else
        return 0        
    end
end

function modifier_item_tranquil_heal:OnCreated()
  self:StartIntervalThink(1)
end

if IsServer() then
  function modifier_item_tranquil_heal:OnIntervalThink()
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
  if self:GetAbility():IsCooldownReady() then
    self:SetStackCount(1)
  end
  end  
end


function modifier_item_tranquil_heal:OnAttacked(keys)
    self:SetStackCount(2)
    self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
end


