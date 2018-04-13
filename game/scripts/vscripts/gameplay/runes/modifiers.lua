--illusion

modifier_rune_doubledamage = class({
		GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
		IsPurgable = function() return false end,
		GetTexture = function() return "rune_doubledamage" end,
		GetEffectName = function() return "particles/generic_gameplay/rune_doubledamage_owner.vpcf" end
	})

function modifier_rune_doubledamage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_rune_doubledamage:GetModifierBaseDamageOutgoing_Percentage()
	return 100
end



------------------------------------------------------------------------------------------------------------
modifier_rune_haste = class({
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
	IsPurgable          = function() return false end,
	GetTexture          = function() return "rune_haste" end,
	GetEffectName       = function() return "particles/generic_gameplay/rune_haste_owner.vpcf" end,
})

function modifier_rune_haste:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
end

function modifier_rune_haste:GetModifierMoveSpeed_Max()
	return self.max_speed or self:GetSharedKey("max_speed") or 0
end

function modifier_rune_haste:GetModifierMoveSpeed_Limit()
	return self.max_speed or self:GetSharedKey("max_speed") or 0
end

function modifier_rune_haste:GetModifierMoveSpeed_Absolute()
	return 625
end

if IsServer() then
	function modifier_rune_haste:OnCreated()
		self:StartIntervalThink(0.2)
		self:OnIntervalThink()
	end

	function modifier_rune_haste:OnIntervalThink()
		self.max_speed = self:GetParent():GetMaxMovementSpeed()
		self:SetSharedKey("max_speed", self.max_speed)
	end
end


-------------------------------------------------------------------------------------------------------
modifier_rune_arcane = class({
		GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
		IsPurgable = function() return false end,
		GetTexture = function() return "rune_arcane" end,
		GetEffectName = function() 	return "particles/generic_gameplay/rune_arcane_owner.vpcf" end 
	})

function modifier_rune_arcane:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
end

function modifier_rune_arcane:GetModifierPercentageCooldown()
	return 30
end


---------------------------------------------------------------------------------------------------------


modifier_rune_invisibility = class({
		IsPurgable = function() return false end,
		GetTexture = function() return "rune_invis" end,
		GetModifierInvisibilityLevel = function() return 1 end
	})

function modifier_rune_invisibility:CheckState() 
	return {
		[MODIFIER_STATE_INVISIBLE] = true
	}
end

function modifier_rune_invisibility:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ATTACK
	}
end
if IsServer() then
	function modifier_rune_invisibility:OnAbilityExecuted(keys)
		if keys.unit == self:GetParent() then
			self:Destroy()
		end
	end

	function modifier_rune_invisibility:OnAttack(keys)
		if keys.attacker == self:GetParent() then
			self:Destroy()
		end
	end
end

------------------------------------------------------------------------------------------------------------


modifier_rune_regeneration = class({
		GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
		IsPurgable = function() return false end,
		GetTexture = function() return "rune_regen" end
	})

function modifier_rune_regeneration:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE 
	}
end

function modifier_rune_regeneration:GetModifierTotalPercentageManaRegen()
	return 12
end

function modifier_rune_regeneration:GetModifierHealthRegenPercentage()
	return 10
end
