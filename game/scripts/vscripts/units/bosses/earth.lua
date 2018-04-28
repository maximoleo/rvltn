LinkLuaModifier("modifier_boss_cooldowns", "modifiers/modifier_boss_cooldowns.lua", LUA_MODIFIER_MOTION_NONE)


function Spawn(entityKeyValues)
	if thisEntity == nil then 
		return
	end
	thisEntity.abilities = {}
	thisEntity.abilities[1] = thisEntity:FindAbilityByName("tiny_avalanche")
	thisEntity.abilities[2] = thisEntity:FindAbilityByName("earthshaker_fissure")
	thisEntity.abilities[3] = thisEntity:FindAbilityByName("elder_titan_earth_splitter")
	thisEntity.abilities[4] = thisEntity:FindAbilityByName("sandking_burrowstrike")
	thisEntity:SetContextThink( "EarthThink", EarthThink, 1 )
end

function EarthThink()
	if GameRules:IsGamePaused() == true then
		return 1
  	end
  	if not thisEntity.Found then
		thisEntity.SpawnPos = thisEntity:GetAbsOrigin()
    	thisEntity.Found = true
  	end

  	local distance = (thisEntity:GetAbsOrigin() - thisEntity.SpawnPos):Length2D()

  	if distance > 2000 then
  		return RetreatHome()
  	end

  	local enemies = FindUnitsInRadius(thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, FIND_CLOSEST, false )	
  	
	if enemies[1] and not thisEntity:HasModifier("modifier_boss_cooldowns") then
	return EarthCastSpell(enemies)
	end	
  	return 1
end


function EarthCastSpell(enemies)
	local max = 1
	local ab = {}
	for i = 1, 4 do
		if thisEntity and thisEntity.abilities[i]:IsCooldownReady() then
			ab[max] = i
			max = max + 1
		end
	end
	if ab[max-1] then
		local num =  math.random(1,max - 1)
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = thisEntity.abilities[ab[num]]:entindex(),
			Position = enemies[1]:GetOrigin(),
			Queue = false,
		})
		thisEntity:AddNewModifier(thisEntity, nil, "modifier_boss_cooldowns", {duration = 5})	
		return 3
	end

end
