LinkLuaModifier("modifier_out_of_duel", "modifiers/modifier_out_of_duel.lua", LUA_MODIFIER_MOTION_NONE)
--modifiers,  
DUEL_STATUS = 0

if DirePlayers == nil then
	DirePlayers = {}
end

if RadiantPlayers == nil then
	RadiantPlayers = {}
end

arenanom = 0
MaxDirePlayers = 0
MaxRadiantPlayers = 0
AssigneableDirePlayers = 0
AssigneableRadiantPlayers = 0

function Duels()
	local i = 10
	 Timers:CreateTimer("PreDuel", {
    	useOldStyle = true,
    	endTime = GameRules:GetGameTime() + 290,
    	callback = function()
			if i == 10 then
				EmitAnnouncerSound("announcer_ann_custom_countdown_" .. i)
   			else
   				EmitAnnouncerSound("announcer_ann_custom_countdown_0" .. i)
   			end
   			i = i - 1
   			if i == 0 then
				DUEL_STATUS = 1
   				Pizdilovka()
     			Timers:RemoveTimer("PreDuel")
			end
   			return GameRules:GetGameTime() + 1.0  	
   		end
   	})
end

function Pizdilovka()
	Create_Player_Hero_Table_Safe_Information_Refresh_All()
	arenanom = math.random(1,4)
	if Teleport_Max_Players() == 0 then
		Duel_End(0)
	else
		Timers:CreateTimer('Duel_End', {
    		endTime = 60,
    		callback = function()
      		Duel_End(2)
    	end
  		})
	end
end

function Teleport_Max_Players()
	DUEL_STATUS = 2
	local tempplayer = math.random(1,math.max(AssigneableDirePlayers, AssigneableRadiantPlayers))
	local teleported = {}
	if AssigneableDirePlayers == 0 or AssigneableRadiantPlayers == 0 then
		return 0
	elseif AssigneableDirePlayers == AssigneableRadiantPlayers then
		for i = 1, AssigneableDirePlayers
		do
			Teleport(DirePlayers[i], DirePlayers[i].team)
			Teleport(RadiantPlayers[i],RadiantPlayers[i].team)
			RadiantPlayers[i].onduel = true
			DirePlayers[i].onduel = true
		end
		return 1
	elseif AssigneableDirePlayers > AssigneableRadiantPlayers then
		for i = 1, AssigneableRadiantPlayers 
		do
			Tp_Max_Lvl_Player("dire")
			Tp_Max_Lvl_Player("radiant")

		end
		for i = AssigneableDirePlayers, AssigneableRadiantPlayers 
		do
			for i = 1, AssigneableDirePlayers do
				if DirePlayers[i].onduel == false then
					DirePlayers[i]:AddNewModifier(nil, nil, "modifier_out_of_duel", nil)
				end
			end
		end
	elseif AssigneableRadiantPlayers > AssigneableDirePlayers then
		for i = 1, AssigneableDirePlayers
		do
			Tp_Max_Lvl_Player("radiant")
			Tp_Max_Lvl_Player("dire")
		end
		for i = AssigneableDirePlayers, AssigneableRadiantPlayers 
		do
			for i = 1, AssigneableRadiantPlayers do
				if RadiantPlayers[i] then
					if RadiantPlayers[i].onduel == false then
						RadiantPlayers[i]:AddNewModifier(nil, nil, "modifier_out_of_duel", nil)
					end
				end
			end
		end
	end
	local temp = math.min(AssigneableRadiantPlayers, AssigneableDirePlayers)
	AssigneableDirePlayers = temp
	AssigneableRadiantPlayers = temp --for death check

	return true
end

function Teleport(hero, team)
    if hero:IsAlive() then
    	if hero:GetName() == "npc_dota_hero_meepo" then
    		for _,v in pairs(Entities:FindAllByName("npc_dota_hero_meepo")) 
    		do
    			FindClearSpaceForUnit(v, Entities:FindByName(nil,"arena_tp_" .. team.."_" .. tostring(arenanom)):GetAbsOrigin(), true)
    			v:SetHealth(v:GetMaxHealth())
    			v:SetMana(v:GetMaxMana())
    		end
	    	SendToConsole("dota_camera_center")
    	else 	
       	FindClearSpaceForUnit(hero, Entities:FindByName(nil,"arena_tp_" .. team.."_" .. tostring(arenanom)):GetAbsOrigin(), true)
      	SendToConsole("dota_camera_center")
      	end
    end
end

