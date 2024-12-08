local regulator = data.raw.roboport["service_station"]

regulator.logistics_connection_distance = 90
regulator.radar_range = 2
regulator.logistics_radius = 30
regulator.construction_radius = 60
regulator.base_animation = nil
regulator.base = nil
regulator.base_patch = nil
regulator.frozen_patch = nil
regulator.door_animation_up = nil
regulator.door_animation_down = nil
regulator.hidden = false
regulator.drawing_box_vertical_extension = 0.75
regulator.integration_patch = {
    layers = {
        {
            filename = "__maraxsis__/graphics/entity/regulator/regulator.png",
            priority = "high",
            width = 1680 / 8,
            height = 2320 / 8,
            shift = {0, -0.5},
            frame_count = 60,
            line_length = 8,
            animation_speed = 1,
            scale = 0.5 * 4 / 3,
            flags = {"no-scale"}
        },
        {
            filename = "__maraxsis__/graphics/entity/regulator/sh.png",
            priority = "high",
            width = 400,
            height = 350,
            shift = util.by_pixel(0, -16),
            frame_count = 1,
            line_length = 1,
            repeat_count = 60,
            animation_speed = 1,
            scale = 0.5 * 4 / 3,
            draw_as_shadow = true,
        }
    }
}
regulator.integration_patch_render_layer = "object-under"
regulator.placeable_by = {item = "maraxsis-pressure-dome", count = 1}
regulator.minable = nil
regulator.icon = "__maraxsis__/graphics/icons/regulator.png"
regulator.icon_size = 64
regulator.surface_conditions = maraxsis.surface_conditions()
regulator.circuit_connector = circuit_connector_definitions["maraxsis-regulator"]
regulator.circuit_wire_max_distance = _G.default_circuit_wire_max_distance

data.raw.recipe["service_station"].hidden = true
data.raw.item["service_station"].hidden = true
data.raw.item["service_station"].place_result = nil

data:extend {{
    type = "assembling-machine",
    name = "maraxsis-regulator-fluidbox",
    icon = "__maraxsis__/graphics/icons/regulator.png",
    icon_size = 64,
    flags = {"placeable-neutral", "player-creation", "not-on-map"},
    minable = nil,
    hidden = true,
    quality_indicator_scale = 0,
    max_health = 99999,
    collision_mask = {layers = {}},
    factoriopedia_alternative = "service_station",
    collision_box = {{-1.9, -1.9}, {1.9, 1.9}},
    crafting_categories = {"maraxsis-regulator"},
    crafting_speed = 1,
    energy_usage = "500kW",
    icon_draw_specification = {scale = 0, scale_for_many = 0},
    fixed_recipe = "maraxsis-regulator",
    energy_source = {
        type = "fluid",
        burns_fluid = false,
        scale_fluid_usage = false,
        destroy_non_fuel_fluid = false,
        maximum_temperature = 0,
        fluid_box = {
            production_type = "input",
            pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures,
            pipe_picture_frozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen,
            pipe_covers = pipecoverspictures(),
            volume = 100,
            pipe_connections = {
                {position = {0.5, -1.5},  direction = defines.direction.north, flow_direction = "input-output"},
                {position = {-0.5, 1.5},  direction = defines.direction.south, flow_direction = "input-output"},
                {position = {1.5, 0.5},   direction = defines.direction.east,  flow_direction = "input-output"},
                {position = {-1.5, -0.5}, direction = defines.direction.west,  flow_direction = "input-output"},
            },
            filter = "maraxsis-atmosphere",
            secondary_draw_orders = {north = -1},
        },
        smoke = {
            {
                name = "maraxsis-swimming-bubbles",
                frequency = 100,
                position = {-0.9, -2.7},
                starting_vertical_speed = 0.03
            }
        }
    },
    effect_receiver = {
        uses_module_effects = false,
        uses_beacon_effects = false,
        uses_surface_effects = false,
    },
    graphics_set = {
        animation = {
            layers = {
                {
                    filename = "__maraxsis__/graphics/entity/regulator/regulator.png",
                    priority = "high",
                    width = 1680 / 8,
                    height = 2320 / 8,
                    shift = {0, -0.5},
                    frame_count = 60,
                    line_length = 8,
                    animation_speed = 1.5,
                    scale = 0.5 * 4 / 3,
                    flags = {"no-scale"}
                },
                {
                    filename = "__maraxsis__/graphics/entity/regulator/sh.png",
                    priority = "high",
                    width = 400,
                    height = 350,
                    shift = util.by_pixel(0, -16),
                    frame_count = 1,
                    line_length = 1,
                    repeat_count = 60,
                    animation_speed = 1.5,
                    scale = 0.5 * 4 / 3,
                    draw_as_shadow = true,
                }
            }
        }
    }
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-regulator",
    enabled = false,
    hidden = true,
    energy_required = 100,
    ingredients = {},
    results = {},
    category = "maraxsis-regulator",
    subgroup = "fluid",
    order = "a[fluid]-a[maraxsis-atmosphere]-a[regulator]",
    icon = "__maraxsis__/graphics/icons/atmosphere.png",
    icon_size = 64,
}}

data:extend {{
    type = "recipe-category",
    name = "maraxsis-regulator",
}}
