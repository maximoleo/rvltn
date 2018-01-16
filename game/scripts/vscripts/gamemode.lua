-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "1.00"

BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

require('libraries/timers')
require('libraries/physics')
require('libraries/projectiles')
require('libraries/animations')
require('libraries/attachments')
require('libraries/playertables')
require('libraries/containers')
require('libraries/modmaker')
require('libraries/pathgraph')
require('libraries/selection')

require('internal/gamemode')
require('internal/events')

require('settings')
require('events')

require('gameplay/requirements')

function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
end

function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())
end
function GameMode:OnGameInProgress()
  Enable_Spawn()
  Duels()

end



function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')

  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

function GameMode:ExampleConsoleCommand()

end