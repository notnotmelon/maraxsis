local planet_map_gen = require "map-gen"

local surface_properties = table.deepcopy(data.raw.planet.maraxsis.surface_properties)
surface_properties.pressure = 800000

data:extend { maraxsis.merge(data.raw.planet.gleba, {
    name = "maraxsis-trench",
    starting_area = 1,
    surface_properties = surface_properties,
    hidden = true,
    hidden_in_factoriopedia = false,
    icon = "__maraxsis__/graphics/planets/maraxsis-trench.png",
    icon_size = 256,
    order = "e-z[maraxsis]-[trench]",
    pollutant_type = "nil",
    draw_orbit = false,
    solar_power_in_space = 0,
    map_gen_settings = planet_map_gen["maraxsis-trench"](),
    distance = 0,
    label_orientation = 0,
    magnitude = 1,
    player_effects = "nil",
    orientation = 0,
    auto_save_on_first_trip = false,
    asteroid_spawn_definitions = "nil",
}) }
