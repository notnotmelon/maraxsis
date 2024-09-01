local dome = {
    filename = '__maraxsis__/graphics/entity/pressure-dome/pressure-dome.png',
    width = 1344,
    height = 1344,
    scale = 1.05,
    shift = {0, 0.3}
}

local light = {
    filename = '__maraxsis__/graphics/entity/pressure-dome/pressure-dome.png',
    width = 1344,
    height = 1344,
    scale = 1.05,
    shift = {0, 0.3},
    draw_as_light = true,
}

local light_2 = {
    filename = '__core__/graphics/light-medium.png',
    width = 300,
    height = 300,
    scale = 7,
    shift = {0, 0.3},
    draw_as_light = true,
}

local shadow = {
    filename = '__maraxsis__/graphics/entity/pressure-dome/shadow.png',
    width = 1344,
    height = 1344,
    scale = 1.05,
    shift = {0, 0.3}
}

data:extend{{
    type = 'item',
    name = 'h2o-pressure-dome',
    icon = '__maraxsis__/graphics/icons/pressure-dome.png',
    icon_size = 64,
    subgroup = 'production-machine',
    order = 'a[water-treatment]-a[pressure-dome]',
    place_result = 'h2o-pressure-dome',
    stack_size = 10,
}}

data:extend{{
    type = 'recipe',
    name = 'h2o-pressure-dome',
    enabled = false,
    ingredients = {
        {type = 'item', name = 'pump', amount = 10},
        {type = 'item', name = 'pipe', amount = 50},
        {type = 'item', name = 'steel-plate', amount = 500},
        {type = 'item', name = 'h2o-glass-panes', amount = 5000},
    },
    results = {
        {type = 'item', name = 'h2o-pressure-dome', amount = 1},
    },
    energy_required = 10,
    category = 'crafting',
}}

local size = 16

data:extend{{
    type = 'simple-entity-with-owner',
    name = 'h2o-pressure-dome',
    icon = '__maraxsis__/graphics/icons/pressure-dome.png',
    icon_size = 64,
    flags = {'placeable-neutral', 'player-creation', 'not-on-map'},
    max_health = 1000,
    collision_box = {{-size, -size}, {size, size}},
    minable = {mining_time = 1, result = 'h2o-pressure-dome'},
    selection_box = {{-size, -size}, {size, size}},
    drawing_box = {{-size, -size}, {size, size}},
    collision_mask = {h2o.maraxsis_collision_mask},
    render_layer = 'higher-object-under',
    selectable_in_game = false,
    selection_priority = 40,
    picture = {
        layers = {shadow, dome, light, light_2},
    },
}}

data:extend{{
    type = 'fluid',
    name = 'h2o-atmosphere',
    default_temperature = 25,
    max_temperature = 100,
    heat_capacity = '1KJ',
    base_color = {r = 1, g = 1, b = 1},
    flow_color = {r = 0.5, g = 0.5, b = 1},
    icon = '__maraxsis__/graphics/icons/atmosphere.png',
    icon_size = 64,
    gas_temperature = 25,
}}

data:extend{h2o.merge(data.raw.tile['refined-concrete'], {
    name = 'h2o-pressure-dome-tile',
    minable = 'nil'
})}

local blank_animation = {
    filename = '__core__/graphics/empty.png',
    line_length = 1,
    width = 1,
    height = 1,
    frame_count = 1,
    direction_count = 1,
}

data:extend{{
    type = 'car',
    name = 'h2o-pressure-dome-collision',
    localised_name = {'entity-name.h2o-pressure-dome'},
    localised_description = {'entity-description.h2o-pressure-dome'},
    icon = '__maraxsis__/graphics/icons/pressure-dome.png',
    icon_size = 64,
    flags = {'placeable-player', 'player-creation', 'placeable-off-grid', 'not-on-map'},
    max_health = 1000,
    collision_box = {{-7, -0.4}, {7, 0.4}},
    selection_box = {{-7, -0.5}, {7, 0.5}},
    collision_mask = {'object-layer'},
    weight = 1,
    braking_force = 1,
    friction_force = 1,
    energy_per_hit_point = 1,
    effectivity = 1,
    rotation_speed = 0,
    energy_source = {
        type = 'void'
    },
    squeak_behaviour = false,
    inventory_size = 0,
    consumption = '0W',
    minable = {mining_time = 1, result = 'h2o-pressure-dome'},
    animation = blank_animation,
    movement_speed = 0,
    distance_per_frame = 1,
    pollution_to_join_attack = 0,
    distraction_cooldown = 0,
    vision_distance = 0,
    has_belt_immunity = true,
    placeable_by = {{item = 'h2o-pressure-dome', count = 1}},
}}