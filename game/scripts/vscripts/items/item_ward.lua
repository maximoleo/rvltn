
function Place_ward(keys)
	local ward = CreateUnitByName("rune_custom", keys.target_points[1], false, nil, nil, keys.caster:GetTeamNumber())
	ward:SetDayTimeVisionRange(keys.ability:GetSpecialValueFor("vision_range"))
	ward:SetNightTimeVisionRange(keys.ability:GetSpecialValueFor("vision_range"))
	keys.ability:SetCurrentCharges(keys.ability:GetCurrentCharges() - 1)
	local time = keys.ability:GetSpecialValueFor("vision_length")
	if keys.ability:GetCurrentCharges() == 0 then
		keys.caster:RemoveItem(keys.ability)
	end
	Timers:CreateTimer(time, function()
		UTIL_Remove(ward)
	end)
end