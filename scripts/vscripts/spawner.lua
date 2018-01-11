print("kek")
require("timers")


names =  {}
names[1] = {"spawn_creep_medium_small","medium_creep_small"}
names[2] = {"spawn_creep_medium_large","medium_creep_large"}
names[3] = {"spawn_creep_dragon","dragon_creep_meele_large"}

place_of_spawn = {}

--максимум 40 крипов
--ростот минуты и от ср лвла

function Enable_Spawn()
	local repeat_interval = 15 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 15 -- Start this timer *start_after* game-time seconds later
	Find_Spawn()
    Timers:CreateTimer(start_after, function()
        Spawn()
        return repeat_interval
    end)
end

function Find_Spawn()
	place_of_spawn = Entities:FindAllByClassname("info_target")
end

function Spawn()
	local i = 1
	local j = 1


	while (place_of_spawn[j])
	do
		while i < 4
		do
			if (place_of_spawn[j]:GetName() == names[i][1])
			then

				creep = CreateUnitByName(names[i][2], place_of_spawn[j]:GetAbsOrigin() , true, nil, nil, DOTA_TEAM_NEUTRALS)
			end
			i = i + 1
		end
		i = 1
		j = j + 1
		print(j)
	end
end

