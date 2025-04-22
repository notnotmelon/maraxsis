local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

data:extend {{
    type = "item",
    name = "maraxsis-oversized-steam-turbine",
    icon = "__maraxsis__/graphics/icons/oversized-steam-turbine.png",
    icon_size = 64,
    place_result = "maraxsis-oversized-steam-turbine",
    stack_size = 10,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-oversized-steam-turbine",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "item", name = "maraxsis-glass-panes", amount = 100},
        {type = "item", name = "tungsten-plate",       amount = 100},
        {type = "item", name = "processing-unit",      amount = 50},
        {type = "item", name = "steam-turbine",        amount = 3},
    },
    results = {
        {type = "item", name = "maraxsis-oversized-steam-turbine", amount = 1},
    },
    category = "maraxsis-hydro-plant",
    surface_conditions = maraxsis.surface_conditions(),
}}

local offset = 2 * 32

local vertical_animation = {
    layers = {
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-V.png",
            width = 217,
            height = 347,
            frame_count = 8,
            line_length = 4,
            shift = util.by_pixel(4.75, 6.75 - offset),
            run_mode = "backward",
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-V-shadow.png",
            width = 302,
            height = 260,
            repeat_count = 8,
            line_length = 1,
            draw_as_shadow = true,
            shift = util.by_pixel(39.5, 24.5 - offset),
            run_mode = "backward",
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-V.png",
            width = 217,
            height = 347,
            frame_count = 8,
            line_length = 4,
            shift = util.by_pixel(4.75, 6.75),
            run_mode = "backward",
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-V-shadow.png",
            width = 302,
            height = 260,
            repeat_count = 8,
            line_length = 1,
            draw_as_shadow = true,
            shift = util.by_pixel(39.5, 24.5),
            run_mode = "backward",
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-V.png",
            width = 217,
            height = 347,
            frame_count = 8,
            line_length = 4,
            shift = util.by_pixel(4.75, 6.75 + offset),
            run_mode = "backward",
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-V-shadow.png",
            width = 302,
            height = 260,
            repeat_count = 8,
            line_length = 1,
            draw_as_shadow = true,
            shift = util.by_pixel(39.5, 24.5 + offset),
            run_mode = "backward",
            scale = 0.5
        },
    }
}

local horizontal_animation = {
    layers = {
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-H.png",
            width = 320,
            height = 245,
            frame_count = 8,
            line_length = 4,
            shift = util.by_pixel(0 + offset, -2.75),
            run_mode = "backward",
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-H-shadow.png",
            width = 435,
            height = 150,
            repeat_count = 8,
            line_length = 1,
            draw_as_shadow = true,
            shift = util.by_pixel(28.5 + offset, 18),
            run_mode = "backward",
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-H.png",
            width = 320,
            height = 245,
            frame_count = 8,
            line_length = 4,
            shift = util.by_pixel(0, -2.75),
            run_mode = "backward",
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-H-shadow.png",
            width = 435,
            height = 150,
            repeat_count = 8,
            line_length = 1,
            draw_as_shadow = true,
            shift = util.by_pixel(28.5, 18),
            run_mode = "backward",
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-H.png",
            width = 320,
            height = 245,
            frame_count = 8,
            line_length = 4,
            shift = util.by_pixel(0 - offset, -2.75),
            run_mode = "backward",
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/steam-turbine/steam-turbine-H-shadow.png",
            width = 435,
            height = 150,
            repeat_count = 8,
            line_length = 1,
            draw_as_shadow = true,
            shift = util.by_pixel(28.5 - offset, 18),
            run_mode = "backward",
            scale = 0.5
        },
    }
}

data:extend {{
    type = "fluid",
    name = "maraxsis-supercritical-steam",
    icon = "__maraxsis__/graphics/icons/supercritical-steam.png",
    icon_size = 64,
    default_temperature = 2000,
    max_temperature = 20000,
    heat_capacity = ((3/2) * 50 / 900) .. "kJ",
    base_flow_rate = data.raw.fluid.steam.base_flow_rate,
    base_color = {1, 0.5, 0.5},
    flow_color = {1, 0.5, 0.75},
    gas_temperature = 365,
    auto_barrel = false,
    fuel_value = "1J"
}}