function Tp_Max_Lvl_Player(team)
	local maxlvl = 0
	for PlayerId = 1,5
    do
    	if team == "dire" then
    		if DirePlayers[PlayerId] then
				if DirePlayers[maxlvl] then
					if  DirePlayers[maxlvl].level < DirePlayers[PlayerId].level then 
						maxlvl = PlayerId
					end
				else
					maxlvl = PlayerId
				end
			end
 		elseif team == "radiant" then
 			if RadiantPlayers[PlayerId] then
 				if RadiantPlayers[maxlvl] then	
		 			if RadiantPlayers[maxlvl].level < RadiantPlayers[PlayerId].level then
		 				maxlvl = PlayerId
		 			end
 				else
 					maxlvl = PlayerId
 				end
 			end
 		end
 	end
 	if team == "dire" then
 		Teleport(DirePlayers[maxlvl], team, arenanom)
		DirePlayers[maxlvl].onduel = true
		DirePlayers[maxlvl].level = 0
		DirePlayers[maxlvl]:SetHealth(DirePlayers[maxlvl]:GetMaxHealth())
		DirePlayers[maxlvl]:SetMana(DirePlayers[maxlvl]:GetMaxMana())

	elseif team == "radiant" then
 		Teleport(RadiantPlayers[maxlvl], team, arenanom)
 		RadiantPlayers[maxlvl].onduel = true
 		RadiantPlayers[maxlvl].level = 0
		RadiantPlayers[maxlvl]:SetHealth(RadiantPlayers[maxlvl]:GetMaxHealth())
		RadiantPlayers[maxlvl]:SetMana(RadiantPlayers[maxlvl]:GetMaxMana())

 	end
end

function Assign_Player(TeamList, Players, player, team)
	TeamList[Players + 1] = player:GetAssignedHero()
	TeamList[Players + 1].team = team
	TeamList[Players + 1].onduel = false
	TeamList[Players + 1].level = TeamList[Players + 1]:GetLevel()
end

function Create_Player_Hero_Table_Safe_Information_Refresh_All()
 	for PlayerId = 0,9 
 	do
 		local player = PlayerResource:GetPlayer(PlayerId)
   		if player and player:GetAssignedHero() then
			if player:GetAssignedHero():GetName() ~= "npc_dota_hero_meepo" then
				Safe_Information_Refresh_All(player:GetAssignedHero())
			else
				for _,v in pairs(Entities:FindAllByName("npc_dota_hero_meepo")) do
					Safe_Information_Refresh_All(v)	
				end
			end
			if player:GetTeam() == DOTA_TEAM_BADGUYS then
				Assign_Player(DirePlayers, MaxDirePlayers, player, "dire")
				if (DirePlayers[MaxDirePlayers + 1]:IsAlive()) then
				AssigneableDirePlayers = AssigneableDirePlayers + 1
			end
				MaxDirePlayers = MaxDirePlayers + 1	
			elseif player:GetTeam() == DOTA_TEAM_GOODGUYS then
				Assign_Player(RadiantPlayers, MaxRadiantPlayers, player, "radiant")
				if  (RadiantPlayers[MaxRadiantPlayers + 1]:IsAlive()) then
					AssigneableRadiantPlayers = AssigneableRadiantPlayers + 1
				end
				MaxRadiantPlayers = MaxRadiantPlayers + 1
			end
		end
	end
end

function Contains(mass, val)
	if mass then
		for _,v in pairs(mass) 
		do
			print(v)
			if v == val then
				print(v)
				return true 
				end
		end
	end
	return false
end

function Safe_Information_Refresh_All(player)
	player.InfBeforeDuel = 
	{
		Health = player:GetHealth() / player:GetMaxHealth(),
		Mana = player:GetMana(),
		Place = player:GetAbsOrigin(),
		AbilitiesCooldowns = {},
		Modifiers = {},
		Items = {}
	}

	for i = 0, 23
	do
		if player:GetAbilityByIndex(i) then
			player.InfBeforeDuel.AbilitiesCooldowns[i] = player:GetAbilityByIndex(i):GetCooldownTimeRemaining()
			print(player.InfBeforeDuel.AbilitiesCooldowns[i])
			player:GetAbilityByIndex(i):RefreshCharges()
			player:GetAbilityByIndex(i):EndCooldown()
		end
	end
	local i = 0

	for _,v in pairs(player:FindAllModifiers())
	do
		if not modifexeptions[v:GetName()] then
			player.InfBeforeDuel.Modifiers[i] = {}
			player.InfBeforeDuel.Modifiers[i] = v
			player.InfBeforeDuel.Modifiers[i].caster = v:GetCaster()
			player.InfBeforeDuel.Modifiers[i].ability = v:GetAbility()
			player.InfBeforeDuel.Modifiers[i].name = v:GetName()
			player.InfBeforeDuel.Modifiers[i]["duration"] = v:GetDuration() - v:GetElapsedTime()
			player:RemoveModifierByName(player.InfBeforeDuel.Modifiers[i].name)
			i = i + 1
		end
	end


	for i = 0, 8
	do
		if player:GetItemInSlot(i) then
			player.InfBeforeDuel.Items[i] = {}
			player.InfBeforeDuel.Items[i].cooldown = player:GetItemInSlot(i):GetCooldownTimeRemaining()
			player.InfBeforeDuel.Items[i].name = player:GetItemInSlot(i):GetName()
			player:GetItemInSlot(i):EndCooldown()
		end
	end
