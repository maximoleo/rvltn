-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle_folder", "particles/test_particle", context)
  PrecacheResource("particle",    "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", context)
  
  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  PrecacheResource("model_folder", "particles/heroes/antimage", context)
  PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/props_structures/dire_fountain001.vmdl", context)

  --PrecacheModel("models/props_gameplay/treasure_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest002.vmdl", context)

  -- Sounds can precached here like anything else
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("item_bow", context)
  PrecacheItemByNameSync("item_bow_2", context)
  PrecacheItemByNameSync("item_bottle_custom", context)
  PrecacheItemByNameSync("item_gang_gold", context)
  PrecacheItemByNameSync("item_recipe_sange_and_yasha_and_kaya", context)
  PrecacheItemByNameSync("item_sange_and_yasha_and_kaya", context)
  PrecacheItemByNameSync("item_recipe_sange_and_kaya", context)
  PrecacheItemByNameSync("item_sange_and_kaya", context)
  PrecacheItemByNameSync("item_recipe_kaya_and_yasha", context)
  PrecacheItemByNameSync("item_kaya_and_yasha", context)
  PrecacheItemByNameSync("item_silver_alebard", context)
  PrecacheItemByNameSync("item_fancy_ward", context)
  PrecacheItemByNameSync("item_banana", context)
  PrecacheItemByNameSync("item_arcane_gold", context)
  PrecacheItemByNameSync("item_battle_fury_big", context)
  PrecacheItemByNameSync("item_veil_of_corrosion", context)
  PrecacheItemByNameSync("item_ring_of_immolation", context)
  PrecacheItemByNameSync("item_refresher_core", context)
  PrecacheItemByNameSync("item_tranquil_gold", context)
  PrecacheItemByNameSync("item_pull_staff", context)
  

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()
end