data:extend {{
    type = "recipe-category",
    name = "maraxsis-supercritical-steam"
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-supercritical-steam",
    enabled = true,
    hidden = true,
    energy_required = 0.25,
    ingredients = {
        {type = "fluid", name = "water", amount = 1}
    },
    results = {},
    category = "maraxsis-supercritical-steam",
    icon = "__maraxsis__/graphics/icons/oversized-steam-turbine.png",
}}

data:extend {{
    type = "assembling-machine",
    name = "maraxsis-oversized-steam-turbine-hidden-assembling-machine",
    fixed_recipe = "maraxsis-supercritical-steam",
    alert_icon_shift = util.by_pixel(0, -12),
    energy_source = {
        type = "fluid",
        smoke = {
            {
                name = "turbine-smoke",
                north_position = {0.0, -1.0},
                south_position = {0.0, -1.0},
                east_position = {0.75, -0.75},
                west_position = {0.75, -0.75},
                frequency = 18000,
                starting_vertical_speed = 0.08,
                starting_frame_deviation = 60
            },
            {
                name = "turbine-smoke",
                north_position = {0.0, -1.0 + 2},
                south_position = {0.0, -1.0 + 2},
                east_position = {0.75 + 2, -0.75},
                west_position = {0.75 + 2, -0.75},
                frequency = 18000,
                starting_vertical_speed = 0.08,
                starting_frame_deviation = 60
            },
            {
                name = "turbine-smoke",
                north_position = {0.0, -1.0 - 2},
                south_position = {0.0, -1.0 - 2},
                east_position = {0.75 - 2, -0.75},
                west_position = {0.75 - 2, -0.75},
                frequency = 18000,
                starting_vertical_speed = 0.08,
                starting_frame_deviation = 60
            }
        },
        fluid_box = {
            volume = 0.01,
            pipe_connections = {
                {flow_direction = "input-output", direction = defines.direction.south, position = {0, 0}, connection_type = "linked", linked_connection_id = 0},
            },
            production_type = "input",
            filter = "maraxsis-supercritical-steam",
        },
        burns_fluid = true,
        scale_fluid_usage = true,
        fluid_usage_per_tick = 1,
        effectivity = 600,
    },
    fluid_boxes = {{
        volume = 200,
        pipe_connections = {
            {flow_direction = "input-output", direction = defines.direction.north, position = {0, 0}, connection_type = "linked", linked_connection_id = 1},
        },
        production_type = "input",
        filter = "water",
    }},
    energy_usage = "1W",
    crafting_speed = 1,
    allowed_module_categories = {},
    hidden = true,
    show_recipe_icon_on_map = false,
    match_animation_speed_to_activity = false,
    trash_inventory_size = 0,
    crafting_categories = {"maraxsis-supercritical-steam"},
    selectable_in_game = false,
    collision_box = {{-1.25, -2.35 - 2}, {1.25, 2.35 + 2}},
    selection_box = {{-1.5, -2.5 - 2}, {1.5, 2.5 + 2}},
    collision_mask = {layers = {}},
    health = 1000000,
    flags = {"not-on-map"},
    icon_draw_specification = {scale = 0}
}}