end


function Check_For_Dead_Heroes(hero)
 	local i = 1
	if ((hero:FindModifierByName("modifier_skeleton_king_reincarnation")  or hero:FindModifierByName("modifier_skeleton_king_reincarnation_scepter")) and (hero:FindAbilityByName("skeleton_king_reincarnation"):GetCooldown(hero:FindAbilityByName("skeleton_king_reincarnation"):GetLevel() - 1) - hero:FindAbilityByName("skeleton_king_reincarnation"):GetCooldownTimeRemaining()) < 1) or hero:FindModifierByName("modifier_skeleton_king_reincarnation_scepter_active") then
	 	print(DirePlayers[i]:GetName(), hero, hero:GetName())

	 	while DirePlayers[i] and DirePlayers[i]:GetName() ~= hero:GetName() and i < 6 do
	 		i = i + 1
	 	end
	 	if i > 1 and DirePlayers[i - 1] then
	 		i = 1
	 		while RadiantPlayers[i] and RadiantPlayers[i]:GetName() ~= hero:GetName() and i < 6 do
	 			i = i + 1
	 		end
	 		RadiantPlayers[i].reincarnating = 1;
	 	else 
	 		DirePlayers[i].reincarnating = 1;
	 	end
	else
		if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
			AssigneableRadiantPlayers = AssigneableRadiantPlayers - 1
		else
			AssigneableDirePlayers = AssigneableDirePlayers - 1
		end
	end
	if AssigneableDirePlayers == 0 or AssigneableRadiantPlayers == 0 then
		Duel_End(1)
	end
end

function Duel_End(refresh)
	Timers:RemoveTimer('Duel_End')
	for i = 1, 5
	do
		if DirePlayers[i] then
			if DirePlayers[i]:GetName() == "npc_dota_hero_meepo" then 
				for _,v in pairs(Entities:FindAllByName("npc_dota_hero_meepo")) do
					Refresh_State(v)
				end
			else
				Refresh_State(DirePlayers[i])
			end
		end
		if RadiantPlayers[i] then
			if RadiantPlayers[i]:GetName() == "npc_dota_hero_meepo" then 
				for _,v in pairs(Entities:FindAllByName("npc_dota_hero_meepo")) do
					Refresh_State(v)
				end
			else
				Refresh_State(RadiantPlayers[i])
			end
		end
	end
	if refresh == 0 then		
		print("Not enough players for duel")
	end
	MaxRadiantPlayers = 0
	MaxDirePlayers = 0
	DUEL_STATUS = 0
	AssigneableRadiantPlayers = 0
	AssigneableDirePlayers = 0
	DirePlayers = {}
	RadiantPlayers = {}
	HeroesOnThisFkingDuel = {}
	arenanom = 0
	Duels()
end

function Refresh_State(player)
	local mod
	if player:IsAlive() then
		for _,v in pairs(player:FindAllModifiers()) do
			if not modifexeptions[v:GetName()] then
				player:RemoveModifierByName(v:GetName())
			end
		end
		print("Duel End")
		player:SetHealth(player.InfBeforeDuel.Health * player:GetMaxHealth())
		player:SetMana(player.InfBeforeDuel.Mana)
		FindClearSpaceForUnit(player, player.InfBeforeDuel.Place, true)
		--Modif
		for _,v in pairs(player.InfBeforeDuel.Modifiers) do
			mod = player:AddNewModifier(v.caster, v.ability, v.name, v)
		end
	end

	for j = 0, 23
	do
		if player:GetAbilityByIndex(j) ~= nil then
			if player.InfBeforeDuel.AbilitiesCooldowns[j] ~= 0 then
				player:GetAbilityByIndex(j):StartCooldown(player:GetAbilityByIndex(j):GetCooldown(player:GetAbilityByIndex(j):GetLevel()) - player.InfBeforeDuel.AbilitiesCooldowns[j])
			else
				player:GetAbilityByIndex(j):EndCooldown()
			end
		end
	end
	--items
	for j = 0, 8
	do
		for _,v in pairs(player.InfBeforeDuel.Items) do
			if player:GetItemInSlot(j) then
				if v.name == player:GetItemInSlot(j):GetName() then
					player:GetItemInSlot(j):StartCooldown(v.cooldown)	
				end
			end
		end
	end
end