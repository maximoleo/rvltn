print("kek")
require("timers")

names =  {}
names[1] = {"spawn_creep_medium_small","medium_creep_small", 3}
names[2] = {"spawn_creep_medium_large","medium_creep_large", 1}
names[3] = {"spawn_creep_dragon","dragon_creep_meele_large", 1}

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
		while i < 4
		do
			if (PlaceOfSpawn[j]:GetName() == names[i][1])
			then
				temp = names[i][3]
				while temp > 0 
				do
					creep = CreateUnitByName(names[i][2], PlaceOfSpawn[j]:GetAbsOrigin() , true, nil, nil, DOTA_TEAM_NEUTRALS)
					temp = temp - 1
				end
			end
			i = i + 1
		end
		i = 1
		j = j + 1
	end
end
