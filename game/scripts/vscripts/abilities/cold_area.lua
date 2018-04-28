
LinkLuaModifier("modifier_cold_area", "abilities/cold_area.lua", LUA_MODIFIER_MOTION_NONE)


cold_area = class({})
	

function cold_area:OnSpellStart()
	Timers:CreateTimer({
	   	endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
	   	callback = function()
	   		for _,v in pairs(FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster().shippoint, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)) do						
				v:AddNewModifier(self:GetCaster(), self, "modifier_cold_area", {duration = 20})
				if not self:GetCaster().castship then self:GetCaster().castship = true end
			end
	   	end
	}) 	
  	
end

modifier_cold_area = class({
	IsPassive = function() return true end,
	IsHidden  = function() return false	end	
})

function modifier_cold_area:DeclareFunctions()
	return {
	}
end
