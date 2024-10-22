local dome = {
    filename = '__maraxsis__/graphics/entity/pressure-dome/pressure-dome.png',
    width = 1344,
    height = 1344,
    scale = 0.935,
    shift = {0, -1.25},
    flags = {'no-scale'},
}

local light_2 = {
    filename = '__core__/graphics/light-medium.png',
    width = 300,
    height = 300,
    scale = 7,
    shift = {0, 0.3},
    draw_as_light = true,
}

local base_shadow = {
    filename = '__maraxsis__/graphics/entity/pressure-dome/base-shadow.png',
    width = 1344,
    height = 1344,
    scale = 0.935,
    shift = {0, -1.25},
    flags = {'no-scale'},
    draw_as_shadow = true,
}

local cage_shadow = {
    filename = '__maraxsis__/graphics/entity/pressure-dome/cage-shadow.png',
    width = 1344,
    height = 1344,
    scale = 0.935,
    shift = {0, -1.25},
    flags = {'no-scale'},
}

data:extend {{
    type = 'item',
    name = 'h2o-pressure-dome',
    icon = '__maraxsis__/graphics/icons/pressure-dome.png',
    icon_size = 64,
    place_result = 'h2o-pressure-dome',
    stack_size = 10,
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-pressure-dome',
    enabled = false,
    ingredients = {
        {type = 'item', name = 'pump',             amount = 10},
        {type = 'item', name = 'pipe',             amount = 50},
        {type = 'item', name = 'steel-plate',      amount = 500},
        {type = 'item', name = 'h2o-glass-panes',  amount = 5000},
        {type = 'item', name = 'space-platform-foundation', amount = 880},
        {type = 'item', name = 'small-lamp',       amount = 30},
    },
    results = {
        {type = 'item', name = 'h2o-pressure-dome', amount = 1},
    },
    energy_required = 10,
    category = 'crafting',
}}

local function collision_box() return {{-16, -16}, {16, 16}} end

data:extend {{
    type = 'simple-entity-with-owner',
    name = 'h2o-pressure-dome',
    remove_decoratives = 'false',
    icon = '__maraxsis__/graphics/icons/pressure-dome.png',
    icon_size = 64,
    flags = {'placeable-player', 'player-creation', 'not-on-map'},
    max_health = 10000,
    collision_box = collision_box(),
    minable = {mining_time = 1, result = 'h2o-pressure-dome'},
    selection_box = {{-16.5, -16.5}, {16.5, 16.5}},
    drawing_box = collision_box(),
    collision_mask = {colliding_with_tiles_only = true, layers = {['empty_space'] = true}},
    render_layer = 'higher-object-above',
    picture = {
        layers = {cage_shadow, base_shadow, dome},
    },
    build_sound = {
        filename = '__core__/sound/build-ghost-tile.ogg',
        volume = 0
    },
    created_smoke = {
        type = 'create-trival-smoke',
        smoke_name = 'h2o-invisible-smoke',
    },
    created_effect = {
        type = 'direct',
        action_delivery = {
            type = 'instant',
            source_effects = {
                type = 'script',
                effect_id = 'on_built_maraxsis_pressure_dome'
            }
        }
    }
}}

data:extend{{
    type = 'sprite',
    name = 'h2o-pressure-dome-sprite',
    layers = {cage_shadow, base_shadow, dome},
}}

data:extend {h2o.merge(data.raw['lamp']['small-lamp'], {
    type = 'lamp',
    name = 'h2o-pressure-dome-lamp',
    localised_name = {'entity-name.h2o-pressure-dome'},
    localised_description = {'entity-description.h2o-pressure-dome'},
    remove_decoratives = 'false',
    icon = '__maraxsis__/graphics/icons/pressure-dome.png',
    icon_size = 64,
    flags = {'placeable-player', 'player-creation', 'not-on-map', 'not-blueprintable'},
    max_health = 10000,
    collision_box = collision_box(),
    selection_box = {{-0.01, -0.01}, {0.01, 0.01}},
    selection_priority = 0,
    drawing_box = collision_box(),
    collision_mask = {layers = {}},
    selectable_in_game = true,
    picture_on = h2o.empty_image(),
    picture_off = h2o.empty_image(),
    circuit_wire_max_distance = 16,
    energy_usage_per_tick = '2MW',
    glow_size = 30,
    light = {
        size = 45,
        color = {
            b = 0.75,
            g = 1,
            r = 1
        },
        intensity = 0.9,
    },
    light_when_colored = {
        color = {
            b = 0.75,
            g = 1,
            r = 1
        },
        intensity = 0,
        size = 30,
    },
})}

