
function Couriers()
	
   	local i = 0
    while i < 10 do
    	if 	PlayerResource:GetPlayer(i) and not PlayerResource:GetNthCourierForTeam(0, PlayerResource:GetPlayer(i):GetTeam())  then		
			local temp = PlayerResource:GetPlayer(i):GetAssignedHero():GetItemInSlot(0)
		    if temp then
		      PlayerResource:GetPlayer(i):GetAssignedHero():TakeItem(temp)
		    end
			local cour = PlayerResource:GetPlayer(i):GetAssignedHero():AddItemByName("item_courier")
			cour:CastAbility()
			if temp then
		      PlayerResource:GetPlayer(i):GetAssignedHero():AddItem(temp)
		    end	
    	end
    	i = i + 1
   	end
end


--------------------------
modifier_courier_haste  = class({
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
	IsPurgable          = function() return false end,
	RemoveOnDeath       = function() return false end,
	GetTexture          = function() return "rune_haste" end,
	GetEffectName       = function() return "particles/generic_gameplay/rune_haste_owner.vpcf" end,
})

function modifier_courier_haste:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
end

function modifier_courier_haste:GetModifierMoveSpeed_Max()
	return 625
end

function modifier_courier_haste:GetModifierMoveSpeed_Limit()
	return 625
end

function modifier_courier_haste:GetModifierMoveSpeed_Absolute()
	return 625
end
