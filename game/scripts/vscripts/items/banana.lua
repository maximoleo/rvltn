function AddBananaStats(keys)

	keys.caster:SetBaseAgility(keys.caster:GetBaseAgility() + keys.ability:GetSpecialValueFor("bonus_all"))
	keys.caster:SetBaseStrength(keys.caster:GetBaseStrength() + keys.ability:GetSpecialValueFor("bonus_all"))
	keys.caster:SetBaseIntellect(keys.caster:GetBaseIntellect() + keys.ability:GetSpecialValueFor("bonus_all"))
	keys.caster:SetMana(keys.caster:GetMana() + keys.ability:GetSpecialValueFor("mana_restore"))
	keys.ability:SetCurrentCharges(keys.ability:GetCurrentCharges() -1)
	if keys.ability:GetCurrentCharges()==0 then 
		keys.caster:RemoveItem(keys.ability)
	end
end	


