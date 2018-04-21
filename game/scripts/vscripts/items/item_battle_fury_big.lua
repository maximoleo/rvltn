LinkLuaModifier("modifier_maim", "modifiers/modifier_maim.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bf","items/item_battle_fury_big.lua", LUA_MODIFIER_MOTION_NONE)


item_battle_fury_big = class({})
			
function item_battle_fury_big:GetIntrinsicModifierName()
    return "modifier_bf"
end
modifier_bf = class({
	IsPassive = function() return true end,
	IsHidden  = function() return true	end	
})
function modifier_bf:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,	
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,	
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,	
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,	
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, 
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED  
	}
end

function modifier_bf:OnAttackLanded(keys)
	local damage = keys.damage
	if keys.attacker == self:GetParent() then
		if keys.target:IsCreep() then
			ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = keys.damage * (self:GetAbility():GetSpecialValueFor("quelling_bonus") - 100)/100, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility()})
			damage =  keys.damage * self:GetAbility():GetSpecialValueFor("quelling_bonus")/100
		end
		
		if not keys.attacker:IsRangedAttacker() then	
			DoCleaveAttack(keys.attacker, keys.target, self:GetAbility(), damage * self:GetAbility():GetSpecialValueFor("cleave_percent")/100,  self:GetAbility():GetSpecialValueFor("cleave_starting_width"), self:GetAbility():GetSpecialValueFor("cleave_ending_width"), self:GetAbility():GetSpecialValueFor("cleave_distance"), "particles/items_fx/battlefury_cleave.vpcf" )
		end
		if RollPercentage(self:GetAbility():GetSpecialValueFor("maim_chance")) then
			keys.target:AddNewModifier(keys.caster, self:GetAbility(), "modifier_maim", {duration = self:GetAbility():GetSpecialValueFor("maim_duration")})
		end		
	end
end				

function modifier_bf:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor('bonus_damage')
end

function modifier_bf:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end

function modifier_bf:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end

function modifier_bf:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end

function modifier_bf:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor('bonus_movement_speed')
end

function modifier_bf:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor('spell_amp')
end

function modifier_bf:GetModifierPercentageManacost()
	return self:GetAbility():GetSpecialValueFor('manacost_reduction')
end

function modifier_bf:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
end
