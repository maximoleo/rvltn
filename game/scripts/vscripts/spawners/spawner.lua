print("kek")
require("timers")
MAX_CREEPS_PER_SPAWN = 30

names =  {}
names[1] = {"spawner_creep_easy" , {{"easy_creep_small","easy_creep_large"}}, CreepTypes = 1, MaxToSpawn = {3, 1}, Creeps = {nil}, AvaliableToSpawn = {}}
names[2] = {"spawner_creep_medium",{{"medium_creep_small","medium_creep_large"}}, CreepTypes = 1, MaxToSpawn =  {3, 1}, Creeps = {nil}, AvaliableToSpawn = {}}
names[3] = {"spawner_creep_dragon",{{"dragon_creep_meele_small","dragon_creep_meele_large"}}, CreepTypes = 1, MaxToSpawn =  {3, 1}, Creaeps = {nil}, AvaliablePlases = {}}

PlaceOfSpawn = {}

--ростот минуты и от ср лвла

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
	local j = 1


	while (PlaceOfSpawn[j])
	do
		for i =  1,3
		do
			if (PlaceOfSpawn[j]:GetName() == names[i][1])
			then
				local types = math.random(1, names[i].CreepTypes)
				for p = 1,2 
				do
					local temp = math.min(names[i].MaxToSpawn[p], Can_Spawn(i,p))
					while temp > 0
					do
						names[i].Creeps[names[i].AvaliableToSpawn[temp]] = CreateUnitByName(names[i][2][types][p], PlaceOfSpawn[j]:GetAbsOrigin() , true, nil, nil, DOTA_TEAM_NEUTRALS)
						names[i].AvaliableToSpawn[temp] = 0
						temp = temp - 1
					end
				end
			end
		end
		j = j + 1
	end
end

function Can_Spawn(i, p)
	local AvaliablePlasesForSpawn = 0
	local minfreeplace = 1
	local j = 1
	while AvaliablePlasesForSpawn < names[i].MaxToSpawn[p] and j <  MAX_CREEPS_PER_SPAWN	do
		if names[i].Creeps[j] == 0 or names[i].Creeps[j] == nil then
			AvaliablePlasesForSpawn = AvaliablePlasesForSpawn + 1
			names[i].AvaliableToSpawn[minfreeplace] = j
			minfreeplace = minfreeplace + 1
		end	
		j = j + 1
	end
	return AvaliablePlasesForSpawn
end