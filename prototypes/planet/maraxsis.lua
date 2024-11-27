local planet_map_gen = require("prototypes/planet/planet-map-gen")
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

data:extend {maraxsis.merge(data.raw.planet.gleba, {
    name = "maraxsis",
    starting_area = 1,
    surface_properties = {
        ["day-night-cycle"] = 5 * minute,
        ["magnetic-field"] = 25,
        ["solar-power"] = 1,
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
        pressure = 300000,
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
    orientation = 0.5,
    auto_save_on_first_trip = false,
    asteroid_spawn_definitions = "nil",
    flying_robot_energy_usage_multiplier = 1.5, -- todo: this doesnt work
})}

data:extend {{
    type = "space-connection",
    name = "vulcanus-maraxsis",
    subgroup = "planet-connections",
    from = "maraxsis",
    to = "vulcanus",
    order = "f",
    length = 30000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
}}