data:extend {{
    type = "fusion-generator",
    name = "maraxsis-oversized-steam-turbine",
    icon = "__maraxsis__/graphics/icons/oversized-steam-turbine.png",
    maraxsis_buildability_rules = {water = false, dome = true, coral = false, trench = true, trench_entrance = false, trench_lava = false},
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.5, result = "maraxsis-oversized-steam-turbine"},
    max_health = 1000,
    corpse = "steam-turbine-remnants",
    dying_explosion = "steam-turbine-explosion",
    alert_icon_shift = util.by_pixel(0, -12),
    resistances = {
        {
            type = "fire",
            percent = 70
        }
    },
    max_fluid_usage = 300 / second, -- at normal quality
    collision_box = {{-1.25, -2.35 - 2}, {1.25, 2.35 + 2}},
    selection_box = {{-1.5, -2.5 - 2}, {1.5, 2.5 + 2}},
    damaged_trigger_effect = hit_effects.entity(),
    input_fluid_box = {
        volume = 200,
        pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures,
        pipe_picture_frozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen,
        pipe_covers = pipecoverspictures(),
        secondary_draw_orders = {north = -1, east = -1, west = -1},
        pipe_connections = {
            {flow_direction = "input-output", direction = defines.direction.south, position = {0, 4},   connection_category = "maraxsis-salt-reactor"},
            {flow_direction = "input-output", direction = defines.direction.east,  position = {1, 2},   connection_category = "maraxsis-salt-reactor"},
            {flow_direction = "input-output", direction = defines.direction.west,  position = {-1, -2}, connection_category = "maraxsis-salt-reactor"},
            {flow_direction = "input-output", direction = defines.direction.south, position = {0, 0},   connection_type = "linked",                   linked_connection_id = 0},
        },
        production_type = "input",
        filter = "maraxsis-supercritical-steam",
    },
    output_fluid_box = {
        volume = 200,
        pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures,
        pipe_picture_frozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen,
        pipe_covers = pipecoverspictures(),
        secondary_draw_orders = {north = -1, east = -1, west = -1},
        pipe_connections = {
            {flow_direction = "input-output", direction = defines.direction.north, position = {0, -4}},
            {flow_direction = "input-output", direction = defines.direction.east,  position = {1, -2}},
            {flow_direction = "input-output", direction = defines.direction.west,  position = {-1, 2}},
            {flow_direction = "input-output", direction = defines.direction.north, position = {0, 0}, connection_type = "linked", linked_connection_id = 1},
        },
        production_type = "output",
        filter = "water"
    },
    energy_source = {
        type = "electric",
        usage_priority = "secondary-output",
        output_flow_limit = "50MW",
    },
    graphics_set = {
        north_graphics_set = {animation = vertical_animation, fluid_input_graphics = {{}, {}, {}, {}}},
        south_graphics_set = {animation = vertical_animation, fluid_input_graphics = {{}, {}, {}, {}}},
        east_graphics_set = {animation = horizontal_animation, fluid_input_graphics = {{}, {}, {}, {}}},
        west_graphics_set = {animation = horizontal_animation, fluid_input_graphics = {{}, {}, {}, {}}},
    },
    impact_category = "metal-large",
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    working_sound = {
        sound = {
            filename = "__base__/sound/steam-turbine.ogg",
            volume = 0.49,
            modifiers = volume_multiplier("main-menu", 0.7),
            speed_smoothing_window_size = 60,
            advanced_volume_control = {attenuation = "exponential"},
            audible_distance_modifier = 0.8,
        },
        match_speed_to_activity = true,
        max_sounds_per_prototype = 3,
        fade_in_ticks = 4,
        fade_out_ticks = 20
    },
    perceived_performance = {minimum = 0.25, performance_to_activity_rate = 1.0},
}}

for _, pump in pairs{"duct-intake", "duct-exhaust"} do
    pump = data.raw["pump"][pump]
    pump.fluid_box.pipe_connections = table.deepcopy(pump.fluid_box.pipe_connections)
    for _, pipe_connection in pairs(pump.fluid_box.pipe_connections) do
        if pipe_connection.connection_category == nil then
            pipe_connection.connection_category = {"default", "maraxsis-salt-reactor"}
        elseif type(pipe_connection.connection_category) == "string" then
            pipe_connection.connection_category = {pipe_connection.connection_category}
        end
        
        if not table.find(pipe_connection.connection_category, "ducts") then
            table.insert(pipe_connection.connection_category, "maraxsis-salt-reactor")
        end
    end
end
