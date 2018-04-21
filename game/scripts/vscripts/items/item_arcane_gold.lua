
LinkLuaModifier("modifier_item_arcane_gold","items/item_arcane_gold.lua", LUA_MODIFIER_MOTION_NONE)


item_arcane_gold = class({})

function item_arcane_gold:GetIntrinsicModifierName()
    return "modifier_item_arcane_gold"
end


function item_arcane_gold:OnSpellStart()
	if self:GetCaster():IsIllusion() or self:GetCaster():IsTempestDouble() or self:GetCaster():IsClone() then
      return
    end

    for _,v in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), 1, 19, 32832, 0, false)) do
		    v:GiveMana(self:GetSpecialValueFor("mana"))
		        local particleManaGain = ParticleManager:CreateParticle(particleManaGainName, PATTACH_ABSORIGIN_FOLLOW, v)
   				 ParticleManager:SetParticleControl(particleManaGain, 1, v:GetOrigin())
   				 ParticleManager:SetParticleControl(particleManaGain, 2, v:GetOrigin())
   				 ParticleManager:ReleaseParticleIndex(particleManaGain)
	  end
	  self:GetCaster():GiveMana(self:GetSpecialValueFor("mana"))
    self:GetCaster():EmitSound("DOTA_Item.ArcaneBoots.Activate")
end



modifier_item_arcane_gold = class({
	  IsHidden = function() return true end,
	  IsDebuff = function() return false end,
	  IsPurgable = function() return false end,
	  RemoveOnDeath = function() return false end,
})


function modifier_item_arcane_gold:OnCreated()
    self:StartIntervalThink(1)
end


function modifier_item_arcane_gold:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_item_arcane_gold:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor('movespeed')
end

function modifier_item_arcane_gold:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana_stat')
end

if IsServer() then
    function modifier_item_arcane_gold:OnIntervalThink()
    	  if not PlayerResource then
            -- sometimes for no reason the player resource isn't there, usually only at the start of games in tools mode
            return
        end
        local caster = self:GetCaster()
        local gpm = self:GetAbility():GetSpecialValueFor('inc_gpm')

        -- Don't give gold on illusions, Tempest Doubles, or Meepo clones
        if caster:IsIllusion() or caster:IsTempestDouble() or caster:IsClone() then
          return
        end
        Gold:ModifyGold(caster:GetPlayerOwnerID(), gpm / 60, true, DOTA_ModifyGold_GameTick)
    end
end

function modifier_item_arcane_gold:OnDestroy()
	  self:StartIntervalThink(-1)
end