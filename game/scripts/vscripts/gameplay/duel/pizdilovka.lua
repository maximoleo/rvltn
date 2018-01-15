
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
AssigneableDirePlayers = 0
AssigneableRadiantPlayers = 0

function Duels() 	
 	Timers:CreateTimer({
    endTime = 30,
    callback = function()
    	DUEL_STATUS = 1
    	Pizdilovka()
    end
  	})
end

function Pizdilovka()
	Create_Player_Hero_Table_Safe_Information_Refresh_All()
	if Teleport_Max_Players() == 0 then
		MaxRadiantPlayers = 0
		MaxDirePlayers = 0
		DUEL_STATUS = 0
		AssigneableRadiantPlayers = 0
		AssigneableDirePlayers = 0
		Duels()
	else
		print("duel time")
		DUEL_STATUS = 2
	end
end

function Teleport_Max_Players()
	local arenanom = math.random(1,4)
	local tempplayer = math.random(1,math.max(AssigneableDirePlayers, AssigneableRadiantPlayers))
	local teleported = {}
	if AssigneableDirePlayers == 0 then
		return 0
	elseif AssigneableRadiantPlayers == 0 then
		return 0
	elseif AssigneableDirePlayers == AssigneableRadiantPlayers then
		for i = 1, AssigneableDirePlayers
		do
			print("Player: ", DirePlayers[i], "team", "arenanom", arenanom)
			Teleport(DirePlayers[i], DirePlayers[i].team, arenanom)
			Teleport(RadiantPlayers[i],RadiantPlayers[i].team, arenanom)
			RadiantPlayers[i].onduel = true
			DirePlayers[i].onduel = true
			DirePlayers[i]:SetRespawnsDisabled(true)
			RadiantPlayers[i]:SetRespawnsDisabled(true)
			return 1
		end
	elseif math.max(AssigneableDirePlayers, AssigneableRadiantPlayers) == AssigneableDirePlayers then
		for i = 1, AssigneableDirePlayers 
		do
			Tp_Max_Lvl_Player("dire", arenanom)
			Tp_Max_Lvl_Player("radiant", arenanom)

		end
	elseif math.max(AssigneableDirePlayers, AssigneableRadiantPlayers) == AssigneableRadiantPlayers then
		for i = 1, AssigneableRadiantPlayers
		do
			Tp_Max_Lvl_Player("radiant", arenanom)
			Tp_Max_Lvl_Player("dire", arenanom)
		end
	end
	return 1
end


function Teleport(hero, team, arenanom)
    if hero:IsAlive() then
       	FindClearSpaceForUnit(hero, Entities:FindByName(nil,"arena_tp_" .. team.."_" .. tostring(arenanom)):GetAbsOrigin(), true)
      	SendToConsole("dota_camera_center")
      	print("Teleported")
     elseif hero:IsAlive() == false then
     	hero:SetRespawnsDisabled(true)
    end
end

function Tp_Max_Lvl_Player(team, arenanom)
	local maxlvl = 0
	for PlayerId = 1,5
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
 		Teleport(DirePlayers[maxlvl], team, arenanom)
		DirePlayers[maxlvl]:SetRespawnsDisabled(true)
		DirePlayers[maxlvl].level = 0

	elseif team == "radiant" then
 		Teleport(RadiantPlayers[maxlvl], team, arenanom)
 		DirePlayers[maxlvl]:SetRespawnsDisabled(true)
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
   					DirePlayers[MaxDirePlayers + 1].level = DirePlayers[MaxDirePlayers + 1]:GetLevel()
   					if (DirePlayers[MaxDirePlayers + 1]:IsAlive()) then
   						AssigneableDirePlayers = AssigneableDirePlayers + 1
   					end
   					MaxDirePlayers = MaxDirePlayers + 1
   				elseif player:GetTeam() == DOTA_TEAM_GOODGUYS then
   					RadiantPlayers[MaxRadiantPlayers + 1] = player:GetAssignedHero()
   					RadiantPlayers[MaxRadiantPlayers + 1].team = "radiant"
   					RadiantPlayers[MaxRadiantPlayers + 1].onduel = false
   					RadiantPlayers[MaxRadiantPlayers + 1].level = RadiantPlayers[MaxRadiantPlayers + 1]:GetLevel()
   					if  (RadiantPlayers[MaxRadiantPlayers + 1]:IsAlive()) then
   						AssigneableRadiantPlayers = AssigneableRadiantPlayers + 1
   					end
   					MaxRadiantPlayers = MaxRadiantPlayers + 1
   				end
   			end
   		end
	end
	print("MaxDirePlayers", MaxDirePlayers, "MaxRadiantPlayers", MaxRadiantPlayers)
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



