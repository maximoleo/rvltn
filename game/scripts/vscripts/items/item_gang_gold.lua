function gang_gold_attack(keys)
	if keys.target:IsHero() and keys.ability:IsCooldownReady() then
		if keys.attacker:IsRangedAttacker() then
			keys.attacker:AddExperience(keys.ability:GetSpecialValueFor("eph"), 0, false, false)
			keys.ability:StartCooldown(keys.ability:GetCooldown(1))
        	Gold:AddGold(keys.attacker, keys.ability:GetSpecialValueFor("gph_ranged"))
        	print("here")
        else
        	keys.attacker:AddExperience(keys.ability:GetSpecialValueFor("eph"), 0, false, false)
			keys.ability:StartCooldown(keys.ability:GetCooldown(1))
        	Gold:AddGold(keys.attacker, keys.ability:GetSpecialValueFor("gph_meele"))
        end
	end
end