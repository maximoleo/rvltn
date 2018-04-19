LinkLuaModifier("modifier_duffusal_slow", "items/item_diffusal_2.lua", LUA_MODIFIER_MOTION_NONE)

function purge(keys)
	keys.target:Purge(true, false, false, false, false)
	print("ok")
	keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_duffusal_slow", {duration = keys.ability:GetSpecialValueFor("purge_slow_duration")})
end

function manaburn(keys)
	if keys.attacker:IsIllusion() then
		if keys.attacker:IsRangedAttacker() then
			keys.target:GiveMana(-keys.ability:GetSpecialValueFor("feedback_mana_burn_illusion_ranged"))
			ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = keys.ability:GetSpecialValueFor("feedback_mana_burn_illusion_ranged")*keys.ability:GetSpecialValueFor("damage_per_burn"), damage_type = DAMAGE_TYPE_PHYSICAL, ability = keys.ability})

		else
			keys.target:GiveMana(-keys.ability:GetSpecialValueFor("feedback_mana_burn_illusion_melee"))
			ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = keys.ability:GetSpecialValueFor("feedback_mana_burn_illusion_melee")*keys.ability:GetSpecialValueFor("damage_per_burn"), damage_type = DAMAGE_TYPE_PHYSICAL, ability = keys.ability})
 
		end	
	elseif keys.attacker:IsRealHero() then	
		keys.target:SpendMana(keys.ability:GetSpecialValueFor("feedback_mana_burn"), keys.ability)
		ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = keys.ability:GetSpecialValueFor("feedback_mana_burn")*keys.ability:GetSpecialValueFor("damage_per_burn"), damage_type = DAMAGE_TYPE_PHYSICAL, ability = keys.ability})
	end
end


modifier_duffusal_slow = class({
	IsHidden = function() return 0 end,
    IsPurgable = function() return 0 end,
    RemoveOnDeath = function() return 1 end,
	})

function modifier_duffusal_slow:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  }
end

function modifier_duffusal_slow:GetTexture()
	return self:GetAbility():GetName()
end

function modifier_duffusal_slow:GetModifierMoveSpeedBonus_Constant()
	return -(self:GetCaster():GetIdealSpeed()*self:GetAbility():GetSpecialValueFor("slow_pct")/100)
end