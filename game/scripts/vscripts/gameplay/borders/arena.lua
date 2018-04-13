HeroesOnTheFkingArena = {}
function InDuel(triger)
	table.insert(HeroesOnTheFkingArena, triger.activator)
end

function NotOnDuel(hero)
	for i = 1, table.maxn(HeroesOnTheFkingArena) do
		if HeroesOnTheFkingArena[i] == hero then
			return false
		end
	end
	return true
end

function OutOfDuel(triger)
	for i = 1, table.maxn(HeroesOnTheFkingArena)
	do
		if HeroesOnTheFkingArena[i] == triger.activator then
			HeroesOnTheFkingArena[i] = nil
		end
	end

	Timers:CreateTimer({
    		endTime = 0.1,
    		callback = function()
      		TpIfNeed(triger)
    	end
  		})
end

function TpIfNeed(triger)
	if DUEL_STATUS == 2 and NotOnDuel(triger.activator) and IsValidEntity(triger.activator) then
			if triger.activator:GetTeamNumber() == 2 then
					triger.activator:InterruptMotionControllers(true)
					Teleport(triger.activator, "radiant")
			elseif triger.activator:GetTeamNumber() == 3 then
					triger.activator:InterruptMotionControllers(true)
					Teleport(triger.activator, "dire")
			end 
		end

end