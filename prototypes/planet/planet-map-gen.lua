require "prototypes/planet/planet-maraxsis-map-gen"
require "prototypes/planet/planet-maraxsis-trench-map-gen"
local planet_map_gen = require("__space-age__/prototypes/planet/planet-map-gen")
-- get vanilla planets from space age

local entity_spawn_settings = {}
for _, tropical_fish in pairs(maraxsis.tropical_fish_names) do
    entity_spawn_settings[tropical_fish] = {}
end

planet_map_gen.maraxsis = function()
    return
    {
        terrain_segmentation = 1,
        water = 0,
        property_expression_names =
        {
            elevation = "maraxsis_elevation",
            temperature = "temperature_basic",
            moisture = "maraxsis_moisture",
            aux = "aux_basic",
            cliffiness = "1",
            cliff_elevation = "cliff_elevation_from_elevation",
        },
        cliff_settings =
        {
            name = "cliff-maraxsis",
            cliff_elevation_0 = 0.03,
            cliff_elevation_interval = 0.1,
            cliff_smoothing = 0, -- This is critical for correct cliff placement on the trench entrance.
            richness = 0.98
        },
        autoplace_controls =
        {
            ["iron-ore"] = {},
        },
        autoplace_settings = {
            ["tile"] =
            {
                settings =
                {
                    ["maraxsis-trench-entrance"] = {},
                    ["sand-1-underwater"] = {},
                    ["sand-2-underwater"] = {},
                    ["sand-3-underwater"] = {},
                    ["dirt-5-underwater"] = {},
                }
            },
            ["decorative"] =
            {
                settings =
                {
                    ["urchin-cactus"] = {},

                    -- nauvis decoratives
                    ["v-brown-carpet-grass"] = {},
                    ["v-green-hairy-grass"] = {},
                    ["v-brown-hairy-grass"] = {},
                    ["v-red-pita"] = {},
                    -- end of nauvis
                    ["vulcanus-dune-decal"] = {},
                    ["vulcanus-sand-decal"] = {},
                    ["crater-small"] = {},
                    ["crater-large"] = {},
                    ["pumice-relief-decal"] = {},
                    ["small-volcanic-rock"] = {},
                    ["medium-volcanic-rock"] = {},
                    ["tiny-volcanic-rock"] = {},
                    ["tiny-rock-cluster"] = {},
                    ["small-sulfur-rock"] = {},
                    ["tiny-sulfur-rock"] = {},
                    ["sulfur-rock-cluster"] = {},
                    ["waves-decal"] = {},

                    ["yellow-lettuce-lichen-1x1"] = {},
                    ["yellow-lettuce-lichen-3x3"] = {},
                    ["yellow-lettuce-lichen-6x6"] = {},
                    ["yellow-lettuce-lichen-cups-1x1"] = {},
                    ["yellow-lettuce-lichen-cups-3x3"] = {},
                    ["yellow-lettuce-lichen-cups-6x6"] = {},
                    ["honeycomb-fungus"] = {},
                    ["honeycomb-fungus-1x1"] = {},
                    ["honeycomb-fungus-decayed"] = {},
                    ["split-gill-1x1"] = {},
                    ["split-gill-2x2"] = {},
                    ["split-gill-red-1x1"] = {},
                    ["split-gill-red-2x2"] = {},
                    ["veins"] = {},
                    ["veins-small"] = {},
                    ["mycelium"] = {},
                    ["coral-water"] = {},
                    ["coral-land"] = {},
                    ["black-sceptre"] = {},
                    ["pink-phalanges"] = {},
                    ["pink-lichen-decal"] = {},
                    ["brown-cup"] = {},
                    ["blood-grape"] = {},
                    ["brambles"] = {},
                    ["polycephalum-slime"] = {},
                    ["polycephalum-balloon"] = {},
                    ["fuchsia-pita"] = {},
                    ["wispy-lichen"] = {},
                    ["grey-cracked-mud-decal"] = {},
                    ["barnacles-decal"] = {},
                    --['nerv-roots-dense'] = {},
                    --['nerv-roots-light'] = {},
                    --["tentacles"] = {},
                    --shared
                    ["light-mud-decal"] = {},
                    ["dark-mud-decal"] = {},
                    ["cracked-mud-decal"] = {},
                    ["red-desert-bush"] = {},
                    ["white-desert-bush"] = {},
                    ["red-pita"] = {},
                    ["green-bush-mini"] = {},
                    ["green-croton"] = {},
                    ["green-pita"] = {},
                    ["green-pita-mini"] = {},
                    ["lichen-decal"] = {},
                    ["shroom-decal"] = {},
                }
            },
            ["entity"] = {
                settings = entity_spawn_settings,
            },
        }
    }
end

return planet_map_gen
