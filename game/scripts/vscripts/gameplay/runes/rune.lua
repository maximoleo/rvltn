LinkLuaModifier("modifier_rune_doubledamage", "gameplay/runes/modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rune_haste", "gameplay/runes/modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rune_arcane", "gameplay/runes/modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rune_invisibility", "gameplay/runes/modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rune_regeneration", "gameplay/runes/modifiers.lua", LUA_MODIFIER_MOTION_NONE)

AMOUNT_OF_RUNES = 2
RUNE_TYPES = 6
function Enable_Rune_Spawn()
	local repeat_interval = 120
    local start_after = 0
    Timers:CreateTimer(start_after, function()
        Spawn_Rune()
        return repeat_interval
    end)
end
RuneStats = 
{
	[0] = {
		model = "models/props_gameplay/rune_goldxp.vmdl",
		particle = "particles/arena/generic_gameplay/rune_bounty.vpcf",
		sound = "Rune.Bounty",
		duration = 45,
		damage_pct = 100,
		gold = 100,
		xp = 200,
		name = "bounty" 
	},
	[1] = {
		model = "models/props_gameplay/rune_doubledamage01.vmdl",
		particle = "particles/arena/generic_gameplay/rune_doubledamage.vpcf",
		sound = "Rune.DD",
		duration = 45,
		damage_pct = 100,
		name = "doubledamage"	
	},
	[2] = {
		model = "models/props_gameplay/rune_haste01.vmdl",
		particle = "particles/generic_gameplay/rune_haste.vpcf",
		sound = "Rune.Haste",
		duration = 25,
		movespeed = 625,
		name = "haste"
	},
	[3] = {
		model = "models/props_gameplay/rune_arcane.vmdl",
		particle = "particles/generic_gameplay/rune_arcane.vpcf",
		sound = "Rune.Arcane",
		duration = 50,
		cooldown_reduction = 30, --Tooltip
		spell_amplify = 50,
		name = "arcane"
	},
	[4] = {
		model = "models/props_gameplay/rune_illusion01.vmdl",
		particle = "particles/generic_gameplay/rune_illusion.vpcf",
		sound = "Rune.Illusion",
		duration = 75,
		illusion_count = 2,
		illusion_outgoing_damage = 35,
		illusion_incoming_damage = 200
	},
	[5] = {
		model = "models/props_gameplay/rune_invisibility01.vmdl",
		particle = "particles/generic_gameplay/rune_invisibility.vpcf",
		sound = "Rune.Invis",
		duration = 60,
		name = "invisibility"
	},
	[6] = {
		model = "models/props_gameplay/rune_regeneration01.vmdl",
		particle = "particles/generic_gameplay/rune_regeneration.vpcf",
		sound = "Rune.Regen",
		name = "regeneration"
	}
}

Runes = {}

function Find_Runes()
	for i = 1, AMOUNT_OF_RUNES
	do
		Runes[i] = Entities:FindByName(Runes[i-1], "rune_spawner_" .. tostring(i))
		Runes[i].rune = {}	
		Runes[i].rune.runetype = -1
		--dd,haste,arcane,illusion,inviz,regen

	end
end

function Spawn_Rune()
	for i = 1,AMOUNT_OF_RUNES 
	do
		if (Runes[i].rune ~= nil) then 
			if Runes[i].rune.runetype ~= -1 then
				if not(Runes[i].rune:IsNull()) then
					Runes[i].rune:RemoveSelf()
				end
			end
		end
		Runes[i].rune = CreateUnitByName("rune_custom", Runes[i]:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
		if i > 0 then
			--Runes[i].rune.runetype = math.random(1,RUNE_TYPES)
			Runes[i].rune.runetype = 5
		end
		Runes[i].rune:SetModel(RuneStats[Runes[i].rune.runetype].model)
		Runes[i].rune:SetOriginalModel(RuneStats[Runes[i].rune.runetype].model)
	end
end
	
function BottleCheck(hero, runetype)
	local puted = false
	for i = 0,5 
	do
		if hero:GetItemInSlot(i) then
			if hero:GetItemInSlot(i):GetName() == "item_bottle_custom" then
				if hero:GetItemInSlot(i).mod:GetStackCount() < 4 then
					hero:GetItemInSlot(i):PutInBottle(runetype)
					puted = true
					break
				else
					break
				end

			end
		end
	end
	return puted
end

function ActivateRune(unit, runetype)
	if runetype ~= 4 and runetype ~= 0 then
		unit:AddNewModifier(unit, nil,"modifier_rune_".. RuneStats[runetype]["name"], RuneStats[runetype])
		print("modifier_rune_".. RuneStats[runetype]["name"])
	else

	end
end

function WhatToDoRunes(order)
	if order.units["0"] and (order.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or order.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET) then
		local unit = EntIndexToHScript(order.units["0"])
		local rune = EntIndexToHScript(order.entindex_target)
		print(rune:GetUnitName(), "chlen")
		if rune:GetUnitName() == "rune_custom" then
			if IsValidEntity(unit) and IsValidEntity(rune) then
			order.order_type = DOTA_UNIT_ORDER_MOVE_TO_POSITION
			order.position_x = rune:GetAbsOrigin().x
			order.position_y = rune:GetAbsOrigin().y
			order.position_z = rune:GetAbsOrigin().z
			if unit:IsRealHero() then
				local issuerID = order.issuer_player_id_const
				Containers.rangeActions[order.units["0"]] = {
					unit = unit,
					position = rune:GetAbsOrigin(),
					range = 100,
					playerID = issuerID,
					action = function()
						if IsValidEntity(unit) and IsValidEntity(rune) then
							rune:RemoveSelf()
							unit:Stop()
							if not BottleCheck(unit, rune.runetype) then
								ActivateRune(unit, rune.runetype )
							end
						end
					end,
				}
			end
			end
		end
	end
end

