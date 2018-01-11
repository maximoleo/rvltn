
require("playertables")
--неуязв от врагов 2 сек, границы, когда мертв до дуэли не появл на дуэль, переделать TP_MAX_PLAYERS под уровень, окончание
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
    local endTime = 60,
    callback = function()
    	DUEL_STATUS = 1
    	Pizdilovka()
    end
  	})
end

function Pizdilovka()
	Create_Player_Hero_Table_Safe_Information_Refresh_All()
	Teleport_Max_Players()
	DUEL_STATUS = 2
	Duel_Time()
	
end

function Teleport_Max_Players()
	local arenanom = math.random(1,4)
	local tempplayer = math.random(1,math.max(MaxDirePlayers,MaxRadiantPlayers))
	local teleported = {}
	if MaxDirePlayers == 0 then
		Teleport(RadiantPlayers[MaxRadiantPlayers],RadiantPlayers[MaxRadiantPlayers].team, arenanom)
		RadiantPlayers[MaxRadiantPlayers]:SetRespawnDisabled()
	elseif MaxRadiantPlayers == 0 then
		Teleport(DirePlayers[MaxDirePlayers + 1],DirePlayers[MaxDirePlayers + 1].team, arenanom)
		DirePlayers[MaxDirePlayers]:SetRespawnDisabled()
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
			while (RadiantPlayers[tempplayer].onduel) do
				tempplayer = random(1,MaxRadiantPlayers)
			end
			tped[tempplayer] = 1
			Teleport(RadiantPlayers[tempplayer],RadiantPlayers[tempplayer].team,arenanom)
			RadiantPlayers[tempplayer]:SetRespawnDisabled()
		end
	elseif math.max() == MaxRadiantPlayers then
		for i = 0, MaxRadiantPlayers 
		do
			Teleport(RadiantPlayers[i], RadiantPlayers[i].team, aremanom)
			RadiantPlayers[i]:SetRespawnDisabled()
			while (tped[tempplayer]) do
				tempplayer = random(1,MaxDirePlayers)
			end
			tped[tempplayer] = 1
			Teleport(DirePlayers[tempplayer],DirePlayers[tempplayer].team,arenanom)
			DirePlayers[tempplayer]:SetRespawnDisabled()
		end
	end
end


function Teleport(hero, team, Arena_Nom)
       	FindClearSpaceForUnit(hero, Entities:FindByName(nil,"arena_tp_" .. team.."_" .. tostring(Arena_Nom)):GetAbsOrigin(), true)
      	SendToConsole("dota_camera_center")
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
   					MaxDirePlayers = MaxDirePlayers + 1
   				elseif player:GetTeam() == DOTA_TEAM_GOODGUYS then
   					RadiantPlayers[MaxRadiantPlayers + 1] = player:GetAssignedHero()
   					RadiantPlayers[MaxRadiantPlayers + 1].team = "radiant"
   					RadiantPlayers[MaxRadiantPlayers + 1].onduel = false
   					MaxRadiantPlayers = MaxRadiantPlayers + 1 
   				end
   			end
   		end
	end
end

function Safe_Information_Refresh_All(player)
	player.InfBeforeDuel = 
	{
		MaxAbilityAmount = player:GetAbilityCount(),
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
	    local endTime = 1,
	    callback = function()
	    	Check_For_Dead_Heroes()
	    end
	  	})
	end
	Duel_End()
	Timers:CreateTimer({
    endTime = 60,
    callback = function()
    	Pizdilovka()
    end
  	})

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
		DirePlayers[i]:SetHealth(DirePlayers[i].InfBeforeDuel.Health)
		DirePlayers[i]:SetMana(DirePlayers[i].InfBeforeDuel.Mana)
		FindClearSpaceForUnit(DirePlayers[i], DirePlayers[i].InfBeforeDuel.Place, true)

	end
end