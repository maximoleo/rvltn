LinkLuaModifier("modifier_item_gang_gold", "items/item_gang_gold.lua", LUA_MODIFIER_MOTION_NONE)


item_gang_gold = class({})

			
function item_gang_gold:GetIntrinsicModifierName()
    return "modifier_item_gang_gold"
end

modifier_item_gang_gold = class({
	IsPassive = function() return true end,
	IsHidden  = function() return true	end	
})

function modifier_item_gang_gold:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED  
	}
end


function modifier_item_gang_gold:OnAttackLanded(keys)
	if keys.attacker:IsHero() and self:GetAbility():IsCooldownReady() then
		if keys.attacker:IsRangedAttacker() then
			keys.attacker:AddExperience(self:GetAbility():GetSpecialValueFor("eph_ranged"), 0, false, false)
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
        	Gold:AddGold(keys.attacker, self:GetAbility():GetSpecialValueFor("gph_ranged"))
        else
        	keys.attacker:AddExperience(self:GetAbility():GetSpecialValueFor("eph"), 0, false, false)
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
        	Gold:AddGold(keys.attacker, self:GetAbility():GetSpecialValueFor("gph_meele"))
        end
	end
end