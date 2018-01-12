-- Generated from template
--ИЗ БОЛЬШОГО:
--боссы
--погода
--голда
--руны
--киллимит
--стрики
--консоль(не Давать Денису)
--шрайны
--статы значения резистов и регена...
--в конце пока ничего потом добавим


--ГЕРОИ И ПРЕДМЕТЫ


require('spawner')
require('gamemode')
players = {}

if GameMode == nil then
	GameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = GameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function GameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

end
check_if_already_started = {}
-- Evaluate the state of the game
function GameMode:OnThink()
	if (GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and not(check_if_already_started[DOTA_GAMERULES_STATE_GAME_IN_PROGRESS])) then
		GameMode.On_Game_In_Progress()
		check_if_already_started[DOTA_GAMERULES_STATE_GAME_IN_PROGRESS] = true	
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end


