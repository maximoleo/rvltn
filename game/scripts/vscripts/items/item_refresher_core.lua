function Refresh(keys)
	local caster = keys.caster
	local ability = keys.ability
	if not caster:IsTempestDouble() then
				for i = 0, 23 do
		    if caster:GetAbilityByIndex(i) then
		        caster:GetAbilityByIndex(i):EndCooldown()
		    end
		end
				for i = 0, 5 do
		    if caster:GetItemInSlot(i) then
		        caster:GetItemInSlot(i):EndCooldown()
		    end
		end
		caster:EmitSound("DOTA_Item.Refresher.Activate")
		ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster), 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ability:StartCooldown(math.min(math.max(table.highest(GetAllAbilitiesCooldowns(caster)), ability:GetSpecialValueFor("cooldown_min")), ability:GetSpecialValueFor("cooldown_max")))
	end
end