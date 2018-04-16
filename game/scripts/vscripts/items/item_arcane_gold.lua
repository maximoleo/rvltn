
LinkLuaModifier("modifier_item_arcane_gold","items/item_arcane_gold.lua", LUA_MODIFIER_MOTION_NONE)


item_arcane_gold = class({})

function item_arcane_gold:GetIntrinsicModifierName()
  return "modifier_item_arcane_gold"
end


function item_arcane_gold:OnSpellStart()
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
	IsHidden = function() return 1 end,
	IsDebuff = function() return 0 end,
	IsPurgable = function() return 0 end,
	RemoveOnDeath = function() return 0 end,
	})


function modifier_item_arcane_gold:OnCreated()
  self:StartIntervalThink(1)
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
    print()
    Gold:ModifyGold(caster:GetPlayerOwnerID(), gpm / 60, true, DOTA_ModifyGold_GameTick)
  end
end

function modifier_item_arcane_gold:OnDestroy()
	self:StartIntervalThink(-1)
end