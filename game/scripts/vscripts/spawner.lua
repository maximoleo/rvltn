print("kek")
require("timers")
MAX_CREEPS_PER_SPAWN = 30

names =  {}
names[1] = {"spawn_creep_medium_small","medium_creep_small", 3, creeps = {nil}, AvaliablePlases = {}}
names[2] = {"spawn_creep_medium_large","medium_creep_large", 1, creeps = {nil}, AvaliablePlases = {}}
names[3] = {"spawn_creep_dragon","dragon_creep_meele_large", 1, creeps = {nil}, AvaliablePlases = {}}

PlaceOfSpawn = {}

--максимум 40 крипов
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
				local temp = math.min(names[i][3], Can_Spawn(i))
				print(temp)
				while temp > 0
				do
					names[i].creeps[names[i].AvaliablePlases[temp]] = CreateUnitByName(names[i][2], PlaceOfSpawn[j]:GetAbsOrigin() , true, nil, nil, DOTA_TEAM_NEUTRALS)
					names[i].AvaliablePlases[temp] = 0
					temp = temp - 1
				end
			end
		end
		j = j + 1
	end
end

function Can_Spawn(i)
	local AvaliablePlasesForSpawn = 0
	local minfreeplace = 1
	local j = 1
	while AvaliablePlasesForSpawn < names[i][3]	do
		if names[i].creeps[j] == 0 or names[i].creeps[j] == nil then
			AvaliablePlasesForSpawn = AvaliablePlasesForSpawn + 1
			names[i].AvaliablePlases[minfreeplace] = j
			minfreeplace = minfreeplace + 1
		end	
		j = j + 1
	end
	return AvaliablePlasesForSpawn
end