data:extend{h2o.merge(data.raw['constant-combinator']['constant-combinator'], {
    type = 'constant-combinator',
    name = 'h2o-pressure-dome-combinator',
    localised_name = {'entity-name.h2o-pressure-dome'},
    localised_description = {'entity-description.h2o-pressure-dome'},
    remove_decoratives = 'false',
    icon = '__maraxsis__/graphics/icons/pressure-dome.png',
    icon_size = 64,
    flags = {'placeable-player', 'player-creation', 'not-on-map', 'not-blueprintable'},
    max_health = 10000,
    selectable_in_game = false,
    item_slot_count = 500,
    activity_led_light_offsets = {
        {0, 0},
        {0, 0},
        {0, 0},
        {0, 0}
    },
    circuit_wire_connection_points = {
        {
            shadow = {red = {0, 0}, green = {0, 0}},
            wire = {red = {0, 0}, green = {0, 0}}
        },
        {
            shadow = {red = {0, 0}, green = {0, 0}},
            wire = {red = {0, 0}, green = {0, 0}}
        },
        {
            shadow = {red = {0, 0}, green = {0, 0}},
            wire = {red = {0, 0}, green = {0, 0}}
        },
        {
            shadow = {red = {0, 0}, green = {0, 0}},
            wire = {red = {0, 0}, green = {0, 0}}
        }
    },
    draw_copper_wires = false,
    draw_circuit_wires = false,
    sprites = 'nil',
    activity_led_sprites = 'nil',
    activity_led_light = 'nil',
    collision_mask = {layers = {}},
})}

local function shift_the_circuit_connection_point(entity, x, y)
    local connection = entity.circuit_connector.points

    local function adjust_shift(vector)
        if not vector then return end
        vector.x = (vector[1] or vector.x or 0) + x
        vector.y = (vector[2] or vector.y or 0) + y
    end

    for _, connection in pairs(connection) do
        for _, color in pairs(connection) do
            adjust_shift(color)
        end
    end

    for _, sprite in pairs(entity.circuit_connector.sprites) do
        adjust_shift(sprite.shift or {})
        for _, layer in pairs(sprite.layers or {}) do
            adjust_shift(layer.shift or {})
        end
        if sprite.picture then
            adjust_shift(sprite.picture.shift or {})
        end
    end
end

shift_the_circuit_connection_point(data.raw['lamp']['h2o-pressure-dome-lamp'], 4, 17)

data:extend {{
    type = 'trivial-smoke',
    name = 'h2o-invisible-smoke',
    duration = 1,
    fade_away_duration = 1,
    spread_duration = 1,
    animation = {
        filename = '__core__/graphics/empty.png',
        priority = 'high',
        width = 1,
        height = 1,
        flags = {'smoke'},
        frame_count = 1,
    },
    cyclic = true
}}

data:extend {{
    type = 'fluid',
    name = 'h2o-atmosphere',
    default_temperature = 25,
    max_temperature = 100,
    heat_capacity = '1kJ',
    base_flow_rate = data.raw.fluid.steam.base_flow_rate,
    base_color = {1, 1, 1},
    flow_color = {0.5, 0.5, 1},
    icon = '__maraxsis__/graphics/icons/atmosphere.png',
    icon_size = 64,
    gas_temperature = 25,
}}

local tile = h2o.merge(data.raw.tile['space-platform-foundation'], {
    name = 'h2o-pressure-dome-tile',
    is_foundation = true,
    minable = {
        mining_time = 2^63-1, -- weird hack needed to make this a "top" tile. top tiles require minable properties however these dome tiles actually should not be minable
        results = {},
    },
    collision_mask = {layers = {[dome_collision_mask] = true}},
    map_color = {r = 0.5, g = 0.5, b = 0.75},
    can_be_part_of_blueprint = false,
    layer_group = 'ground-artificial'
})
data:extend {tile}

local blank_animation = {
    filename = '__core__/graphics/empty.png',
    line_length = 1,
    width = 1,
    height = 1,
    frame_count = 1,
    direction_count = 1,
}

data:extend {{
    type = 'simple-entity-with-owner',
    name = 'h2o-pressure-dome-collision',
    localised_name = {'entity-name.h2o-pressure-dome'},
    icon = '__maraxsis__/graphics/icons/pressure-dome.png',
    icon_size = 64,
    flags = {'placeable-player', 'player-creation', 'placeable-off-grid', 'not-on-map', 'building-direction-8-way', 'not-blueprintable'},
    max_health = 10000,
    collision_box = {{-7, -0.3}, {7, 0.3}},
    selection_box = {{-7, -0.5}, {7, 0.5}},
    drawing_box = {{0, 0}, {0, 0}},
    collision_mask = {layers = {
        ['water_tile'] = true,
        ['object'] = true,
        ['item'] = true,
        [maraxsis_collision_mask] = true, 
        [dome_collision_mask] = true
    }},
    squeak_behaviour = false,
    minable = {mining_time = 1, result = 'h2o-pressure-dome'},
    placeable_by = {{item = 'h2o-pressure-dome', count = 1}},
    resistances = {
        {
            type = 'acid',
            percent = 90
        },
        {
            type = 'fire',
            percent = 100
        },
    }
}}
