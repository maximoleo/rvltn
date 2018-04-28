LinkLuaModifier("modifier_boss_grow", "abilities/boss_grow.lua", LUA_MODIFIER_MOTION_NONE)

boss_grow = class({})

function boss_grow:GetIntrinsicModifierName()
    return "modifier_boss_grow"
end

modifier_boss_grow = class({
	IsPassive = function() return true end,
	IsHidden  = function() return false	end	
})

function modifier_boss_grow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_boss_grow:GetModifierDamageOutgoing_Percentage()
	return self:GetParent():GetBaseDamageMax() + self:GetParent():GetHealth()/self:GetParent():GetMaxHealth()
end