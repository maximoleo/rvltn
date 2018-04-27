LinkLuaModifier("modifier_item_shield_of_abyssal", "items/item_shield_of_abyssal.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shield_cooldown", "items/item_shield_of_abyssal.lua", LUA_MODIFIER_MOTION_NONE)

item_shield_of_abyssal = class({})
			
function item_shield_of_abyssal:GetIntrinsicModifierName()
    return "modifier_item_shield_of_abyssal"
end

function item_shield_of_abyssal:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_shield_cooldown") then
      return "custom/item_shield_of_abyssal_inactive"
    else
        return "custom/item_shield_of_abyssal"
    end
end

function item_shield_of_abyssal:OnSpellStart()
 	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_item_crimson_guard_extra",{duration = self:GetSpecialValueFor("crimson_duration")}) 
    for _,v in pairs (FindUnitsInRadius(self:GetCaster():GetTeam(),self:GetCaster():GetAbsOrigin(),nil,self:GetSpecialValueFor("crimson_radius"), 1, 19, 32832, 0, false)) do
    	v:AddNewModifier(self:GetCaster(),self,"modifier_item_crimson_guard_extra",{duration = self:GetSpecialValueFor("crimson_duration")})
    end
end


modifier_item_shield_of_abyssal = class({
	IsPassive = function() return true end,
	IsHidden  = function() return true	end	
})

function modifier_item_shield_of_abyssal:OnAttacked(keys)
	if keys.target==self:GetParent() and not keys.target:HasModifier("modifier_shield_cooldown") then
		keys.attacker:AddNewModifier(keys.target,self:GetAbility(),"modifier_stunned",{duration = self:GetAbility():GetSpecialValueFor("shield_stun")})
		ParticleManager:CreateParticle("particles/items_fx/abyssal_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		keys.attacker:EmitSound("DOTA_Item.AbyssalBlade.Activate")
		keys.target:AddNewModifier(keys.target,self:GetAbility(),"modifier_shield_cooldown",{duration = self:GetAbility():GetSpecialValueFor("shield_cooldown")})
	end
end

modifier_shield_cooldown = class({
	IsPassive = function() return true end,
	IsHidden  = function() return false	end,
	IsPurgable = function() return false end
})

function modifier_shield_cooldown:OnDestroy()
	self:GetParent():EmitSound("DOTA_Item.Buckler.Activate")
end	




function modifier_item_shield_of_abyssal:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_ATTACKED
	}
end


function modifier_item_shield_of_abyssal:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end


--2 stum being attaked
--3 damage block