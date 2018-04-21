LinkLuaModifier("modifier_duffusal_slow", "items/item_diffusal_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_diffusal_upgrade", "items/item_diffusal_2.lua", LUA_MODIFIER_MOTION_NONE)





item_diffusal_upgrade = class({})

			
function item_diffusal_upgrade:GetIntrinsicModifierName()
    return "modifier_item_diffusal_upgrade"
end

modifier_item_diffusal_upgrade = class({
	IsPassive = function() return true end,
	IsHidden  = function() return true	end	
})

function item_diffusal_upgrade:OnSpellStart()
	self:GetCursorTarget():Purge(true, false, false, false, false)
	print("ok")
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_duffusal_slow", {duration = self:GetSpecialValueFor("purge_slow_duration")})

end

function modifier_item_diffusal_upgrade:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED  
	}
end

function modifier_item_diffusal_upgrade:OnAttackLanded(keys)
	if keys.attacker:IsIllusion() then
		if keys.attacker:IsRangedAttacker() then
			keys.target:GiveMana(-self:GetAbility():GetSpecialValueFor("feedback_mana_burn_illusion_ranged"))
			ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = self:GetAbility():GetSpecialValueFor("feedback_mana_burn_illusion_ranged")*self:GetAbility():GetSpecialValueFor("damage_per_burn"), damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility()})
		else
			keys.target:GiveMana(-self:GetAbility():GetSpecialValueFor("feedback_mana_burn_illusion_melee"))
			ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = self:GetAbility():GetSpecialValueFor("feedback_mana_burn_illusion_melee")*self:GetAbility():GetSpecialValueFor("damage_per_burn"), damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility()})
		end	
	elseif keys.attacker:IsRealHero() then	
		keys.target:SpendMana(self:GetAbility():GetSpecialValueFor("feedback_mana_burn"), self:GetAbility())
		ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = self:GetAbility():GetSpecialValueFor("feedback_mana_burn")*self:GetAbility():GetSpecialValueFor("damage_per_burn"), damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility()})
	end	
end				

function modifier_item_diffusal_upgrade:GetModifierBonusStats_Agility()
 	return self:GetAbility():GetSpecialValueFor('bonus_agility')

end

function modifier_item_diffusal_upgrade:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor('bonus_intellect')
end

modifier_duffusal_slow = class({
	IsHidden = function() return false end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end,
	})

function modifier_duffusal_slow:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  }
end

function modifier_duffusal_slow:GetTexture()
	return "custom/".. self:GetAbility():GetName()
end

function modifier_duffusal_slow:GetModifierMoveSpeedBonus_Constant()
	return -(self:GetCaster():GetIdealSpeed()*self:GetAbility():GetSpecialValueFor("slow_pct")/100)
end