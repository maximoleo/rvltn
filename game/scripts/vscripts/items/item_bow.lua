LinkLuaModifier("modifier_item_bow","items/item_bow.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bow_up","items/item_bow.lua", LUA_MODIFIER_MOTION_NONE)

item_bow = class({
	})

function item_bow:GetIntrinsicModifierName()
    return "modifier_item_bow"
end

modifier_item_bow = class({	  
	IsHidden = function() return true end,
	IsDebuff = function() return false end,
	IsPurgable = function() return false end,
	RemoveOnDeath = function() return false end,
})


function modifier_item_bow:DeclareFunctions()
    return {       
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED  	
    }
end

function item_bow:OnProjectileHit(target)
		local itemcount = 0
		for i = 0, 5 do
			if self:GetCaster():GetItemInSlot(i) and self:GetCaster():GetItemInSlot(i):GetName() == self:GetName() then
				itemcount = itemcount + 1
			end
		end
		ApplyDamage({attacker = self:GetCaster(), victim = target, damage_type = DAMAGE_TYPE_PHYSICAL, damage = self:GetCaster():GetAverageTrueAttackDamage(target) * (self:GetSpecialValueFor("damage_percent") / 100) * itemcount, ability = self})
end 


function modifier_item_bow:OnAttack(keys)
	if keys.attacker == self:GetParent() then
		if keys.attacker:IsRangedAttacker() then
			for _,v in ipairs(FindUnitsInRadius(keys.attacker:GetTeam(), keys.target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)) do
				if v ~= keys.attacker:GetAttackTarget() and not v:IsAttackImmune() then
					local projectile = 
					{
						Source = keys.attacker,
						Ability = self:GetAbility(),
						vSourceLoc = keys.attacker:GetAbsOrigin(),
						iMoveSpeed = keys.attacker:GetProjectileSpeed(),
						bReplaceExisting = false,
					}
					if keys.force_attack_projectile then
						projectile["EffectName"] = keys.force_attack_projectile
					else
						projectile["EffectName"] = keys.attacker:GetRangedProjectileName()
					end
					projectile["Target"] = v
					ProjectileManager:CreateTrackingProjectile(projectile)
				end
			end
		end	
	end
	if RollPercentage(self:GetAbility():GetSpecialValueFor("maim_chance")) then
		keys.target:AddNewModifier(keys.caster, self:GetAbility(), "modifier_maim", {duration = self:GetAbility():GetSpecialValueFor("maim_duration")})
	end		
end

function modifier_item_bow:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor('bonus_damage')
end

function modifier_item_bow:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end

function modifier_item_bow:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end

function modifier_item_bow:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end


---------------------------------------------------------------------
item_bow_2 = class({
	OnProjectileHit = item_bow.OnProjectileHit,
	})


function item_bow_2:GetIntrinsicModifierName()
    return "modifier_item_bow_up"
end


modifier_item_bow_up = class({	  
	IsHidden = function() return true end,
	IsDebuff = function() return false end,
	IsPurgable = function() return false end,
	RemoveOnDeath = function() return false end,
})

function modifier_item_bow_up:DeclareFunctions()
    return {       		
    	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,	
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,	
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,	
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,	
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, 
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK 	
    }
end


function modifier_item_bow_up:OnAttack(keys)
	if keys.attacker == self:GetParent() then
		if keys.attacker:IsRangedAttacker() then
			for _,v in ipairs(FindUnitsInRadius(keys.attacker:GetTeam(), keys.target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)) do
				if v ~= keys.attacker:GetAttackTarget() and not v:IsAttackImmune() then
					local projectile = 
					{
						Source = keys.attacker,
						Ability = self:GetAbility(),
						vSourceLoc = keys.attacker:GetAbsOrigin(),
						iMoveSpeed = keys.attacker:GetProjectileSpeed(),
						bReplaceExisting = false,
					}
					if keys.force_attack_projectile then
						projectile["EffectName"] = keys.force_attack_projectile
					else
						projectile["EffectName"] = keys.attacker:GetRangedProjectileName()
					end
					projectile["Target"] = v
					ProjectileManager:CreateTrackingProjectile(projectile)
				end
			end
		end	
	end
end

function modifier_item_bow_up:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor('bonus_damage')
end

function modifier_item_bow_up:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end

function modifier_item_bow_up:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end

function modifier_item_bow_up:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end

function modifier_item_bow_up:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor('bonus_movement_speed')
end

function modifier_item_bow_up:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor('spell_amp')
end

function modifier_item_bow_up:GetModifierPercentageManacost()
	return self:GetAbility():GetSpecialValueFor('manacost_reduction')
end

function modifier_item_bow_up:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
end
