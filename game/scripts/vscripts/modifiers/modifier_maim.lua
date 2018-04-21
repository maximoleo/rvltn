modifier_maim = class({
		GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
		IsPurgable = function() return false end,
	})

function modifier_maim:GetTexture ()
	if self:GetAbility() then 
		self.last = self:GetAbility():GetName()
		return "custom/".. self:GetAbility():GetName() 
	else
		return "custom/".. self.last
	end
end


function modifier_maim:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_maim:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		if self:GetCaster() and self:GetCaster():IsRangedAttacker() then
			self.attack = self:GetAbility():GetSpecialValueFor("maim_slow_attack_ranged")
			return self:GetAbility():GetSpecialValueFor("maim_slow_attack_ranged")
		else
			self.attack = self:GetAbility():GetSpecialValueFor("maim_slow_attack")
			return self:GetAbility():GetSpecialValueFor("maim_slow_attack")
		end
	else
		return self.attack
	end 
end

function modifier_maim:GetModifierMoveSpeedBonus_Percentage()
	if self:GetAbility() then
		if self:GetCaster() and self:GetCaster():IsRangedAttacker() then
			self.ms = self:GetAbility():GetSpecialValueFor("maim_slow_movement_ranged")
			return self:GetAbility():GetSpecialValueFor("maim_slow_movement_ranged")
		else
			self.ms = self:GetAbility():GetSpecialValueFor("maim_slow_movement")
			return self:GetAbility():GetSpecialValueFor("maim_slow_movement")
		end
	else
		return self.ms
	end
end