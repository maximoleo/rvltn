item_silver_alebard = class({})

function item_silver_alebard:OnSpellStart()
	self:GetCaster():AddNewModifier(target, self, "modifier_item_silver_edge_windwalk", {duration = self:GetSpecialValueFor("restore_time")})
	print("kek")
end