LinkLuaModifier("modifier_item_talon_gold", "items/item_talon_gold.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_talon_creep_buff", "items/item_talon_gold.lua", LUA_MODIFIER_MOTION_NONE)


item_talon_gold = class({})
			
function item_talon_gold:GetIntrinsicModifierName()
    return "modifier_item_talon_gold"
end

modifier_item_talon_gold = class({
	IsPassive = function() return true end,
	IsHidden  = function() return true	end	
})

function item_talon_gold:OnSpellStart()
	target = self:GetCursorTarget()
	if target:IsCreep() then
		target:AddNewModifier(self:GetCaster(), self, "modifier_talon_creep_buff", nil)
		target:SetRenderColor(255,215,0)
		target:SetMaximumGoldBounty(target:GetMaximumGoldBounty()*self:GetSpecialValueFor("inc_gold_for_creep")/100)
		target:SetMinimumGoldBounty(target:GetMinimumGoldBounty()*self:GetSpecialValueFor("inc_gold_for_creep")/100)
		target:SetDeathXP(target:GetDeathXP()*self:GetSpecialValueFor("inc_exp_for_creep")/100)
		target:SetBaseMaxHealth(target:GetBaseMaxHealth()*self:GetSpecialValueFor("inc_HP_for_creep")/100)
		target:SetMaxHealth(math.max(1,target:GetMaxHealth()*self:GetSpecialValueFor("inc_HP_for_creep")/100))
		target:SetHealth(target:GetMaxHealth())
		target:SetBaseDamageMin(target:GetBaseDamageMin()*self:GetSpecialValueFor("inc_damage_for_creep")/100)
		target:SetBaseDamageMax(target:GetBaseDamageMax()*self:GetSpecialValueFor("inc_damage_for_creep")/100)
		target:SetPhysicalArmorBaseValue(target:GetPhysicalArmorBaseValue()*self:GetSpecialValueFor("inc_armor_for_creep")/100)
		target:SetBaseMoveSpeed(target:GetBaseMoveSpeed()*self:GetSpecialValueFor("inc_movespeed_for_creep")/100)
	else
		target:CutDown()
	end	
end

function modifier_item_talon_gold:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_item_talon_gold:OnAtackLanded(keys)
	local damage = keys.damage
	if keys.attacker == self:GetParent() then
		if keys.target:IsCreep() then
			if keys.attacker:IsRangedAttacker() then
				ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = keys.damage * (self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged") - 100)/100, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility()})
				damage =  keys.damage * self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")/100
			else
				ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = keys.damage * (self:GetAbility():GetSpecialValueFor("quelling_bonus") - 100)/100, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility()})
				damage =  keys.damage * self:GetModifierPhysicalArmorBonusbility():GetSpecialValueFor("quelling_bonus")/100
			end
		end
	end
end

function modifier_item_talon_gold:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor('armor')
end


modifier_talon_creep_buff = class({
	IsPassive = function() return true end,
	IsHidden  = function() return false	end	
})

function modifier_talon_creep_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	}
end

function modifier_talon_creep_buff:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end

function modifier_talon_creep_buff:GetTexture()
	if self:GetAbility() then
		self.texture = "custom/"..self:GetAbility():GetName()
	end
	return self.texture 
end

function modifier_talon_creep_buff:GetAbsoluteNoDamageMagical()
	return 1
end