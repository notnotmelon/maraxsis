data:extend{{
    type = 'technology',
    name = 'h2o-water-treatment',
    icon = '__dihydrogen-monoxide__/graphics/technology/water-treatment.png',
    icon_size = 256,
    icon_mipmaps = nil,
    effects = {
        {
            type = 'unlock-recipe',
            recipe = 'saline-water',
        },
        {
            type = 'unlock-recipe',
            recipe = 'brackish-water',
        },
    },
    prerequisites = {'h2o-maraxsis'},
    unit = {
        count = 500,
        ingredients = {
            {'automation-science-pack', 1},
            {'logistic-science-pack',   1},
            {'chemical-science-pack',   1},
            {'military-science-pack',   1},
            {'production-science-pack', 1},
        },
        time = 60,
    },
    order = 'a',
}}

data:extend{{
    type = 'item',
    name = 'salt',
    icon = '__dihydrogen-monoxide__/graphics/icons/salt.png',
    icon_size = 64,
    icon_mipmaps = nil,
    subgroup = 'h2o-maraxsis',
    order = 'vga',
    stack_size = 200,
}}

data:extend{{
    type = 'fluid',
    name = 'saline-water',
    icon = '__dihydrogen-monoxide__/graphics/icons/saline-water.png',
    icon_size = 64,
    icon_mipmaps = 4,
    default_temperature = data.raw.fluid['water'].default_temperature,
    heat_capacity = data.raw.fluid['water'].heat_capacity,
    base_color = {r = 5, g = 9, b = 83},
    flow_color = {r = 105, g = 109, b = 183},
    max_temperature = data.raw.fluid['water'].max_temperature,
    pressure_to_speed_ratio = data.raw.fluid['water'].pressure_to_speed_ratio,
    flow_to_energy_ratio = data.raw.fluid['water'].flow_to_energy_ratio,
    order = 'a',
    subgroup = data.raw.fluid['water'].subgroup,
}}

data:extend{{
    type = 'recipe',
    name = 'saline-water',
    enabled = false,
    energy_required = 1,
    ingredients = {
        {type = 'fluid', name = 'water', amount = 100},
        {type = 'item', name = 'salt', amount = 1},
    },
    results = {
        {type = 'fluid', name = 'saline-water', amount = 100},
    },
    category = 'chemistry',
}}

data:extend{{
    type = 'fluid',
    name = 'brackish-water',
    icon = '__dihydrogen-monoxide__/graphics/icons/brackish-water.png',
    icon_size = 64,
    icon_mipmaps = 4,
    default_temperature = data.raw.fluid['water'].default_temperature,
    heat_capacity = data.raw.fluid['water'].heat_capacity,
    flow_color = {r = 105, g = 109, b = 183},
    base_color = {r = 5, g = 9, b = 83},
    max_temperature = data.raw.fluid['water'].max_temperature,
    pressure_to_speed_ratio = data.raw.fluid['water'].pressure_to_speed_ratio,
    flow_to_energy_ratio = data.raw.fluid['water'].flow_to_energy_ratio,
    order = 'a',
    subgroup = data.raw.fluid['water'].subgroup,
}}

data:extend{{
    type = 'recipe',
    name = 'brackish-water',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'fluid', name = 'saline-water', amount = 100},
    },
    results = {
        {type = 'fluid', name = 'brackish-water', amount = 100},
    },
    category = 'chemistry',
}}