BossSpawners = {}
AmountOfBosses = 1

BossNames = 
{
	"earth_boss",
	"earth_boss",
	"earth_boss",
	"earth_boss",
	"earth_boss",
	"earth_boss",
	"earth_boss",
	"earth_boss",
	"earth_boss",
}


function Bosses()
	FindBossSpawners()
	SpawnBosses()
end

function FindBossSpawners()
	for i = 1, AmountOfBosses do
		if i < 10 then
			BossSpawners[i] = Entities:FindAllByName("boss_spawner_0"..i)[1]
			BossSpawners[i].name = i
		else
			BossSpawners[i] = Entities:FindAllByName("boss_spawner_"..i)
		end
	end
end

function SpawnBosses()
	for _,bossspawner in pairs(BossSpawners) do
		CreateUnitByName(BossType(bossspawner), bossspawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
	end
end

function BossType(spawner)
	
	if spawner.name < 5 then
		return BossNames[math.random(1, 3)]
	elseif spawner.name < 7 then
		return BossNames[math.random(4, 6)]
	elseif spawner.name == 7 then
		return BossNames[7]
	elseif spawner.name == 8 then
		return BossNames[8]
	elseif spawner.name == 9 then
		return BossNames[9]
	end	
end