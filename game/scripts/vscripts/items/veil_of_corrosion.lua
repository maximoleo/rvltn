modifier_VeilReduction = class({
		IsPurgable = function() return false end,
	})

function modifier_VeilReduction:DeclareFunctions()
	return  {
				MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
			}
end

function modifier_VeilReduction:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_reduce")
end


