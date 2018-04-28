LinkLuaModifier("modifier_item_meca_2", "items/item_meca_2.lua", LUA_MODIFIER_MOTION_NONE)


item_meca_2 = class({})
			
function item_meca_2:GetIntrinsicModifierName()
    return "modifier_item_meca_2"
end


function item_meca_2:OnSpellStart()
	if self:GetCaster():IsIllusion() or self:GetCaster():IsTempestDouble() or self:GetCaster():IsClone() then
      return
    end
    for _,v in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), 1, 19, 32832, 0, false)) do
		local mana = v:GetMaxMana()*self:GetSpecialValueFor("mana")/100
		v:GiveMana(mana)
		v:SetHealth(v:GetHealth() + v:GetMaxHealth()*self:GetSpecialValueFor("health")/100)
		local particleManaGain = ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
   		ParticleManager:SetParticleControl(particleManaGain, 1, v:GetOrigin())
   		ParticleManager:SetParticleControl(particleManaGain, 2, v:GetOrigin())		
   		ParticleManager:ReleaseParticleIndex(particleManaGain)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, v, mana, nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, v, v:GetMaxHealth()*self:GetSpecialValueFor("health")/100, nil)

	  end
	  self:GetCaster():GiveMana(self:GetSpecialValueFor("mana"))
    self:GetCaster():EmitSound("DOTA_Item.ArcaneBoots.Activate")
end


modifier_item_meca_2 = class({
	IsPassive = function() return true end,
	IsHidden  = function() return true	end	
})

function modifier_item_meca_2:DeclareFunctions()
	return {
	}
end


function modifier_item_meca_2:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end