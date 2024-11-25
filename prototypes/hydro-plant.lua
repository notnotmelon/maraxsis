local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

local working_visualisations = {
    {
        always_draw = true,
        animation = {
            filename = "__maraxsis__/graphics/entity/hydro-plant/hydro-plant.png",
            priority = "high",
            width = 2560 / 8,
            height = 2960 / 8,
            shift = {0, -0.5},
            frame_count = 60,
            line_length = 8,
            animation_speed = 1,
            scale = 0.5,
            flags = {"no-scale"}
        },
    },
    {
        always_draw = true,
        animation = {
            filename = "__maraxsis__/graphics/entity/hydro-plant/sh.png",
            priority = "high",
            width = 600,
            height = 400,
            shift = util.by_pixel(10, -12),
            frame_count = 1,
            line_length = 1,
            animation_speed = 1,
            scale = 0.5,
            draw_as_shadow = true,
        },
    },
    {
        constant_speed = true,
        light = {
            intensity = 0.65,
            size = 4,
            shift = {1.29, 2},
            color = {r = 1, g = 0.35, b = 0.2},
        },
    },
}

data:extend {{
    type = "recipe-category",
    name = "h2o-hydro-plant",
}}

data:extend {{
    type = "recipe-category",
    name = "h2o-science-packs",
}}

data:extend {{
    type = "recipe-category",
    name = "h2o-hydro-plant-or-assembling",
}}

data:extend {{
    type = "assembling-machine",
    name = "h2o-hydro-plant",
    icon = "__maraxsis__/graphics/icons/hydro-plant.png",
    icon_size = 64,
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 1, results = {{type = "item", name = "h2o-hydro-plant", amount = 1}}},
    max_health = 400,
    corpse = data.raw["assembling-machine"]["electromagnetic-plant"].corpse,
    dying_explosion = "big-explosion",
    resistances = {
        {type = "physical", percent = 50},
        {type = "fire",     percent = 100},
        {type = "impact",   percent = 80},
    },
    heating_energy = "2000kW",
    module_slots = 3,
    icons_positioning = {
        {inventory_index = defines.inventory.furnace_modules, shift = {0, 1}}
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution", "quality"},
    water_reflection = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").water_reflection,
    collision_box = {{-1.9, -1.9}, {1.9, 1.9}},
    selection_box = {{-2, -2}, {2, 2}},
    effect_receiver = {base_effect = {productivity = 0.5}},
    drawing_box_vertical_extension = 1,
    damaged_trigger_effect = hit_effects.entity(),
    fluid_boxes = {
        {
            production_type = "input",
            pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures,
            pipe_picture_frozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen,
            pipe_covers = pipecoverspictures(),
            volume = 100,
            pipe_connections = {{direction = defines.direction.south, flow_direction = "input", position = {-0.5, 1.5}}},
            secondary_draw_orders = {north = -1},
        },
        {
            production_type = "input",
            pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures,
            pipe_picture_frozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen,
            pipe_covers = pipecoverspictures(),
            volume = 100,
            pipe_connections = {{direction = defines.direction.east, flow_direction = "input", position = {1.5, -0.5}}},
            secondary_draw_orders = {north = -1},
        },
        {
            production_type = "output",
            pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures,
            pipe_picture_frozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen,
            pipe_covers = pipecoverspictures(),
            volume = 100,
            pipe_connections = {{direction = defines.direction.north, flow_direction = "output", position = {0.5, -1.5}}},
            secondary_draw_orders = {north = -1},
        },
        {
            production_type = "output",
            pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures,
            pipe_picture_frozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen,
            pipe_covers = pipecoverspictures(),
            volume = 100,
            pipe_connections = {{direction = defines.direction.west, flow_direction = "output", position = {-1.5, 0.5}}},
            secondary_draw_orders = {north = -1},
        },
    },
    perceived_performance = {minimum = 0.25, performance_to_activity_rate = 2.0, maximum = 10},
    off_when_no_fluid_recipe = true,
    graphics_set = {
        working_visualisations = working_visualisations
    },
    crafting_categories = {"h2o-hydro-plant", "h2o-science-packs", "h2o-hydro-plant-or-assembling"},
    scale_entity_info_icon = true,
    impact_category = data.raw["assembling-machine"]["electromagnetic-plant"].impact_category,
    --[[working_sound = {
        filename = path .. 'advanced-furnace.ogg',
        volume = 0.50,
        aggregation = {
            max_count = 2,
            remove = false,
            count_already_playing = true,
        },
    },--]]
    idle_sound = {filename = "__base__/sound/idle1.ogg"},
    crafting_speed = 2,
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        emissions_per_minute = {
            pollution = 6,
        }
    },
    energy_usage = "2MW",
    module_specification = {module_slots = 4, module_info_icon_shift = {0, 1.7}, module_info_icon_scale = 1},
    allowed_effects = {"consumption", "speed", "productivity", "pollution"}, -- todo: add quality
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    collision_mask = {layers = {["item"] = true, ["object"] = true, ["player"] = true}},
}}

local extra_module_slots = table.deepcopy(data.raw["assembling-machine"]["h2o-hydro-plant"])
extra_module_slots.name = "h2o-hydro-plant-extra-module-slots"
extra_module_slots.module_specification.module_slots = extra_module_slots.module_specification.module_slots + 2
extra_module_slots.module_specification.module_info_icon_scale = 0.8
extra_module_slots.placeable_by = {{item = "h2o-hydro-plant", count = 1}}
extra_module_slots.localised_name = {"entity-name.h2o-hydro-plant"}
extra_module_slots.localised_description = {"entity-description.h2o-hydro-plant"}
extra_module_slots.flags = {"placeable-player", "player-creation", "not-in-made-in"}
data:extend {extra_module_slots}

data:extend {{
    type = "item",
    name = "h2o-hydro-plant",
    icon = "__maraxsis__/graphics/icons/hydro-plant.png",
    icon_size = 64,
    place_result = "h2o-hydro-plant",
    stack_size = 50,
    scale = 0.5,
}}

data:extend {{
    type = "recipe",
    name = "h2o-hydro-plant",
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = "item", name = "steel-plate",      amount = 20},
        {type = "item", name = "stone-brick",      amount = 20},
        {type = "item", name = "advanced-circuit", amount = 10},
        {type = "item", name = "pipe",             amount = 10},
    },
    results = {
        {type = "item", name = "h2o-hydro-plant", amount = 1},
    },
    category = "h2o-hydro-plant-or-assembling",
}}
