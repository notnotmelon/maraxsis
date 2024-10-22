local path = '__maraxsis__/graphics/entity/hydro-plant/'

if not mods['Krastorio2'] then
    function furnacekpipepictures_a()
        return {
            north = {
                filename = path .. '/hr-advanced-furnace-k-pipe-N.png',
                priority = 'extra-high',
                width = 71,
                height = 38,
                shift = util.by_pixel(2.25, 13.5),
                scale = 0.5,
            },
            east = {
                filename = path .. '/hr-advanced-furnace-k-pipe-E-top.png',
                priority = 'extra-high',
                width = 59, --42,
                height = 76,
                shift = util.by_pixel(-28.75, 1),
                scale = 0.5,
            },
            south = {
                filename = path .. '/hr-advanced-furnace-k-pipe-S-right.png',
                priority = 'extra-high',
                width = 88,
                height = 61,
                shift = util.by_pixel(0, -31.5),
                scale = 0.5,
            },
            west = {
                filename = path .. '/hr-advanced-furnace-k-pipe-W-bottom.png',
                priority = 'extra-high',
                width = 39,
                height = 73,
                shift = util.by_pixel(25.75, 1.25),
                scale = 0.5,
            },
        }
    end

    function furnacekpipepictures_b()
        return {
            north = {
                filename = path .. '/advanced-furnace-k-pipe-N.png',
                priority = 'extra-high',
                width = 35,
                height = 18,
                shift = util.by_pixel(2.5, 14),
                filename = path .. '/hr-advanced-furnace-k-pipe-N.png',
                priority = 'extra-high',
                width = 71,
                height = 38,
                shift = util.by_pixel(2.25, 13.5),
                scale = 0.5,
            },
            east = {
                filename = path .. '/hr-advanced-furnace-k-pipe-E-bottom.png',
                priority = 'extra-high',
                width = 76, --42,
                height = 76,
                shift = util.by_pixel(-33, 1),
                scale = 0.5,
            },
            south = {
                filename = path .. '/hr-advanced-furnace-k-pipe-S-left.png',
                priority = 'extra-high',
                width = 88,
                height = 61,
                shift = util.by_pixel(0, -31.25),
                scale = 0.5,
            },
            west = {
                filename = path .. '/hr-advanced-furnace-k-pipe-W-top.png',
                priority = 'extra-high',
                width = 39,
                height = 87, --73,
                shift = util.by_pixel(25.5, -2.25),
                scale = 0.5,
            },
        }
    end
end

local hit_effects = require('__base__/prototypes/entity/hit-effects')
local sounds = require('__base__/prototypes/entity/sounds')

local advanced_furnace_sound

if mods['Krastorio2'] then
    advanced_furnace_sound = data.raw['assembling-machine']['advanced-furnace'].working_sound
else
    advanced_furnace_sound = {
        filename = path .. 'advanced-furnace.ogg',
        volume = 0.50,
        aggregation = {
            max_count = 2,
            remove = false,
            count_already_playing = true,
        },
    }
end

local animation = {
    layers = {
        {
            filename = path .. '/hr-advanced-furnace.png',
            priority = 'high',
            width = 480,
            height = 480,
            shift = {0, -0.1},
            frame_count = 1,
            scale = 0.5,
        },
        {
            filename = path .. '/hr-advanced-furnace-sh.png',
            priority = 'high',
            width = 165,
            height = 480,
            shift = {3.1, -0.1},
            frame_count = 1,
            draw_as_shadow = true,
            scale = 0.5,
        },
    },
}

