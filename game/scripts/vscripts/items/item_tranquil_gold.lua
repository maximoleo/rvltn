LinkLuaModifier("modifier_item_arcane_gold","items/item_arcane_gold.lua", LUA_MODIFIER_MOTION_NONE)

item_tranquil_gold = class({})

function item_tranquil_gold:GetIntrinsicModifierName()
  return "modifier_item_arcane_gold"
end





modifier_item_tranquil_heal = class({
    IsHidden = function() return 1 end,
    IsDebuff = function() return 0 end,
    IsPurgable = function() return 0 end,
    RemoveOnDeath = function() return 0 end,})

function modifier_item_arcane_gold:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  }
end

function modifier_item_arcane_gold:GetModifierMoveSpeedBonus_Constant()
  return self:GetAbility():GetSpecialValueFor('movespeed')
end

function modifier_item_arcane_gold:GetModifierConstantHealthRegen()
  return self:GetAbility():GetSpecialValueFor('healt_regen')
end

function modifier_item_arcane_gold:OnAttacked(keys)

end


