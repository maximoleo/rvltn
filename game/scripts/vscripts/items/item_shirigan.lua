LinkLuaModifier("modifier_item_shirigan", "items/item_shirigan.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_shirigan_active", "items/item_shirigan.lua", LUA_MODIFIER_MOTION_NONE)


item_shirigan = class({})
			
function item_shirigan:GetIntrinsicModifierName()
    return "modifier_item_shirigan"
end

function item_shirigan:OnSpellStart()
	
	if self.mod:GetStackCount() == 2 then
		self.mod:SetStackCount(1)
		local mana = self:GetCaster():GetMaxMana() - self:GetCaster():GetMana()
		self:GetCaster():RemoveModifierByName("modifier_item_shirigan_active")
		mana = self:GetCaster():GetMaxMana() - mana
		if mana > 0 then
			self:GetCaster():SetMana(mana)
		else
			self:GetCaster():SetMana(0)
		end	
		self.mod.charger = 1
	else
		self.mod:SetStackCount(2)
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_shirigan_active", nil)
		self.mod.charger = 2
	end
end

function item_shirigan:GetAbilityTextureName()
	if not self.mod:IsNull() and self.mod:GetStackCount() == 2 then
		return "custom/item_shirigan_active"
	else
		return "custom/item_shirigan_inactive"
	end
	return "custom/item_shirigan_inactive"
end


modifier_item_shirigan = class({

	IsPassive = function() return true end,
	IsHidden  = function() return true	end	
})

function modifier_item_shirigan:OnCreated()
	if self:GetAbility() then
		self:GetAbility().mod = self
	end
	self:SetStackCount(1)
	self.charges = 1
end

function modifier_item_shirigan:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,    
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,  
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,

	}
end

function modifier_item_shirigan:OnDestroy()
	for i = 0, 100000 do
	end
    if not self:IsNull() and not self:GetCaster():IsNull() and self:GetCaster():HasModifier("modifier_item_shirigan_active") then
		self:GetCaster():RemoveModifierByName("modifier_item_shirigan_active")
	end
end

modifier_item_shirigan_active = class({

	IsPassive = function() return true end,
	IsHidden  = function() return true	end	
})



function modifier_item_shirigan_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end


function modifier_item_shirigan_active:GetModifierBonusStats_Intellect()

		return self:GetAbility():GetSpecialValueFor('bonus_int')
end

function modifier_item_shirigan_active:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor('spell_amp')
end

function modifier_item_shirigan_active:GetModifierPercentageManacost()
	return self:GetAbility():GetSpecialValueFor('manacost')
end





function modifier_item_shirigan:GetModifierConstantManaRegen()
	if self:GetStackCount() == 2 then
		return self:GetAbility():GetSpecialValueFor('mana_degen')
	else
		return  self:GetAbility():GetSpecialValueFor('bonus_mana_regen')
	end
end

function modifier_item_shirigan:GetModifierCastRangeBonus()
	return self:GetAbility():GetSpecialValueFor('cast_range')
end
