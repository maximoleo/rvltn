LinkLuaModifier("modifier_fountain_aura_custom","gameplay/borders/fountain.lua", LUA_MODIFIER_MOTION_NONE)



function CummingInFountain(trigger)
	if trigger.activator:GetAbsOrigin().x > 0 then
		if trigger.activator:GetTeam() == DOTA_TEAM_GOODDUYS then
			PutHeal(trigger)
		elseif trigger.activator:GetTeam() == DOTA_TEAM_BADGUYS or trigger.activator:GetTeam() == DOTA_TEAM_NEUTRALS then
			Attack(trigger, "dire")
		end
	else
		if trigger.activator:GetTeam() == DOTA_TEAM_BADGUYS or trigger.activator:GetTeam() == DOTA_TEAM_NEUTRALS then
			Attack(trigger, "radiant")
		elseif trigger.activator:GetTeam() == DOTA_TEAM_GOODGUYS then
			PutHeal(trigger)
		end
	end
end

function PutHeal(trigger)
	trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_fountain_aura_custom", nil)
	Timers:RemoveTimer("fountain_timer"..trigger.activator:GetPlayerID())

end

function EndHeal(trigger)
	Timers:CreateTimer("fountain_timer"..trigger.activator:GetPlayerID(),{
    endTime = 3,
    callback = function()
    	trigger.activator:RemoveModifierByName("modifier_fountain_aura_custom")
    end
  	})
end

function Attack(trigger, team)
	Entities:FindByName(nil, "Fountain_".. team):SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	Entities:FindByName(nil, "Fountain_".. team):SetAttacking(trigger.activator)
end

-- +dire -radiant
function GoingOutOfFountain(trigger)
	if not trigger.activator:HasModifier("modifier_fountain_aura_custom") then
		if trigger.activator:GetTeam() == DOTA_TEAM_BADGUYS then
			Entities:FindByName(nil, "Fountain_radiant"):SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
		end
	end
	EndHeal(trigger)
end

modifier_fountain_aura_custom = class({
	GetTexture = function() return "fountain_heal" end
	})

function modifier_fountain_aura_custom:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE 
	}
end

function modifier_fountain_aura_custom:GetModifierTotalPercentageManaRegen()

	return 12
end

function modifier_fountain_aura_custom:GetModifierHealthRegenPercentage()
	return 10
end