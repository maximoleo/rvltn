

function SplitShotLaunch( keys ) 
	if keys.caster:IsRangedAttacker() then
		local targets = FindUnitsInRadius(keys.caster:GetTeam(), keys.target:GetAbsOrigin(), nil, keys.ability:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for _,i in ipairs(targets) do
			if i ~= keys.caster:GetAttackTarget() and not i:IsAttackImmune() then
				local projectile_info = 
				{
					Source = keys.caster,
					Ability = keys.ability,
					vSourceLoc = keys.caster:GetAbsOrigin(),
					iMoveSpeed = keys.caster:GetProjectileSpeed(),
					bReplaceExisting = false,
				}
				if keys.force_attack_projectile then
					projectile_info["EffectName"] = keys.force_attack_projectile
				else
					projectile_info["EffectName"] = keys.caster:GetRangedProjectileName()
				end
				projectile_info["Target"] = i
				ProjectileManager:CreateTrackingProjectile(projectile_info)
			end
		end
	end
end


function SplitShotDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage_percent = keys.Damage_percent

	local itemcount = 0
	for i = 0, 5 do
		local item = caster:GetItemInSlot(i)
		if item and item:GetName() == ability:GetName() then
			itemcount = itemcount + 1
		end
	end
	if not caster:IsIllusion() then
		ApplyDamage({
			attacker = caster,
			victim = target,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage = caster:GetAverageTrueAttackDamage(target) * (damage_percent / 100) * itemcount,
			ability = ability
		})
	end
end