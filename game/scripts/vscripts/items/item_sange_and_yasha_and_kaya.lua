LinkLuaModifier("modifier_maim", "modifiers/modifier_maim.lua", LUA_MODIFIER_MOTION_NONE)

function maim_attack(keys)
	if RollPercentage(keys.ability:GetSpecialValueFor("maim_chance")) then
		keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_maim", {duration = keys.ability:GetSpecialValueFor("maim_duration")})
	end
end