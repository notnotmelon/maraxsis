require "maraxsis-noise-expressions"
require "trench-noise-expressions"

local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

local entity_spawn_settings = {
    ["maraxsis-coral"] = {},
    ["big-sand-rock-underwater"] = {}
}

for _, tropical_fish in pairs(maraxsis.tropical_fish_names) do
    entity_spawn_settings[tropical_fish] = {}
end

local planet_map_gen = {}

planet_map_gen.maraxsis = function()
    return {
        terrain_segmentation = 1,
        water = 0,
        property_expression_names = {
            elevation = "maraxsis_surface_elevation",
            temperature = "temperature_basic",
            moisture = "maraxsis_surface_moisture",
            aux = "aux_basic",
            cliffiness = "1",
            cliff_elevation = "cliff_elevation_from_elevation",
        },
        cliff_settings = {
            name = "cliff-maraxsis-collisionless",
            cliff_elevation_0 = 0.03,
            cliff_elevation_interval = 0.1,
            cliff_smoothing = 0, -- This is critical for correct cliff placement on the trench entrance.
            richness = 0.98
        },
        autoplace_controls = {
            ["maraxsis-coral"] = {},
        },
        autoplace_settings = {
            ["tile"] = {
                settings = {
                    ["maraxsis-trench-entrance"] = {},
                    ["sand-1-underwater"] = {},
                    ["sand-2-underwater"] = {},
                    ["sand-3-underwater"] = {},
                    ["dirt-5-underwater"] = {},
                    ["lowland-cream-red-underwater"] = {},
                }
            },
            ["decorative"] = {
                settings = {
                    ["urchin-cactus"] = {},

                    -- nauvis decoratives
                    ["v-red-pita"] = {},
                    ["sand-dune-decal"] = {},
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
                    ["blood-grape-vibrant"] = {},
                    ["brambles"] = {},
                    ["polycephalum-slime"] = {},
                    ["polycephalum-balloon"] = {},
                    ["fuchsia-pita"] = {},
                    ["wispy-lichen"] = {},
                    ["grey-cracked-mud-decal"] = {},
                    ["barnacles-decal"] = {},
                    ["nerve-roots-dense"] = {},
                    ["nerve-roots-sparse"] = {},
                    --shared
                    ["light-mud-decal"] = {},
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

planet_map_gen.maraxsis_trench = function()
    return {
        terrain_segmentation = 1,
        water = 0,
        property_expression_names = {
            elevation = "maraxsis_trench_elevation",
            temperature = "temperature_basic",
            moisture = "1",
            aux = "aux_basic",
            cliffiness = "1",
            cliff_elevation = "cliff_elevation_from_elevation",
        },
        autoplace_controls = {
        },
        autoplace_settings = {
            ["tile"] = {
                settings = {
                    ["lava-hot-underwater"] = {},
                    ["volcanic-cracks-hot-underwater"] = {},
                    ["volcanic-cracks-warm-underwater"] = {},
                    ["volcanic-folds-underwater"] = {},
                    ["out-of-map"] = {},
                }
            },
            ["decorative"] = {
                settings = {
                    ["urchin-cactus"] = {},

                    -- nauvis decoratives
                    ["v-red-pita"] = {},
                    ["sand-dune-decal"] = {},
                    ["grey-cracked-mud-decal"] = {},
                    ["vulcanus-lava-fire"] = {},
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
                    ["vulcanus-crack-decal"] = {},
                    ["vulcanus-crack-decal-huge-warm"] = {},
                    ["vulcanus-crack-decal-warm"] = {},
                    ["vulcanus-rock-decal-large"] = {},
                    ["vulcanus-sand-decal"] = {},

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
                    ["split-gill-dying-1x1"] = {},
                    ["split-gill-dying-2x2"] = {},
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
                    ["blood-grape-vibrant"] = {},
                    ["brambles"] = {},
                    ["polycephalum-balloon"] = {},
                    ["fuchsia-pita"] = {},
                    ["wispy-lichen"] = {},
                    ["grey-cracked-mud-decal"] = {},
                    ["barnacles-decal"] = {},
                    ["solo-barnacle"] = {},
                    ["nerve-roots-dense"] = {},
                    ["nerve-roots-sparse"] = {},
                    --shared
                    ["light-mud-decal"] = {},
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
                settings = {
                    ["maraxsis-lava-lamp"] = {},
                    ["maraxsis-trench-wall-collisionless"] = {},
                    ["vulcanus-chimney-short"] = {},
                    ["vulcanus-chimney-truncated"] = {},
                    ["maraxsis-chimney"] = {},
                    ["vulcanus-chimney-cold"] = {},
                    ["vulcanus-chimney-faded"] = {},
                },
            },
        }
    }
end

data:extend {maraxsis.merge(data.raw.planet.gleba, {
    name = "maraxsis",
    starting_area = 1,
    surface_properties = {
        ["day-night-cycle"] = 5 * minute,
        ["magnetic-field"] = 25,
        ["solar-power"] = 100,
        pressure = 200000,
        gravity = 20,
    },
    starmap_icon = "__maraxsis__/graphics/planets/maraxsis-starmap-icon.png",
    starmap_icon_size = 512,
    icon = "__maraxsis__/graphics/planets/maraxsis.png",
    icon_size = 256,
    order = "ce[maraxsis]",
    pollutant_type = "nil",
    player_effects = "nil",
    solar_power_in_space = 150,
    map_gen_settings = planet_map_gen.maraxsis(),
    distance = 15,
    draw_orbit = false,
    orientation = 0.515,
    flying_robot_energy_usage_multiplier = 1.5, -- todo: this doesnt work
})}

if mods["hd_planets"] then
    data.raw["planet"]["maraxsis"].starmap_icon = "__maraxsis__/graphics/planets/maraxsis-hd.png"
    data.raw["planet"]["maraxsis"].starmap_icon_size = 4072
end

data:extend {maraxsis.merge(data.raw.planet.gleba, {
    name = "maraxsis-trench",
    starting_area = 1,
    surface_properties = {
        ["day-night-cycle"] = 5 * minute,
        ["magnetic-field"] = 25,
        ["solar-power"] = 0,
        pressure = 400000,
        gravity = 20,
    },
    starmap_icon = "__maraxsis__/graphics/planets/maraxsis-trench.png",
    starmap_icon_size = 512,
    icon = "__maraxsis__/graphics/technology/maraxsis-trench.png",
    icon_size = 256,
    order = "ce[maraxsis]-[trench]",
    pollutant_type = "nil",
    draw_orbit = false,
    solar_power_in_space = 150,
    map_gen_settings = planet_map_gen.maraxsis_trench(),
    distance = 15.6,
    label_orientation = 0.3,
    magnitude = 0.65,
    player_effects = "nil",
    orientation = 0.5,
    auto_save_on_first_trip = false,
    asteroid_spawn_definitions = "nil",
    flying_robot_energy_usage_multiplier = 1.5, -- todo: this doesnt work
})}

data:extend {{
    type = "space-connection",
    name = "vulcanus-maraxsis",
    subgroup = "planet-connections",
    from = "vulcanus",
    to = "maraxsis",
    order = "f",
    length = 30000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
}}

if mods.tenebris then
    data:extend {{
        type = "space-connection",
        name = "maraxsis-tenebris",
        subgroup = "planet-connections",
        from = "maraxsis",
        to = "tenebris",
        order = "g",
        length = 30000,
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
    }}
else
    data:extend {{
        type = "space-connection",
        name = "fulgora-maraxsis",
        subgroup = "planet-connections",
        from = "fulgora",
        to = "maraxsis",
        order = "f",
        length = 30000,
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
    }}
end
