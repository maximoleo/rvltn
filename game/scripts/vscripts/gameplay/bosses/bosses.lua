BossSpawners = {}
AmountOfBosses = 0

BossNames = 
{
	"small_boss",
	"small_boss",
	"small_boss",
	"small_boss",
	"small_boss",
	"small_boss",
	"small_boss",
	"small_boss",
	"small_boss",
}


function Bosses()
	FindBossSpawners()
	SpawnBosses()
end

function FindBossSpawners()
	for i = 1 to AmountOfBosses do
		if i < 10 then
			BossSpawners[i] = FindAllByName("boss_spawner_0"..i)
		else
			BossSpawners[i] = FindAllByName("boss_spawner_"..i)
		end
	end
end

function SpawnBosses()
	for _,bossspawner in pairs(BossSpawners) do
		CreateUnitByName(BossType(bossspawner), bossspawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
	end
end

function BossType(spawner)
	local num = (spawner:GetName()[14]*10 + spawner:GetName()[14]*1)
	print(num)
	if num < 5 then
		return BossNames[math.random(1, 3)]
	elseif num < 7 then
		return BossNames[math.random(4, 6)]
	elseif num == 7 then
		return BossNames[7]
	elseif num == 8 then
		return BossNames[8]
	elseif num == 9 then
		return BossNames[9]
	end	
end