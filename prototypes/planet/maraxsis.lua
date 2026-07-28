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
        ["solar-power"] = 50,
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
    solar_power_in_space = 150,
    map_gen_settings = planet_map_gen.maraxsis(),
    draw_orbit = false,
    subgroup = "planets",
    order = "e-z[maraxsis]",
    persistent_ambient_sounds = {},
    platform_surface_render_parameters = {
        platform_backdrop = {
            cloudiness = 1.0,
            surface_vertical_offset = 0.1,
            cloud_vertical_offset = 0.015,
            specular_intensity = 1,
            atmosphere_color = { 0.055, 0.09, 0.11, 0.1 },
            cloud_flow_intensity = 0.5,
            cloud_panning_rate = 0.5,
            rotation_seconds = -220,
            planet_axis = { -15.0, 212.0 },
            planet_axis_deviation_amplitude = { 10.0, 10.0 },
            planet_axis_deviation_seconds = { 390.5, 353.7 },
            position = { -680, 601 },
            parallax_strength = { 0.95, 0.95 },
            light_direction = { -0.42, 0.23, 0.67 },
            light_radius = 8.9,
            atmosphere_thickness = 0.02,
            light_intensity_contrast = 0.3,
            radius = 625,
            planet_surface = {
                filename = "__maraxsis__/graphics/planets/maraxsis-surface.png",
                width = 2048,
                height = 1024,
                allow_forced_downscale = true

            },
            planet_normal = {
                filename = "__maraxsis__/graphics/planets/maraxsis-reflectivity.png",
                width = 1,
                height = 1,
                x = 1,
                y = 0,
                allow_forced_downscale = true
            },
            planet_reflectivity = {
                filename = "__maraxsis__/graphics/planets/maraxsis-reflectivity.png",
                width = 1,
                height = 1,
                x = 2,
                y = 0,
                allow_forced_downscale = true
            },
            global_cloud = {
                filename = "__maraxsis__/graphics/planets/maraxsis-cloud.png",
                width = 2048,
                height = 1024,
                allow_forced_downscale = true
            },
            global_cloud_normal = {
                filename = "__maraxsis__/graphics/planets/maraxsis-cloud-normal.png",
                width = 2048,
                height = 1024,
                allow_forced_downscale = true
            },
            global_cloud_flow = {
                filename = "__space-age__/graphics/space/aquilo-cloud-flow.png",
                width = 2048,
                height = 1024,
                allow_forced_downscale = true
            }
        }
    }
}

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

data:extend {{
    type = "technology",
    name = "planet-discovery-maraxsis",
    icons = util.technology_icon_constant_planet("__maraxsis__/graphics/technology/maraxsis.png"),
    icon_size = 256,
    essential = true,
    localised_description = {"space-location-description.maraxsis"},
    effects = {
        {
            type = "unlock-space-location",
            space_location = "maraxsis",
            use_icon_overlay_constant = true
        },
        {
            type = "unlock-space-location",
            space_location = "maraxsis-trench",
            use_icon_overlay_constant = true
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-diesel-submarine",
        },
    },
    prerequisites = {
        "advanced-asteroid-processing",
        "rocket-turret",
        "cliff-explosives",
        "electromagnetic-science-pack",
        "quality-module-3",
        "fish-breeding"
    },
    unit = {
        count = 3000,
        ingredients = {
            {"automation-science-pack",      1},
            {"logistic-science-pack",        1},
            {"chemical-science-pack",        1},
            {"space-science-pack",           1},
            {"production-science-pack",      1},
            {"utility-science-pack",         1},
            {"metallurgic-science-pack",     1},
            {"electromagnetic-science-pack", 1},
            {"agricultural-science-pack",    1},
        },
        time = 60,
    },
    order = "ea[maraxsis]",
}}

if settings.startup["sp-enable-spiderling"].value then
    table.insert(data.raw.technology["planet-discovery-maraxsis"].prerequisites, "sp-spidertron-automation")
end
