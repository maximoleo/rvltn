modifier_VeilReduction = class({
		GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
		IsPurgable = function() return false end,
		GetTexture = function() return "VeilReduction" end,
		GetEffectName = function() return "particles/generic_gameplay/VeilReduction_owner.vpcf" end
	})

function modifier_VeilReduction:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_VeilReduction:GetModifierBaseDamageOutgoing_Percentage()
	return 100
end


