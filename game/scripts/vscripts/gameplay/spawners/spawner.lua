

names =  {
	{"spawner_creep_easy" , {{"easy_creep_small","easy_creep_large"}}, CreepTypes = 1, MaxToSpawn = {3, 1}},
	{"spawner_creep_medium",{{"medium_creep_small","medium_creep_large"}}, CreepTypes = 1, MaxToSpawn =  {3, 1}},
	{"spawner_creep_dragon",{{"dragon_creep_meele_small","dragon_creep_meele_large"}}, CreepTypes = 1, MaxToSpawn =  {3, 1}}
}


CreepLevel = {
{
	{"small", {
				{{{6,0},{10,10},{12,25},  {16,50},  {19,100},  {21,175},  {23,250}, {100,500}}, 300}, -- health
			    {{{6,2},{10,3}, {12,5},   {16,6},   {19,7},    {21,9},    {23,12},  {100,15}},  22}, --damage
			    {{{10,0}, {23,0.5}, {100,0}},   0}, --armor
			    {{{6,10},{16, 20},{100,30}},20}, --exp
			    {{{6,10},{16,100},{30,500}},23}--gold
			  }
	
	},	
	{"large", {
				{{{6,0},{10,25},{12,50},  {16,100}, {19,200},  {21,250},  {23,500}, {100, 1000}}, 500}, --health
			    {{{6,2},{10,3}, {12,5},   {16,6},   {19,7},    {21,9},    {23,12},  {100,15}},    44}, -- damage
			    {{{10,0},{23,0.5}, {100,0}}, 0}, --armor
			    {{{6,10},{16, 20},{100,30}},40}, --exp
				{{{6,10},{16,100},{30,500}},23} --gold
			  }
	},	
},
{
	{"small", {
				{{{6,0},{10,10},{12,25},  {16,50},  {19,100},  {21,175},  {23,250}, {100,500}}, 300}, -- health
			    {{{6,2},{10,3}, {12,5},   {16,6},   {19,7},    {21,9},    {23,12},  {100,15}},  22}, -- damage
			    {{{10,0},{23,0.5}, {100,0}}, 0}, -- armor
			    {{{6,10},{16, 20},{100,30}},20},-- exp
			    {{{6,10},{16,100},{30,500}},23} -- gold
			  }
	
	},		
	{"large", {
				{{{6,0},{10,25},{12,50},  {16,100}, {19,200},  {21,250},  {23,500}, {100, 1000}}, 500}, -- health
			    {{{6,2},{10,3}, {12,5},   {16,6},   {19,7},    {21,9},    {23,12},  {100,15}},    44}, --damage
			    {{{10,0},{23,0.5}, {100,0}}, 0}, -- armor
			    {{{6,10},{16, 20},{100,30}},40}, --exp
				{{{6,10},{16,100},{30,500}},46} --gold
			  }
	},		
},
{
	{"small", {
				{{{6,0},{10,10},{12,25},  {16,50},  {19,100},  {21,175},  {23,250}, {100,500}}, 300}, --health
			    {{{6,2},{10,3}, {12,5},   {16,6},   {19,7},    {21,9},    {23,12},  {100,15}},  22}, --damage
				{{{10,0},{23,0.5}, {100,0}}, 0}, --armor
				{{{6,10},{16, 20},{100,30}},20}, --exp
				{{{6,10},{16,100},{100,500}},24} --gold
 			  }
	
	},	
	{"large", {
				{{{6,0},{10,25},{12,50},  {16,100}, {19,200},  {21,250},  {23,500}, {100, 1000}}, 500}, --health
			    {{{6,2},{10,3}, {12,5},   {16,6},   {19,7},    {21,9},    {23,12},  {100,15}},    44}, --damage
 				{{{10,0},{23,0.5}, {100,0}}, 0}, --armor
 				{{{6,10},{16, 20},{100,30}},40}, --exp
 				{{{6,10},{16,100},{100,500}},46} --gold
 			  }
	}		
}			
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
	local min = math.floor(GameRules:GetDOTATime(false,false))/60
	for t = 1, 3 do
		for z = 1,2 do
			for n = 1,5 do
			ResetStats(t,z,n,min)
			end
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
		if (PlaceOfSpawn[i].Creeps[p] == 0 or PlaceOfSpawn[i].Creeps[p] == nil or PlaceOfSpawn[i].Creeps[p]:IsNull() or PlaceOfSpawn[i].Creeps[p]:GetHealth() == 0) and (max_to_spawn < names[j].MaxToSpawn[k]) then
			PlaceOfSpawn[i].AvailiablePlacesForSpawn[max_to_spawn + 1] = p
			max_to_spawn = max_to_spawn + 1
		elseif (PlaceOfSpawn[i].Creeps[p]) then
			Creep_Upgrade(i,j,p)
		end
	end
	return max_to_spawn

end

function Creep_Upgrade(i,j,nom)
		local hptemp = 0
		if not(PlaceOfSpawn[i].Creeps[nom]:IsNull()) then
			hptemp = PlaceOfSpawn[i].Creeps[nom]:GetHealthPercent()
			PlaceOfSpawn[i].Creeps[nom]:SetMaxHealth(CreepLevel[j][PlaceOfSpawn[i].Creeps[nom].k][2][1][2])
			PlaceOfSpawn[i].Creeps[nom]:SetHealth(PlaceOfSpawn[i].Creeps[nom]:GetMaxHealth() * hptemp / 100)
			PlaceOfSpawn[i].Creeps[nom]:SetBaseDamageMin(CreepLevel[j][PlaceOfSpawn[i].Creeps[nom].k][2][2][2] - 2)
			PlaceOfSpawn[i].Creeps[nom]:SetBaseDamageMax(CreepLevel[j][PlaceOfSpawn[i].Creeps[nom].k][2][2][2] + 2)
			PlaceOfSpawn[i].Creeps[nom]:SetPhysicalArmorBaseValue(CreepLevel[j][PlaceOfSpawn[i].Creeps[nom].k][2][3][2])
			PlaceOfSpawn[i].Creeps[nom]:SetDeathXP(CreepLevel[j][PlaceOfSpawn[i].Creeps[nom].k][2][4][2])
			PlaceOfSpawn[i].Creeps[nom]:SetMaximumGoldBounty(CreepLevel[j][PlaceOfSpawn[i].Creeps[nom].k][2][5][2] + 2)
			PlaceOfSpawn[i].Creeps[nom]:SetMinimumGoldBounty(CreepLevel[j][PlaceOfSpawn[i].Creeps[nom].k][2][5][2] + 2)
		end
end

function ResetStats(j,k,stat,min)
	local g = 1
	if min > 100 then
			min = 99
	end
	if min == 0 then
		return 0
	end
	while min > CreepLevel[j][k][2][stat][1][g][1] and  CreepLevel[j][k][2][stat][1][g + 1][1] ~= nil 
	do
		g = g + 1
	end
	if (g > 0) then
		CreepLevel[j][k][2][stat][2] = CreepLevel[j][k][2][stat][2] + CreepLevel[j][k][2][stat][1][g][2]
	end
end