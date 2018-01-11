require("pizdilovka")
require("spawner")


if GameMode == nil then
	GameMode = class({})
end

function GameMode:On_Game_In_Progress()
    Enable_Spawn()
    Duels()
end