function Check_For_Dead_Heroes()
	 print("here")
	 local AlifeDire = 0
	 local AlifeRadiant = 0
	for i = 0,4
	do
		if DirePlayers[i] then
			if DirePlayers[i].onduel then
				if DirePlayers[i]:IsReincarnating() then
					if DirePlayers[i].onduel then
						AlifeDire = AlifeDire + 1
					end
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
	print (AlifeRadiant, AlifeDire)
	if AlifeRadiant == 0 or AlifeDire == 0 then
		 Duel_End()
	end	
end

function Duel_End()
	Refresh_State()
	MaxRadiantPlayers = 0
	MaxDirePlayers = 0
	DUEL_STATUS = 0
	AssigneableRadiantPlayers = 0
	AssigneableDirePlayers = 0
	Duels()
end

function Refresh_State()
	for i = 0,MaxDirePlayers
	do
		if DirePlayers[i] then
			DirePlayers[i]:SetRespawnsDisabled(false)
			DirePlayers[i]:SetHealth(DirePlayers[i].InfBeforeDuel.Health)
			DirePlayers[i]:SetMana(DirePlayers[i].InfBeforeDuel.Mana)
			FindClearSpaceForUnit(DirePlayers[i], DirePlayers[i].InfBeforeDuel.Place, true)
			for j = 0, 23
			do
				if DirePlayers[i]:GetAbilityByIndex(j) ~= nil then
					DirePlayers[i]:GetAbilityByIndex(j):StartCooldown(DirePlayers[i]:GetAbilityByIndex(j):GetCooldownTime() - DirePlayers[i].InfBeforeDuel.AbilitiesCooldowns[j])
				end
			end
			for j = 0, 5
			do
				if  DirePlayers[i]:GetItemInSlot(j) then
					DirePlayers[i]:GetItemInSlot(j):StartCooldown(DirePlayers[i]:GetItemInSlot(j):GetCooldownTime() - DirePlayers[i].InfBeforeDuel.ItemCooldowns[j])
				end

			end
		end
		if RadiantPlayers[i] then
						RadiantPlayers[i]:SetRespawnsDisabled(false)
			RadiantPlayers[i]:SetHealth(RadiantPlayers[i].InfBeforeDuel.Health)
			RadiantPlayers[i]:SetMana(RadiantPlayers[i].InfBeforeDuel.Mana)
			FindClearSpaceForUnit(RadiantPlayers[i], RadiantPlayers[i].InfBeforeDuel.Place, true)
			for j = 0, 23
			do
				if RadiantPlayers[i]:GetAbilityByIndex(j) ~= nil then
					RadiantPlayers[i]:GetAbilityByIndex(j):StartCooldown(RadiantPlayers[i]:GetAbilityByIndex(j):GetCooldownTime() - RadiantPlayers[i].InfBeforeDuel.AbilitiesCooldowns[j])
				end
			end
			for j = 0, 5
			do
				if  RadiantPlayers[i]:GetItemInSlot(j) then
					RadiantPlayers[i]:GetItemInSlot(j):StartCooldown(RadiantPlayers[i]:GetItemInSlot(j):GetCooldownTime() - RadiantPlayers[i].InfBeforeDuel.ItemCooldowns[j])
				end
			end
		end

	end
end