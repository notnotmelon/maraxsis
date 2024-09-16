local path = '__maraxsis__/graphics/entity/quantum-computer/'

local hit_effects = require('__base__/prototypes/entity/hit-effects')
local sounds = require('__base__/prototypes/entity/sounds')

local animation_speed = 0.6

local animation = {
    layers = {
        {
            filename = path .. 'hr-singularity-lab-glow-light.png',
            priority = 'high',
            width = 153,
            height = 117,
            shift = {0, -0.8},
            frame_count = 60,
            line_length = 6,
            scale = 0.5,
            animation_speed = animation_speed,
            draw_as_light = true,
        },
        {
            filename = path .. 'hr-singularity-lab-glow.png',
            priority = 'high',
            width = 153,
            height = 117,
            shift = {0, -0.8},
            frame_count = 60,
            line_length = 6,
            scale = 0.5,
            animation_speed = animation_speed,
            blend_mode = 'additive',
        },
        {
            filename = path .. 'hr-singularity-lab-light.png',
            priority = 'high',
            width = 520,
            height = 500,
            shift = {0.0, -0.1},
            draw_as_light = true,
            frame_count = 1,
            repeat_count = 60,
            scale = 0.5,
        },
        {
            filename = path .. 'hr-singularity-lab-working.png',
            width = 520,
            height = 500,
            shift = {0.0, -0.1},
            frame_count = 60,
            line_length = 10,
            scale = 0.5,
            animation_speed = animation_speed,
        },
        {
            filename = path .. 'hr-singularity-lab-sh.png',
            priority = 'medium',
            width = 548,
            height = 482,
            shift = {0.22, 0.18},
            frame_count = 1,
            repeat_count = 60,
            draw_as_shadow = true,
            scale = 0.5,
        },
    },
}

data:extend {{
    type = 'recipe-category',
    name = 'h2o-quantum-computer',
}}

data:extend {{
    type = 'assembling-machine',
    fixed_recipe = 'h2o-heart-of-the-sea',
    name = 'h2o-quantum-computer',
    icon = path .. 'singularity-lab.png',
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {'placeable-player', 'player-creation', 'hide-alt-info', 'not-rotatable'},
    minable = {mining_time = 2, result = 'h2o-quantum-computer'},
    max_health = 2000,
    damaged_trigger_effect = hit_effects.entity(),
    dying_explosion = 'big-explosion',
    corpse = 'kr-big-random-pipes-remnant',
    resistances = {
        {type = 'physical', percent = 60},
        {type = 'fire',     percent = 100},
        {type = 'impact',   percent = 90},
    },
    collision_box = {{-3.75, -3.75}, {3.75, 3.75}},
    selection_box = {{-3.9, -3.9}, {3.9, 3.9}},
    collision_mask = {layers = {
        ['item'] = true,
        ['object'] = true,
        ['player'] = true,
        
    }},
    fast_replaceable_group = 'assembling-machine',
    scale_entity_info_icon = true,
    working_visualisations = {{
        constant_speed = true,
        always_draw = true,
        animation = animation,
    }},
    fluid_boxes = {
        {
            production_type = 'input',
            pipe_picture = furnacekpipepictures_a(),
            pipe_covers = pipecoverspictures(),
            volume = 50,
            pipe_connections = {{direction = defines.direction.west, flow_direction = 'input', position = {-3.75, -0.5}}, {direction = defines.direction.east, flow_direction = 'input', position = {3.75, -0.5}}},
            secondary_draw_orders = {north = -1},
        },
    },
    vehicle_impact_sound = sounds.generic_impact,
    working_sound = {
        sound = {
            filename = path .. 'singularity-lab.ogg',
            volume = 0.5,
        },
        idle_sound = {
            filename = path .. 'singularity-lab.ogg',
            volume = 0.5,
        },
        match_progress_to_activity = false,
        match_volume_to_activity = false,
        match_speed_to_activity = false,
        max_sounds_per_type = 6,
        apparent_volume = 1.25,
    },
    crafting_speed = 1,
    crafting_categories = {'h2o-quantum-computer'},
    audible_distance_modifier = 25,
    energy_source = {
        type = 'void'
    },
    energy_usage = '10MW',
    module_specification = {module_slots = 4, module_info_icon_shift = {0, 2.1}, module_info_icon_scale = 0.6},
    allowed_effects = {'consumption', 'speed', 'productivity', 'pollution'},
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
}}

data:extend {{
    type = 'item',
    name = 'h2o-quantum-computer',
    icon = path .. 'singularity-lab.png',
    icon_size = 64,
    icon_mipmaps = 4,
    place_result = 'h2o-quantum-computer',
    stack_size = 10,
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-quantum-computer',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'iron-plate', amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-quantum-computer', amount = 1},
    },
}}