local working_visualizations = {
    {
        constant_speed = true,
        animation = {
            filename = path .. '/hr-advanced-furnace-anim-light.png',
            priority = 'high',
            width = 480,
            height = 480,
            shift = {0, -0.1},
            frame_count = 28,
            line_length = 4,
            animation_speed = 0.8,
            draw_as_light = true,
            scale = 0.5,
        },
    },
    {
        constant_speed = true,
        animation = {
            filename = path .. '/hr-advanced-furnace-anim-glow.png',
            priority = 'high',
            width = 480,
            height = 480,
            shift = {0, -0.1},
            frame_count = 28,
            line_length = 4,
            animation_speed = 0.8,
            draw_as_glow = true,
            fadeout = true,
            blend_mode = 'additive',
            scale = 0.5,
        },
    },
    {
        constant_speed = true,
        animation = {
            filename = path .. '/hr-advanced-furnace-anim.png',
            priority = 'high',
            width = 480,
            height = 480,
            shift = {0, -0.1},
            frame_count = 28,
            line_length = 4,
            animation_speed = 0.8,
            scale = 0.5,
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
    type = 'recipe-category',
    name = 'h2o-hydro-plant',
}}

data:extend {{
    type = 'assembling-machine',
    name = 'h2o-hydro-plant',
    icon = path .. 'icon.png',
    icon_size = 128,
    icon_mipmaps = 4,
    flags = {'placeable-neutral', 'placeable-player', 'player-creation'},
    minable = {mining_time = 1, results = {{type = 'item', name = 'h2o-hydro-plant', amount = 1}}},
    max_health = 2000,
    corpse = 'kr-big-random-pipes-remnant',
    dying_explosion = 'big-explosion',
    resistances = {
        {type = 'physical', percent = 50},
        {type = 'fire',     percent = 100},
        {type = 'impact',   percent = 80},
    },
    collision_box = {{-3.25, -3.25}, {3.25, 3.25}},
    selection_box = {{-3.5, -3.5}, {3.5, 3.5}},
    damaged_trigger_effect = hit_effects.entity(),
    fluid_boxes = {
        {
            production_type = 'input',
            pipe_picture = furnacekpipepictures_a(),
            pipe_covers = pipecoverspictures(),
            volume = 100,
            pipe_connections = {{direction = defines.direction.northnortheast, flow_direction = 'input', position = {-1, -3.25}}},
            secondary_draw_orders = {north = -1},
        },
        {
            production_type = 'input',
            pipe_picture = furnacekpipepictures_b(),
            pipe_covers = pipecoverspictures(),
            volume = 100,
            pipe_connections = {{direction = defines.direction.east, flow_direction = 'input', position = {1, -3.25}}},
            secondary_draw_orders = {north = -1},
        },
        {
            production_type = 'input',
            pipe_picture = furnacekpipepictures_b(),
            pipe_covers = pipecoverspictures(),
            volume = 100,
            --pipe_connections = {{direction = defines.direction.west, flow_direction = 'input-output', position = {3.25, -1}}, {direction = defines.direction.east, flow_direction = 'input-output', position = {-3.25, -1}}},
            pipe_connections = {{direction = defines.direction.west, flow_direction = 'input', position = {3.25, -1}}, {direction = defines.direction.east, flow_direction = 'input', position = {-3.25, -1}}},
            secondary_draw_orders = {north = -1},
        },
        {
            production_type = 'output',
            pipe_picture = furnacekpipepictures_b(),
            pipe_covers = pipecoverspictures(),
            volume = 100,
            --pipe_connections = {{direction = defines.direction.north, flow_direction = 'input-output', position = {-3.25, 1}}, {direction = defines.direction.south, flow_direction = 'input-output', position = {3.25, 1}}},
            pipe_connections = {{direction = defines.direction.north, flow_direction = 'output', position = {-3.25, 1}}, {direction = defines.direction.south, flow_direction = 'output', position = {3.25, 1}}},
            secondary_draw_orders = {north = -1},
        },
        {
            production_type = 'output',
            pipe_picture = furnacekpipepictures_a(),
            pipe_covers = pipecoverspictures(),
            volume = 100,
            pipe_connections = {{direction = defines.direction.south, flow_direction = 'output', position = {-1, 3.25}}},
            secondary_draw_orders = {north = -1},
        },
        {
            production_type = 'output',
            pipe_picture = furnacekpipepictures_b(),
            pipe_covers = pipecoverspictures(),
            volume = 100,
            pipe_connections = {{direction = defines.direction.east, flow_direction = 'output', position = {1, 3.25}}},
            secondary_draw_orders = {north = -1},
        },
        off_when_no_fluid_recipe = true,
    },
    animation = animation,
    working_visualizations = working_visualizations,
    crafting_categories = {'crafting', 'crafting-with-fluid', 'advanced-crafting', 'h2o-hydro-plant'},
    scale_entity_info_icon = true,
    vehicle_impact_sound = sounds.generic_impact,
    working_sound = advanced_furnace_sound,
    idle_sound = {filename = '__base__/sound/idle1.ogg'},
    crafting_speed = 2,
    energy_source = {
        type = 'electric',
        usage_priority = 'secondary-input',
        emissions_per_minute = {
            pollution = 6,
        }
    },
    water_reflection = {
        pictures = {
            filename = path .. '/advanced-furnace-reflection.png',
            priority = 'extra-high',
            width = 80,
            height = 60,
            shift = util.by_pixel(0, 40),
            variation_count = 1,
            scale = 5,
        },
        rotate = false,
        orientation_to_variation = false,
    },
    energy_usage = '2MW',
    module_specification = {module_slots = 4, module_info_icon_shift = {0, 1.7}, module_info_icon_scale = 1},
    allowed_effects = {'consumption', 'speed', 'productivity', 'pollution'}, -- todo: add quality
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    collision_mask = {layers = {['item'] = true, ['object'] = true, ['player'] = true}},
}}

local extra_module_slots = table.deepcopy(data.raw['assembling-machine']['h2o-hydro-plant'])
extra_module_slots.name = 'h2o-hydro-plant-extra-module-slots'
extra_module_slots.module_specification.module_slots = 6
extra_module_slots.module_specification.module_info_icon_scale = 0.8
extra_module_slots.placeable_by = {{item = 'h2o-hydro-plant', count = 1}}
extra_module_slots.localised_name = {'entity-name.h2o-hydro-plant'}
extra_module_slots.localised_description = {'entity-description.h2o-hydro-plant'}
extra_module_slots.flags = {'placeable-player', 'player-creation', 'not-in-made-in'}
data:extend {extra_module_slots}

if not mods['Krastorio2'] then
    data:extend {{
        type = 'corpse',
        name = 'kr-big-random-pipes-remnant',
        icon = path .. 'remnants-icon.png',
        icon_size = 64,
        flags = {'placeable-neutral', 'building-direction-8-way', 'not-on-map'},
        selection_box = {{-4, -4}, {4, 4}},
        tile_width = 3,
        tile_height = 3,
        selectable_in_game = false,
        subgroup = 'remnants',
        order = 'z[remnants]-a[generic]-b[big]',
        time_before_removed = 60 * 60 * 20, -- 20 minutes
        final_render_layer = 'remnants',
        remove_on_tile_placement = false,
        animation = make_rotated_animation_variations_from_sheet(1, {
            filename = path .. 'hr-big-random-pipes-remnant.png',
            line_length = 1,
            width = 500,
            height = 500,
            frame_count = 1,
            direction_count = 1,
            scale = 0.5,
        }),
    }}
end

data:extend {{
    type = 'item',
    name = 'h2o-hydro-plant',
    icon = path .. 'icon.png',
    icon_size = 128,
    icon_mipmaps = 4,
    place_result = 'h2o-hydro-plant',
    stack_size = 50,
    scale = 0.5,
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-hydro-plant',
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = 'item', name = 'steel-plate',      amount = 20},
        {type = 'item', name = 'stone-brick',      amount = 20},
        {type = 'item', name = 'advanced-circuit', amount = 10},
        {type = 'item', name = 'pipe',             amount = 10},
    },
    results = {
        {type = 'item', name = 'h2o-hydro-plant', amount = 1},
    },
    category = 'crafting',
}}
