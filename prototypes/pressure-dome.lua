local dome = {
    type = 'sprite',
    name = 'h2o-pressure-dome',
    filename = '__maraxsis__/graphics/entity/pressure-dome/pressure-dome.png',
    width = 1344,
    height = 1344,
    scale = 1.06,
    shift = {0, 0.3}
}

local shadow = {
    type = 'sprite',
    name = 'h2o-pressure-dome-shadow',
    filename = '__maraxsis__/graphics/entity/pressure-dome/shadow.png',
    width = 1344,
    height = 1344,
    scale = 1.06,
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
    minable = {mining_time = 1, result = 'h2o-pressure-dome'},
    max_health = 1000,
    collision_box = {{-size, -size}, {size, size}},
    selection_box = {{-size, -size}, {size, size}},
    drawing_box = {{-size, -size}, {size, size}},
    collision_mask = {h2o.maraxsis_collision_mask},
    render_layer = 'higher-object-under',
    selection_priority = 40,
    picture = {
        layers = table.deepcopy {shadow, dome},
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
}}