require "maraxsis-noise-expressions"
require "trench-noise-expressions"

local asteroid_util = require "__space-age__.prototypes.planet.asteroid-spawn-definitions"
local planet_map_gen = require "map-gen"

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
    solar_power_in_space = 150,
    player_effects = "nil",
    map_gen_settings = planet_map_gen.maraxsis(),
    distance = 15,
    draw_orbit = false,
    orientation = 0.515,
    flying_robot_energy_usage_multiplier = 1.5, -- todo: this doesnt work
})}

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
    hidden = true,
    icon = "__maraxsis__/graphics/technology/maraxsis-trench.png",
    icon_size = 256,
    order = "ce[maraxsis]-[trench]",
    pollutant_type = "nil",
    draw_orbit = false,
    solar_power_in_space = 150,
    map_gen_settings = planet_map_gen["maraxsis-trench"](),
    distance = 15.6,
    label_orientation = 0.3,
    magnitude = 0.65,
    player_effects = "nil",
    orientation = 0.5,
    auto_save_on_first_trip = false,
    asteroid_spawn_definitions = "nil",
    flying_robot_energy_usage_multiplier = 1.5, -- todo: this doesnt work
})}

data.raw.planet["maraxsis-trench"].persistent_ambient_sounds.wind = {
    sound = {
        filename = "__maraxsis__/sounds/trench-ambiance.ogg",
        volume = 0.8
    },
}

data.raw.planet["maraxsis"].persistent_ambient_sounds.wind = {
    sound = {
        filename = "__maraxsis__/sounds/maraxsis-ambiance.ogg",
        volume = 0.8,
        speed = 0.5
    },
}

data:extend {{
    type = "space-connection",
    name = "vulcanus-maraxsis",
    subgroup = "planet-connections",
    from = "vulcanus",
    to = "maraxsis",
    order = "f",
    length = 20000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
}}

data:extend {{
    type = "space-connection",
    name = "fulgora-maraxsis",
    subgroup = "planet-connections",
    from = "fulgora",
    to = "maraxsis",
    order = "f",
    length = 20000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
}}

if data.raw["planet"]["tenebris"] then
    data:extend {{
        type = "space-connection",
        name = "maraxsis-tenebris",
        subgroup = "planet-connections",
        from = "maraxsis",
        to = "tenebris",
        order = "g",
        length = 20000,
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
    }}
end

