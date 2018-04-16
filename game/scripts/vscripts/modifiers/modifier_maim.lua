modifier_maim = class({
		GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
		IsPurgable = function() return false end,
	})

function modifier_maim:GetTexture () 
	return self:GetAbility():GetTexture() 
end


function modifier_maim:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_maim:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor("maim_slow_attack_ranged")
	else
		return self:GetAbility():GetSpecialValueFor("maim_slow_attack")
	end
end

function modifier_maim:GetModifierMoveSpeedBonus_Percentage()
		if self:GetCaster():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor("maim_slow_movement_ranged")
	else
		return self:GetAbility():GetSpecialValueFor("maim_slow_movement")
	end
end