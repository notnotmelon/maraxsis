require "maraxsis-noise-expressions"
require "trench-noise-expressions"

local asteroid_util = require "__space-age__.prototypes.planet.asteroid-spawn-definitions"
local planet_map_gen = require "map-gen"

PlanetsLib:extend{
    type = "planet",
    name = "maraxsis",
    starting_area = 1,
    surface_properties = {
        ["day-night-cycle"] = 5 * minute,
        ["magnetic-field"] = 25,
        ["solar-power"] = 100,
        ["robot-energy-usage"] = 5,
        pressure = 200000,
        gravity = 20,
    },
    is_satellite = false,
    orbit = {
        distance = 17.5,
        orientation = 0.515,
        parent = {type = "space-location", name = "star"}
    },
    starmap_icon = "__maraxsis__/graphics/planets/maraxsis-starmap-icon.png",
    starmap_icon_size = 512,
    icon = "__maraxsis__/graphics/planets/maraxsis.png",
    icon_size = 256,
    solar_power_in_space = 75,
    map_gen_settings = planet_map_gen.maraxsis(),
    draw_orbit = false,
    subgroup = "planets",
    order = "e-z[maraxsis]",
    persistent_ambient_sounds = {},
    flying_robot_energy_usage_multiplier = 1.5, -- todo: this doesnt work
    platform_surface_render_parameters = {
        platform_backdrop = {
            cloudiness = 0.5,
            surface_vertical_offset = 0.1,
            cloud_vertical_offset = 0.015,
            specular_intensity = 1,
            atmosphere_color = { 0.055, 0.09, 0.11, 0.1 },
            cloud_flow_intensity = 0.5,
            cloud_panning_rate = -0.1,
            rotation_seconds = -660,
            planet_axis = { -33.0, -3.0 },
            planet_axis_deviation_amplitude = { 10.0, 10.0 },
            planet_axis_deviation_seconds = { 890.5, 753.7 },
            position = { -680, 601 },
            parallax_strength = { 0.95, 0.95 },
            light_direction = { -0.42, 0.23, 0.67 },
            light_radius = 8.9,
            light_intensity_contrast = 0.3,
            radius = 600,
            planet_surface =
            {
                filename = "__maraxsis__/graphics/planets/maraxsis-surface.png",
                width = 1,
                height = 1,
                x = 0,
                y = 0

            },
            planet_normal =
            {
                filename = "__maraxsis__/graphics/planets/maraxsis-surface.png",
                width = 1,
                height = 1,
                x = 1,
                y = 0
            },
            planet_reflectivity =
            {
                filename = "__maraxsis__/graphics/planets/maraxsis-surface.png",
                width = 1,
                height = 1,
                x = 2,
                y = 0
            }, --]]
            global_cloud =
            {
                filename = "__space-age__/graphics/space/nauvis-cloud.png",
                width = 2048,
                height = 1024
            },
            global_cloud_normal =
            {
                filename = "__space-age__/graphics/space/nauvis-cloud-normal.png",
                width = 2048,
                height = 1024
            },
            global_cloud_flow =
            {
                filename = "__space-age__/graphics/space/nauvis-cloud-flow.png",
                width = 2048,
                height = 1024
            }
        }
    }
}


data:extend { maraxsis.merge(data.raw.planet.gleba, {
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
}) }

data:extend { {
    type = "space-connection",
    name = "vulcanus-maraxsis",
    subgroup = "planet-connections",
    from = "vulcanus",
    to = "maraxsis",
    order = "f",
    length = 20000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
} }

data:extend { {
    type = "space-connection",
    name = "fulgora-maraxsis",
    subgroup = "planet-connections",
    from = "fulgora",
    to = "maraxsis",
    order = "f",
    length = 20000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
} }

if data.raw["planet"]["tenebris"] then
    data:extend { {
        type = "space-connection",
        name = "maraxsis-tenebris",
        subgroup = "planet-connections",
        from = "maraxsis",
        to = "tenebris",
        order = "g",
        length = 20000,
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
    } }
end
