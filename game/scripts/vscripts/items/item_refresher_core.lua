ItemsExeptions = 
{
	item_refresher = 1,
	item_refresher_core = 1,

}

function Refresh(keys)
	if not keys.caster:IsTempestDouble() then
		for i = 0, 23 do
		    if keys.caster:GetAbilityByIndex(i) then
		        keys.caster:GetAbilityByIndex(i):EndCooldown()
		    end
		end
		for i = 0, 5 do
		    if keys.caster:GetItemInSlot(i) and keys.caster:GetItemInSlot(i):IsRefreshable() then 
		        keys.caster:GetItemInSlot(i):EndCooldown()
		    end
		end
		keys.caster:EmitSound("DOTA_Item.Refresher.Activate")
		ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.caster), 0, keys.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.caster:GetAbsOrigin(), true)
		keys.ability:StartCooldown(math.random(keys.ability:GetSpecialValueFor("cooldown_min"), keys.ability:GetSpecialValueFor("cooldown_max")))
	end
end