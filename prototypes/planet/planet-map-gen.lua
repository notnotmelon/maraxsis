require 'prototypes/planet/planet-maraxsis-map-gen'
local planet_map_gen = require('__space-age__/prototypes/planet/planet-map-gen')
-- get vanilla planets from space age

planet_map_gen.maraxsis = function()
    return
    {
        terrain_segmentation = 1,
        water = 0,
        property_expression_names =
        {
            elevation = 'maraxsis_elevation',
            temperature = 'temperature_basic',
            moisture = 'moisture_basic',
            aux = 'aux_basic',
            cliffiness = '1',
            cliff_elevation = 'cliff_elevation_from_elevation',
        },
        cliff_settings =
        {
            name = 'cliff-vulcanus',
            cliff_elevation_0 = 0.07,
            -- Ideally the first cliff would be at elevation 0 on the coastline, but that doesn't work,
            -- so instead the coastline is moved to elevation 80.
            -- Also there needs to be a large cliff drop at the coast to avoid the janky cliff smoothing
            -- but it also fails if a corner goes below zero, so we need an extra buffer of 40.
            -- So the first cliff is at 80, and terrain near the cliff shouln't go close to 0 (usually above 40).
            cliff_elevation_interval = 0.1,
            cliff_smoothing = 0, -- This is critical for correct cliff placement on the coast.
            richness = 0.98
        },
        autoplace_controls =
        {
            ['sulfuric-acid-geyser'] = {},
        },
        autoplace_settings =
        {
            ['tile'] =
            {
                settings =
                {
                    --[[['highland-dark-rock'] = {},
                    ['highland-dark-rock-2'] = {},
                    ['lowland-cream-cauliflower'] = {},
                    ['lowland-cream-cauliflower-2'] = {},
                    ['lowland-cream-red'] = {},
                    ['midland-turquoise-bark'] = {},
                    ['midland-turquoise-bark-2'] = {},
                    ['midland-cracked-lichen'] = {},
                    ['midland-cracked-lichen-dull'] = {},
                    ['midland-cracked-lichen-dark'] = {},--]]
                    ['maraxsis-trench-entrance'] = {},
                    ['sand-3-underwater'] = {},


                    --[[['lowland-brown-blubber'] = {},
                    ['lowland-olive-blubber'] = {},
                    ['lowland-olive-blubber-2'] = {},
                    ['lowland-olive-blubber-3'] = {},
                    ['lowland-pale-green'] = {},
                    ['lowland-red-vein'] = {},
                    ['lowland-red-vein-2'] = {},
                    ['lowland-red-vein-3'] = {},
                    ['lowland-red-vein-4'] = {},
                    ['lowland-red-vein-dead'] = {},
                    ['lowland-red-infection'] = {},
                    ['midland-yellow-crust'] = {},
                    ['midland-yellow-crust-2'] = {},
                    ['midland-yellow-crust-3'] = {},
                    ['midland-yellow-crust-4'] = {},
                    ['highland-yellow-rock'] = {},
                    ['pit-rock'] = {},--]]
                }
            },
            ['decorative'] =
            {
                settings =
                {
                    ['urchin-cactus'] = {},

                    -- nauvis decoratives
                    ['v-brown-carpet-grass'] = {},
                    ['v-green-hairy-grass'] = {},
                    ['v-brown-hairy-grass'] = {},
                    ['v-red-pita'] = {},
                    -- end of nauvis
                    ['vulcanus-rock-decal-large'] = {},
                    ['vulcanus-dune-decal'] = {},
                    ['vulcanus-sand-decal'] = {},
                    ['vulcanus-lava-fire'] = {},
                    ['calcite-stain'] = {},
                    ['calcite-stain-small'] = {},
                    ['sulfur-stain'] = {},
                    ['sulfur-stain-small'] = {},
                    ['sulfuric-acid-puddle'] = {},
                    ['sulfuric-acid-puddle-small'] = {},
                    ['crater-small'] = {},
                    ['crater-large'] = {},
                    ['pumice-relief-decal'] = {},
                    ['small-volcanic-rock'] = {},
                    ['medium-volcanic-rock'] = {},
                    ['tiny-volcanic-rock'] = {},
                    ['tiny-rock-cluster'] = {},
                    ['small-sulfur-rock'] = {},
                    ['tiny-sulfur-rock'] = {},
                    ['sulfur-rock-cluster'] = {},
                    ['waves-decal'] = {},

                    ['yellow-lettuce-lichen-1x1'] = {},
                    ['yellow-lettuce-lichen-3x3'] = {},
                    ['yellow-lettuce-lichen-6x6'] = {},
                    ['yellow-lettuce-lichen-cups-1x1'] = {},
                    ['yellow-lettuce-lichen-cups-3x3'] = {},
                    ['yellow-lettuce-lichen-cups-6x6'] = {},
                    ['green-lettuce-lichen-1x1'] = {},
                    ['green-lettuce-lichen-3x3'] = {},
                    ['green-lettuce-lichen-6x6'] = {},
                    ['green-lettuce-lichen-water-1x1'] = {},
                    ['green-lettuce-lichen-water-3x3'] = {},
                    ['green-lettuce-lichen-water-6x6'] = {},
                    ['honeycomb-fungus'] = {},
                    ['honeycomb-fungus-1x1'] = {},
                    ['honeycomb-fungus-decayed'] = {},
                    ['split-gill-1x1'] = {},
                    ['split-gill-2x2'] = {},
                    ['split-gill-red-1x1'] = {},
                    ['split-gill-red-2x2'] = {},
                    ['veins'] = {},
                    ['veins-small'] = {},
                    ['mycelium'] = {},
                    ['coral-water'] = {},
                    ['coral-land'] = {},
                    ['black-sceptre'] = {},
                    ['pink-phalanges'] = {},
                    ['pink-lichen-decal'] = {},
                    ['green-cup'] = {},
                    ['brown-cup'] = {},
                    ['blood-grape'] = {},
                    ['brambles'] = {},
                    ['polycephalum-slime'] = {},
                    ['polycephalum-balloon'] = {},
                    ['fuchsia-pita'] = {},
                    ['wispy-lichen'] = {},
                    ['grey-cracked-mud-decal'] = {},
                    ['barnacles-decal'] = {},
                    ['nerv-roots-dense'] = {},
                    ['nerv-roots-light'] = {},
                    ['nerv-roots-veins-dense'] = {},
                    ['nerv-roots-veins-light'] = {},
                    --["tentacles"] = {},
                    --shared
                    ['light-mud-decal'] = {},
                    ['dark-mud-decal'] = {},
                    ['cracked-mud-decal'] = {},
                    ['red-desert-bush'] = {},
                    ['white-desert-bush'] = {},
                    ['red-pita'] = {},
                    ['green-bush-mini'] = {},
                    ['green-croton'] = {},
                    ['green-pita'] = {},
                    ['green-pita-mini'] = {},
                    ['lichen-decal'] = {},
                    ['shroom-decal'] = {},
                }
            },
            ['entity'] =
            {
                settings =
                {
                    ['h2o-water-shader'] = {},
                }
            }
        }
    }
end

return planet_map_gen
