

names =  {
	{"spawner_creep_easy" , {{"easy_creep_small","easy_creep_large"}}, CreepTypes = 1, MaxToSpawn = {3, 1}},
	{"spawner_creep_medium",{{"medium_creep_small","medium_creep_large"}}, CreepTypes = 1, MaxToSpawn =  {3, 1}},
	{"spawner_creep_dragon",{{"dragon_creep_meele_small","dragon_creep_meele_large"}}, CreepTypes = 1, MaxToSpawn =  {3, 1}}
}


CreepLevel = {
{
	{"small", {{5,0},{4,25},{2,50},{4,100},{3,200},{2,250},{2,500},{100, 1000}},health = 300},
	{"large", {{5,0},{4,10},{2,25},{4,50},{3,100},{2,175},{2,250},{100,500}}, health = 500},	
},
{
	{"small", {{5,0},{4,25},{2,50},{4,100},{3,200},{2,250},{2,500},{100, 1000}}, health = 300},
	{"large", {{5,0},{4,10},{2,25},{4,50},{3,100},{2,175},{2,250},{100,500}}, health = 500},	
},
{
	{"small", {{5,0},{4,25},{2,50},{4,100},{3,200},{2,250},{2,500},{100, 1000}},health = 300},
	{"large", {{5,0},{4,10},{2,25},{4,50},{3,100},{2,175},{2,250},{100,500}},health = 500},	
},			
}

--ростот минуты и от ср лвла
MAX_CREEPS_PER_SPAWN = 30
function Enable_Spawn()
	local repeat_interval = 60
    local start_after = 0
	Find_Spawn()
    Timers:CreateTimer(start_after, function()
        Spawn()
        return repeat_interval
    end)
end

function Find_Spawn()
	PlaceOfSpawn = Entities:FindAllByClassname("info_target")

end

function Spawn()
	local i = 1
	for t = 1, 3 do
		for z = 1,2 do
			ResetHealth(t,z)
		end
	end
	while (PlaceOfSpawn[i])
	do
		for j = 1, 3
		do
			if PlaceOfSpawn[i]:GetName() == names[j][1] then
				local typeofcreeps = math.random(1,names[j].CreepTypes)
				if not(PlaceOfSpawn[i].Creeps) then
					PlaceOfSpawn[i].Creeps = {}
					PlaceOfSpawn[i].Creeps.k = 0
					PlaceOfSpawn[i].AvailiablePlacesForSpawn = {}
				end
				for k = 1, 2 
				do
					for z = 1, Can_Spawn(i,j,k) 
					do
						PlaceOfSpawn[i].Creeps[PlaceOfSpawn[i].AvailiablePlacesForSpawn[z]] = CreateUnitByName(names[j][2][typeofcreeps][k], PlaceOfSpawn[i]:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
						PlaceOfSpawn[i].Creeps[PlaceOfSpawn[i].AvailiablePlacesForSpawn[z]].k = k
						Creep_Upgrade(i,j, PlaceOfSpawn[i].AvailiablePlacesForSpawn[z])
						PlaceOfSpawn[i].AvailiablePlacesForSpawn[z] = 0
					end
				end
				j = 4
			end 
		end
		i = i + 1
	end
end

function Can_Spawn(i, j, k)
	local max_to_spawn = 0
	for p = 1, MAX_CREEPS_PER_SPAWN
	do
		if (PlaceOfSpawn[i].Creeps[p]) then
			Creep_Upgrade(i,j,p)
		elseif (PlaceOfSpawn[i].Creeps[p] == 0 or PlaceOfSpawn[i].Creeps[p] == nil) and (max_to_spawn < names[j].MaxToSpawn[k]) then
			PlaceOfSpawn[i].AvailiablePlacesForSpawn[max_to_spawn + 1] = p
			max_to_spawn = max_to_spawn + 1
		end
	end
	return max_to_spawn

end

function Creep_Upgrade(i,j,nom)
		if not(PlaceOfSpawn[i].Creeps[nom]:IsNull()) then
			PlaceOfSpawn[i].Creeps[nom]:SetMaxHealth(CreepLevel[j][PlaceOfSpawn[i].Creeps[nom].k].health)
		end
end

function ResetHealth(j,k)
	local min = math.floor(GameRules:GetDOTATime(false,false))/60
	local g = 1
	while min > 0 
	do
		min = min - CreepLevel[j][k][2][g][1]
		g = g + 1
	end
	g = g - 1
	if (g > 0) then
		CreepLevel[j][k].health = CreepLevel[j][k].health + CreepLevel[j][k][2][g][2]
	end
end