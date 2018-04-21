LinkLuaModifier("modifier_item_base", "items/item_base.lua", LUA_MODIFIER_MOTION_NONE)


item_base = class({})
			
function item_base:GetIntrinsicModifierName()
    return "modifier_item_base"
end

modifier_item_base = class({
	IsPassive = function() return true end,
	IsHidden  = function() return true	end	
})

function modifier_item_base:DeclareFunctions()
	return {
	}
end


function modifier_item_base:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor('bonus_all')
end