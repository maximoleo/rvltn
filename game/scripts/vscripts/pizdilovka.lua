
require("playertables")
--неуязв от врагов 2 сек, границы,
DUEL_STATUS = 0

if DirePlayers == nil then
	DirePlayers = {}
end

if RadiantPlayers == nil then
	RadiantPlayers = {}
end

if PlayersInf == nil then
	PlayersInf = {}
end
MaxDirePlayers = 0
MaxRadiantPlayers = 0

function Duels() 	
 	Timers:CreateTimer({
    endTime = 300,
    callback = function()
    	DUEL_STATUS = 1
    	Pizdilovka()
    end
  	})
end

function Pizdilovka()
	Create_Player_Hero_Table_Safe_Information_Refresh_All()
	if Teleport_Max_Players() == 0 then
		DUEL_STATUS = 0
		Duels()
	else
		DUEL_STATUS = 2
		Duel_Time()
	end
end

function Teleport_Max_Players()
	local arenanom = math.random(1,4)
	local tempplayer = math.random(1,math.max(MaxDirePlayers,MaxRadiantPlayers))
	local teleported = {}
	if MaxDirePlayers == 0 then
		return 0
	elseif MaxRadiantPlayers == 0 then
		return 0
	elseif MaxDirePlayers == MaxRadiantPlayers then
		for i = 0, MaxDirePlayers 
		do
			Teleport(DirePlayers[i], DirePlayers[i].team, aremanom)
			Teleport(RadiantPlayers[i],RadiantPlayers[i].team, aremanom)
			RadiantPlayers[i].onduel = true
			DirePlayers[i].onduel = true
			DirePlayers[i]:SetRespawnDisabled()
			RadiantPlayers[i]:SetRespawnDisabled()
		end
	elseif math.max(MaxDirePlayers, MaxRadiantPlayers) == MaxDirePlayers then
		for i = 0, MaxDirePlayers 
		do
			Teleport(DirePlayers[i], DirePlayers[i].team, aremanom)
			DirePlayers[i]:SetRespawnDisabled()
			Tp_Max_Lvl_Player("radiant", arenanom)

		end
	elseif math.max() == MaxRadiantPlayers then
		for i = 0, MaxRadiantPlayers 
		do
			Teleport(RadiantPlayers[i], RadiantPlayers[i].team, aremanom)
			RadiantPlayers[i]:SetRespawnDisabled()
			Tp_Max_Lvl_Player("dire", arenanom)
		end
	end
	return 1
end


function Teleport(hero, team, Arena_Nom)
    if hero.IsAlife() then
       	FindClearSpaceForUnit(hero, Entities:FindByName(nil,"arena_tp_" .. team.."_" .. tostring(Arena_Nom)):GetAbsOrigin(), true)
      	SendToConsole("dota_camera_center")
     elseif hero.IsAlife() == false then
     	hero.SetRespawnDisabled()
    end
end

function Tp_Max_Lvl_Player(team, aremanom)
	local maxlvl = 0
	for PlayerId = 0,4
    do
    	if team == "dire" then
    		if DirePlayers[PlayerId] ~= nil then
				if DirePlayers[maxlvl].level < DirePlayers[PlayerId].level then
					maxlvl = PlayerId
				end
			end
 		elseif team == "radiant" then
 			if RadiantPlayers[PlayerId] ~= nil then
 				if RadiantPlayes[maxlvl].level < RadiantPlayers[PlayerId] then
 					maxlvl = PlayerId
 				end
 			end
 		end
 	end
 	if team == "dire" then
 		Teleport(DirePlayers[maxlvl], team, aremanom)
		DirePlayers[maxlvl]:SetRespawnDisabled()
		DirePlayers[maxlvl].level = 0

	elseif temp == "rediant" then
 		Teleport(RadiantPlayers[maxlvl], team, aremanom)
 		DirePlayers[maxlvl]:SetRespawnDisabled()
 		RadiantPlayers[maxlvl].level = 0
 	end
end

function Create_Player_Hero_Table_Safe_Information_Refresh_All()
 	for PlayerId = 0,9 
 	do
 		local player = PlayerResource:GetPlayer(PlayerId)
   		if player ~= nil then
   			if player:GetAssignedHero() then
   				Safe_Information_Refresh_All(player:GetAssignedHero())
   				if player:GetTeam() == DOTA_TEAM_BADGUYS then
   					DirePlayers[MaxDirePlayers + 1] = player:GetAssignedHero()
   					DirePlayers[MaxDirePlayers + 1].team = "dire"
   					DirePlayers[MaxDirePlayers + 1].onduel = false
   					DirePlayers[MaxDirePlayers + 1].level = DirePlayers[MaxDirePlayers + 1]:GetLevel(	)
   					MaxDirePlayers = MaxDirePlayers + 1
   				elseif player:GetTeam() == DOTA_TEAM_GOODGUYS then
   					RadiantPlayers[MaxRadiantPlayers + 1] = player:GetAssignedHero()
   					RadiantPlayers[MaxRadiantPlayers + 1].team = "radiant"
   					RadiantPlayers[MaxRadiantPlayers + 1].onduel = false
   					RadiantPlayers[MaxRadiantPlayers + 1].level = RadiantPlayers[MaxRadiantPlayers + 1]:GetLevel(	)
   					MaxRadiantPlayers = MaxRadiantPlayers + 1 
   				end
   			end
   		end
	end
