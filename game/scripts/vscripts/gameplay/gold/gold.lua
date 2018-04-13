--[[
  Author:
    Angel Arena Blackstars
    Chronophylos
  Credits:
    Angel Arena Blackstars
]]


if Gold == nil then
  Gold = class({})
end

local GOLD_CAP = 50000

function Gold:Init()
  -- a table for every player
  PlayerTables:CreateTable("gold", {
    gold = {}
  }, {0,1,2,3,4,5,6,7,8,9})
  Timers:CreateTimer(0.5, Dynamic_Wrap(Gold, "Think"))
end

function Gold:UpdatePlayerGold(unitvar, newGold)
  local playerID = UnitVarToPlayerID(unitvar)
  if playerID and playerID > -1 then
    local tableGold = PlayerTables:GetTableValue("gold", "gold")
    tableGold[playerID] = newGold
    PlayerTables:SetTableValue("gold", "gold", tableGold)

    newGold = math.min(GOLD_CAP, newGold)
    PlayerResource:SetGold(playerID, newGold, false)
    PlayerResource:SetGold(playerID, 0, true)
  end
end

--[[
  Author:
    Chronophylos
  Credits:
    Angel Arena Blackstar
  Description:
    Add Gold to all players via our custom Gold API
]]
function Gold:Think()
  local i = 0
  local table = PlayerResource:GetAllTeamPlayerIDs()
  while table[i] do
    if PlayerResource:IsValidPlayerID(i) then
      local gameState = GameRules:State_Get()
      if gameState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS or gameState == DOTA_GAMERULES_STATE_PRE_GAME then
        local currentGold = Gold:GetGold(i)
        local currentDotaGold = PlayerResource:GetGold(i)
        local newGold = currentGold
        local newDotaGold = currentDotaGold

        if currentGold > GOLD_CAP then
          newGold = currentGold + currentDotaGold - GOLD_CAP
        else
          newGold = currentDotaGold
        end

        if newGold > GOLD_CAP then
          newDotaGold = GOLD_CAP
        else
          newDotaGold = newGold
        end

        if newGold ~= currentGold or newDotaGold ~= currentDotaGold then
          Gold:SetGold(i, newGold)
          PlayerResource:SetGold(i, newDotaGold, false)
          PlayerResource:SetGold(i, 0, true)
        end
      end
    end
    i = i + 1
  end
  return 0.2
end

function Gold:ClearGold(unitvar)
  Gold:SetGold(unitvar, 0)
end

function Gold:SetGold(unitvar, gold)
  local playerID = UnitVarToPlayerID(unitvar)
  --PLAYER_GOLD[playerID].SavedGold = math.floor(gold)
  local newGold = math.floor(gold)
  Gold:UpdatePlayerGold(playerID, newGold)
end

function Gold:ModifyGold(unitvar, gold, bReliable, iReason)
  if gold > 0 then
    Gold:AddGold(unitvar, gold)
  elseif gold < 0 then
    Gold:RemoveGold(unitvar, -gold)
  end
end

function Gold:RemoveGold(unitvar, gold)
  local playerID = UnitVarToPlayerID(unitvar)
  --  PLAYER_GOLD[playerID].SavedGold = math.max((PLAYER_GOLD[playerID].SavedGold or 0) - math.ceil(gold), 0)
  local oldGold = PlayerTables:GetTableValue("gold", "gold")[playerID]
  local newGold = math.max((oldGold or 0) - math.ceil(gold), 0)
  Gold:UpdatePlayerGold(playerID, newGold)
end

function Gold:AddGold(unitvar, gold)
  --[[DebugPrint("[Gold] AddGold")
  DebugPrint("arg.unitvar: " .. unitvar)
  DebugPrint("arg.gold: " .. gold)
  DebugPrintTable(PLAYER_GOLD)]]
  local playerID = UnitVarToPlayerID(unitvar)
  --PLAYER_GOLD[playerID].SavedGold = (PLAYER_GOLD[playerID].SavedGold or 0) + math.floor(gold)
  local oldGold = PlayerTables:GetTableValue("gold", "gold")[playerID]
  local newGold = (oldGold or 0) + math.floor(gold)
  Gold:UpdatePlayerGold(playerID, newGold)
end

function Gold:AddGoldWithMessage(unit, gold, optPlayerID)
  local player = optPlayerID and PlayerResource:GetPlayer(optPlayerID) or PlayerResource:GetPlayer(UnitVarToPlayerID(unit))
  SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, unit, math.floor(gold), player)
  Gold:AddGold(optPlayerID or unit, gold)
end

function Gold:GetGold(unitvar)
  local playerID = UnitVarToPlayerID(unitvar)
  local currentGold = PlayerTables:GetTableValue("gold", "gold")[playerID]
  --return math.floor(PLAYER_GOLD[playerID].SavedGold or 0)
  return math.floor(currentGold or 0)
end


function UnitVarToPlayerID(unitvar)
  if unitvar then
    if type(unitvar) == "number" then
      return unitvar
    elseif type(unitvar) == "table" and not unitvar:IsNull() and unitvar.entindex and unitvar:entindex() then
      if unitvar.GetPlayerID and unitvar:GetPlayerID() > -1 then
        return unitvar:GetPlayerID()
      elseif unitvar.GetPlayerOwnerID then
        return unitvar:GetPlayerOwnerID()
      end
    end
  end
  return -1
end

function CDOTA_BaseNPC_Hero:GetNetworth ()
  return GetNetworth(self)
end

function CDOTA_BaseNPC_Hero:ModifyGold (playerID, goldAmmt, reliable, nReason)
  return Gold:ModifyGold(playerID, goldAmmt, reliable, nReason)
end

function GetNetworth(hero)
    local networth = Gold:GetGold(hero)

    -- Iterate over item slots adding up its gold cost
    for i = 0, 15 do
        local item = hero:GetItemInSlot(i)
        if item then
            networth = networth + item:GetCost()
        end
    end

   return networth
end 