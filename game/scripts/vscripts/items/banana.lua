
item_banana = class({})

function item_banana:OnSpellStart()
	self:GetCaster():SetBaseIntellect(self:GetCaster():GetBaseIntellect() + self:GetSpecialValueFor("bonus_int"))
	self:GetCaster():SetMana(self:GetCaster():GetMana() + self:GetSpecialValueFor("mana_restore"))
	self:SetCurrentCharges(self:GetCurrentCharges() -1)
	if self:GetCurrentCharges() <= 0 then 
		self:GetCaster():RemoveItem(self)
	end	
end