end

function Safe_Information_Refresh_All(player)
	player.InfBeforeDuel = 
	{
		AbilitiesCooldowns = {},
		ItemCooldowns = {},
		Health = player:GetHealth(),
		Mana = player:GetMana(),
		Place = player:GetAbsOrigin(),
	}
	for i = 0, 23
	do
		if player:GetAbilityByIndex(i) ~= nil then
			player.InfBeforeDuel.AbilitiesCooldowns[i] = player:GetAbilityByIndex(i):GetCooldownTimeRemaining()
			player:GetAbilityByIndex(i):RefreshCharges()
			player:GetAbilityByIndex(i):EndCooldown()
		end
	end
	for i = 0, 5
	do
		if player:GetItemInSlot(i) then
			player.InfBeforeDuel.ItemCooldowns[i] = player:GetItemInSlot(i):GetCooldownTimeRemaining()
			player:GetItemInSlot(i):EndCooldown()
		end
	end
end

function Duel_Time()
	while (DUEL_STATUS == 2) do
		Timers:CreateTimer({
	    endTime = 1,
	    callback = function()
	    	Check_For_Dead_Heroes()
	    end
	  	})
	end
	Duel_End()
	Duels()
end

function Check_For_Dead_Heroes()
	local AlifeDire = 0
	local AlifeRadiant = 0
	for i = 0,4
	do
		if DirePlayers[i] then
			if DirePlayers[i].onduel then
				if DirePlayers[i]:IsReincarnating() then
					DirePlayers[i].onduel = false
				else
					AlifeDire = AlifeDire + 1
				end
			end
		end
		if RadiantPlayers[i] then
			if RadiantPlayers[i].onduel then
				if RadiantPlayers[i]:IsReincarnating() then
					RadiantPlayers[i].onduel = false
				else
					AlifeRadiant = AlifeRadiant + 1
				end
			end
		end
	end
	if AlifeRadiant == 0 or AlifeDire == 0 then
		DUEL_STATUS = 3
	end
end

function Duel_End()
	Refresh_State()
	MaxRadiantPlayers = 0
	MaxDirePlayers = 0
end

function Refresh_State()
	for i = 0,MaxDirePlayers
	do
		if DirePlayers[i] then
			DirePlayers[i]:SetHealth(DirePlayers[i].InfBeforeDuel.Health)
			DirePlayers[i]:SetMana(DirePlayers[i].InfBeforeDuel.Mana)
			FindClearSpaceForUnit(DirePlayers[i], DirePlayers[i].InfBeforeDuel.Place, true)
			for j = 0, 23
			do
				if DirePlayers[i]:GetAbilityByIndex(j) ~= nil then
					DirePlayers[i]:GetAbilityByIndex(j):StartCooldown(DirePlayers:GetAbilityByIndex(j):GetCooldownTime() - DirePlayers[i].InfBeforeDuel.AbilitiesCooldowns[j])
				end
			end
			for i = 0, 5
			do
				if  DirePlayers[i]:GetItemInSlot(i) then
					DirePlayers[i]:GetItemInSlot(j):StartCooldown(DirePlayers:GetItemInSlot(j):GetCooldownTime() - DirePlayers[i].InfBeforeDuel.ItemCooldowns[j])
				end

			end
		end
		if RadiantPlayers[i] then
			RadiantPlayers[i]:SetHealth(RadiantPlayers[i].InfBeforeDuel.Health)
			RadiantPlayers[i]:SetMana(RadiantPlayers[i].InfBeforeDuel.Mana)
			FindClearSpaceForUnit(RadiantPlayers[i], RadiantPlayers[i].InfBeforeDuel.Place, true)
			for j = 0, 23
			do
				if RadiantPlayers[i]:GetAbilityByIndex(j) ~= nil then
					RadiantPlayers[i]:GetAbilityByIndex(j):StartCooldown(RadiantPlayers:GetAbilityByIndex(j):GetCooldownTime() - RadiantPlayers[i].InfBeforeDuel.AbilitiesCooldowns[j])
				end
			end
			for i = 0, 5
			do
				if  RadiantPlayers[i]:GetItemInSlot(i) then
					RadiantPlayers[i]:GetItemInSlot(j):StartCooldown(RadiantPlayers:GetItemInSlot(j):GetCooldownTime() - RadiantPlayers[i].InfBeforeDuel.ItemCooldowns[j])
				end
			end
		end

	end
end