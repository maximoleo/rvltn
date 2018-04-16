LinkLuaModifier("modifier_maim", "modifiers/modifier_maim.lua", LUA_MODIFIER_MOTION_NONE)

function attack(keys)
	if RollPercentage(keys.ability:GetSpecialValueFor("maim_chance")) then
		keys.target:AddNewModifier(keys.caster, keys.ability, "modifier_maim", {duration = keys.ability:GetSpecialValueFor("maim_duration")})
	end
	if not keys.attacker:IsRangedAttacker() then
		DoCleaveAttack(keys.attacker, keys.target, keys.ability, math.random(keys.attacker:GetBaseDamageMax(), keys.attacker:GetBaseDamageMin()) * keys.ability:GetSpecialValueFor("cleave_percent")/100,  keys.ability:GetSpecialValueFor("cleave_starting_width"), keys.ability:GetSpecialValueFor("cleave_ending_width"), keys.ability:GetSpecialValueFor("cleave_distance"), "particles/items_fx/battlefury_cleave.vpcf" )
	end
end
