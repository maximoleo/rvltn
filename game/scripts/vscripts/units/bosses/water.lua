LinkLuaModifier("modifier_boss_cooldowns", "modifiers/modifier_boss_cooldowns.lua", LUA_MODIFIER_MOTION_NONE)


function Spawn(entityKeyValues)
	if thisEntity == nil then 
		return
	end
	thisEntity.abilities = {}
	thisEntity.abilities[1] = thisEntity:FindAbilityByName("morphling_waveform")
	thisEntity.abilities[2] = thisEntity:FindAbilityByName("kunkka_torrent")
	thisEntity.abilities[3] = thisEntity:FindAbilityByName("cold_area")
	thisEntity.abilities[4] = thisEntity:FindAbilityByName("naga_siren_ensnare")
	thisEntity.abilities[5] = thisEntity:FindAbilityByName("tidehunter_anchor_smash")
	thisEntity.abilities[6] = thisEntity:FindAbilityByName("lich_chain_frost")
	thisEntity.abilities[7] = thisEntity:FindAbilityByName("kunkka_ghostship")

	thisEntity:SetContextThink( "WaterThink", WaterThink, 1 )
end
--кастует спелл. накладывает модифаер, сделать:
--расставить спелы
--комбо
--



--for watterboss,torent wave cold 1 2 3, naga 4 anc 5, chyajnic and ship should be 6 and 7 
function WaterThink()
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
  	if thisEntity.castship and thisEntity.castship == true	then
  		return Castship()
  	end
	thisEntity.castship = false

  	local enemies = FindUnitsInRadius(thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, FIND_CLOSEST, false )	
  	
	if enemies[1] and not thisEntity:HasModifier("modifier_boss_cooldowns") then
		return WaterCastSpell(enemies)
	end	
  	return 1
end

function RetreatHome()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.SpawnPos
  })
  return 6
end

function WaterCastSpell(enemies)
	local max = 0
	local ab = {}
	for _,v in pairs(enemies) do
		max = max + 1
	end
	if max > 1 and thisEntity.abilities[6]:IsCooldownReady() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			AbilityIndex = thisEntity.abilities[6]:entindex(),
			Queue = false,
		})
		thisEntity:AddNewModifier(thisEntity, nil, "modifier_boss_cooldowns", {duration = 3})	
		return 3
	end
	max = 1
	for i = 1, 5 do
		if thisEntity and thisEntity.abilities[i]:IsCooldownReady() then
			ab[max] = i
			max = max + 1
		end
	end
	if ab[max-1] then
		local num =  math.random(1,max - 1)
		if ab[num] < 3 then
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = thisEntity.abilities[ab[num]]:entindex(),
				Position = enemies[1]:GetOrigin(),
				Queue = false,
			})
			thisEntity:AddNewModifier(thisEntity, nil, "modifier_boss_cooldowns", {duration = 3})	

			return 3
		elseif ab[num] == 3 then 
			local place = Vector(0,0,0)
			local amount = 0

			for _,v in pairs(enemies) do
				place = place + v:GetAbsOrigin()
				amount = amount + 1
			end
			place = place / amount
			thisEntity.shippoint = place
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = thisEntity.abilities[ab[num]]:entindex(),
				Position = place,
				Queue = false,
			})		
			thisEntity:AddNewModifier(thisEntity, nil, "modifier_boss_cooldowns", {duration = 5})

			return 1
		elseif ab[num] == 4 then
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = enemies[1]:entindex(),
				AbilityIndex = thisEntity.abilities[ab[num]]:entindex(),
				Queue = false,
			})
			thisEntity:AddNewModifier(thisEntity, nil, "modifier_boss_cooldowns", {duration = 3})
			return 1
		elseif ab[num] == 5 then
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = thisEntity.abilities[ab[num]]:entindex(),
				Queue = false,
			})
			thisEntity:AddNewModifier(thisEntity, nil, "modifier_boss_cooldowns", {duration = 3})

			return 1
		end
	end

end

function Castship()
	local place = Vector(0,0,0)
	local amount = 0
	for _,v in pairs(FindUnitsInRadius(thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, FIND_CLOSEST, false )	) do
		if v:HasModifier("modifier_cold_area") then
			place = place + v:GetAbsOrigin()
			amount = amount + 1
		end
	end
	place = place / amount
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.abilities[7]:entindex(),
		Position = place,
		Queue = false,
	})
	thisEntity:AddNewModifier(thisEntity, nil, "modifier_boss_cooldowns", {duration = 3})
	thisEntity.castship = false
	return 1
end