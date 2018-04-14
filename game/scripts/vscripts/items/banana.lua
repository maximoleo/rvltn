function AddBananaStats(keys)
	keys.caster:SetBaseIntellect(keys.caster:GetBaseIntellect() + keys.ability:GetSpecialValueFor("bonus_int"))
	keys.caster:SetMana(keys.caster:GetMana() + keys.ability:GetSpecialValueFor("mana_restore"))
	keys.ability:SetCurrentCharges(keys.ability:GetCurrentCharges() -1)
	if keys.ability:GetCurrentCharges() <= 0 then 
		keys.caster:RemoveItem(keys.ability)
	end
end	


