LinkLuaModifier("modifier_bottle_regeneration", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bottle_custom","items/bottle.lua", LUA_MODIFIER_MOTION_NONE)


item_bottle_custom = class(ItemBaseClass)

function item_bottle_custom:GetIntrinsicModifierName()
  return "modifier_item_bottle_custom"
end

function item_bottle_custom:OnSpellStart()
	if self.mod:GetStackCount() > 3 then
		self:ActivateRune(self:GetCaster())
		self:SetCurrentCharges(3)
		self.mod:SetStackCount(3)
	else 
		if self:GetCurrentCharges() ~= 0 then	
			local target = self:GetCaster()
			target:AddNewModifier(target, self, "modifier_bottle_regeneration", { duration = self:GetSpecialValueFor("restore_time") })
			self:SetCurrentCharges(self:GetCurrentCharges() - 1)
			self.mod:SetStackCount(self:GetCurrentCharges())

		end
	end
end

function item_bottle_custom:ActivateRune(hero)
		hero:AddNewModifier(hero, self, "modifier_bottle_regeneration", { duration = self:GetSpecialValueFor("restore_time") })
end

function item_bottle_custom:PutInBottle(rune)
	self:SetCurrentCharges(0)
	self.mod:SetStackCount(rune + 4)
end

function item_bottle_custom:GetAbilityTextureName()
	local icon_name = self.BaseClass.GetAbilityTextureName(self)
	if (not self.mod ) then
		return icon_name .. "_" .. 3
	elseif self.mod:GetStackCount() >= 0 then
		return icon_name .. "_" ..	 self.mod:GetStackCount()
	end
end


--------------------------------------------------------------------------------

modifier_item_bottle_custom = class(ModifierBaseClass)

--------------------------------------------------------------------------------

function modifier_item_bottle_custom:IsHidden()
  return true
end

--------------------------------------------------------------------------------

function modifier_item_bottle_custom:OnCreated()
  local spell = self:GetAbility()
  spell.mod = self
  if not spell then
    return
  end
  self:SetStackCount(3)

end

--------------------------------------------------------------------------------

function modifier_item_bottle_custom:OnRemoved()
  local spell = self:GetAbility()

  if not spell then
    return
  end

  if spell and self:GetStackCount() then
  	self:SetStackCount(0)
  end

end


