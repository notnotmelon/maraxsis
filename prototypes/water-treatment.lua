local function add_to_tech(recipe)
    table.insert(data.raw.technology['h2o-water-treatment'].effects, {
        type = 'unlock-recipe',
        recipe = recipe,
    })
end

data:extend {{
    type = 'technology',
    name = 'h2o-water-treatment',
    icon = '__maraxsis__/graphics/technology/water-treatment.png',
    icon_size = 256,
    icon_mipmaps = nil,
    effects = {},
    prerequisites = {'h2o-maraxsis'},
    unit = {
        count = 3000,
        ingredients = {
            {'automation-science-pack', 1},
            {'logistic-science-pack',   1},
            {'chemical-science-pack',   1},
            {'space-science-pack',      1},
            {'production-science-pack', 1},
            {'utility-science-pack',    1},
            {'metallurgic-science-pack', 1},
            {'electromagnetic-science-pack', 1},
            {'agricultural-science-pack', 1},
        },
        time = 60,
    },
    order = 'ec[water-treatment]',
}}

data:extend {{
    type = 'fluid',
    name = 'saline-water',
    icon = '__maraxsis__/graphics/icons/saline-water.png',
    icon_size = 64,
    icon_mipmaps = 4,
    base_flow_rate = data.raw.fluid.water.base_flow_rate,
    default_temperature = data.raw.fluid['water'].default_temperature,
    heat_capacity = data.raw.fluid['water'].heat_capacity,
    base_color = {5, 9, 83},
    flow_color = {105, 109, 183},
    max_temperature = data.raw.fluid['water'].max_temperature,
    pressure_to_speed_ratio = data.raw.fluid['water'].pressure_to_speed_ratio,
    flow_to_energy_ratio = data.raw.fluid['water'].flow_to_energy_ratio,
}}

data:extend {{
    type = 'fluid',
    name = 'brackish-water',
    icon = '__maraxsis__/graphics/icons/brackish-water.png',
    icon_size = 64,
    icon_mipmaps = 4,
    base_flow_rate = data.raw.fluid.water.base_flow_rate,
    default_temperature = data.raw.fluid['water'].default_temperature,
    heat_capacity = data.raw.fluid['water'].heat_capacity,
    flow_color = {105, 109, 183},
    base_color = {5, 9, 83},
    max_temperature = data.raw.fluid['water'].max_temperature,
    pressure_to_speed_ratio = data.raw.fluid['water'].pressure_to_speed_ratio,
    flow_to_energy_ratio = data.raw.fluid['water'].flow_to_energy_ratio,
}}

data:extend {{
    type = 'fluid',
    name = 'oxygen',
    icon = '__maraxsis__/graphics/icons/oxygen.png',
    icon_size = 64,
    base_flow_rate = data.raw.fluid.steam.base_flow_rate,
    icon_mipmaps = 4,
    default_temperature = data.raw.fluid['water'].default_temperature,
    heat_capacity = data.raw.fluid['water'].heat_capacity,
    base_color = {0.75, 0.40, 0.40},
    flow_color = {0.80, 0.60, 0.60},
    max_temperature = data.raw.fluid['water'].max_temperature,
    pressure_to_speed_ratio = data.raw.fluid['water'].pressure_to_speed_ratio,
    flow_to_energy_ratio = data.raw.fluid['water'].flow_to_energy_ratio,
}}

data:extend {{
    type = 'fluid',
    name = 'chlorine',
    icon = '__maraxsis__/graphics/icons/chlorine.png',
    icon_size = 64,
    icon_mipmaps = 4,
    base_flow_rate = data.raw.fluid.steam.base_flow_rate,
    default_temperature = data.raw.fluid['water'].default_temperature,
    heat_capacity = data.raw.fluid['water'].heat_capacity,
    base_color = {0.30, 0.60, 0.1},
    flow_color = {0.50, 0.80, 0.3},
    max_temperature = data.raw.fluid['water'].max_temperature,
    pressure_to_speed_ratio = data.raw.fluid['water'].pressure_to_speed_ratio,
    flow_to_energy_ratio = data.raw.fluid['water'].flow_to_energy_ratio,
}}

data:extend {{
    type = 'fluid',
    name = 'hydrogen',
    icon = '__maraxsis__/graphics/icons/hydrogen.png',
    icon_size = 64,
    icon_mipmaps = 4,
    base_flow_rate = data.raw.fluid.steam.base_flow_rate,
    default_temperature = data.raw.fluid['water'].default_temperature,
    heat_capacity = data.raw.fluid['water'].heat_capacity,
    base_color = {0.50, 0.50, 0.50},
    flow_color = {1, 1, 1},
    max_temperature = data.raw.fluid['water'].max_temperature,
    pressure_to_speed_ratio = data.raw.fluid['water'].pressure_to_speed_ratio,
    flow_to_energy_ratio = data.raw.fluid['water'].flow_to_energy_ratio,
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-saline-electrolysis',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'fluid', name = 'brackish-water', amount = 400},
    },
    results = {
        {type = 'fluid', name = 'chlorine', amount = 100},
        {type = 'fluid', name = 'oxygen',   amount = 100},
        {type = 'fluid', name = 'hydrogen', amount = 200},
    },
    category = 'h2o-hydro-plant',
    icon = '__maraxsis__/graphics/icons/saline-electrolysis.png',
    icon_size = 128,
    icon_mipmaps = nil,
}}
add_to_tech('h2o-saline-electrolysis')

data:extend {{
    type = 'recipe',
    name = 'h2o-water',
    enabled = false,
    energy_required = 2,
    ingredients = {
        {type = 'fluid', name = 'oxygen',   amount = 100},
        {type = 'fluid', name = 'hydrogen', amount = 200},
    },
    results = {
        {type = 'fluid', name = 'water', amount = 300},
    },
    category = 'chemistry',
    main_product = 'water',
}}
add_to_tech('h2o-water')

data:extend {{
    type = 'item',
    name = 'h2o-saturated-salt-filter',
    icon = '__maraxsis__/graphics/icons/saturated-salt-filter.png',
    icon_size = 64,
    icon_mipmaps = nil,
    stack_size = 10,
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-brackish-water-filtration',
    enabled = false,
    energy_required = 2.5,
    ingredients = {
        {type = 'item',  name = 'h2o-salt-filter', amount = 1},
        {type = 'fluid', name = 'saline-water',    amount = 100},
    },
    results = {
        {type = 'item',  name = 'h2o-saturated-salt-filter', amount = 1,  catalyst_amount = 1},
        {type = 'fluid', name = 'brackish-water',            amount = 100},
    },
    category = 'chemistry',
    main_product = 'brackish-water',
}}
add_to_tech('h2o-brackish-water-filtration')

data:extend {{
    type = 'item',
    name = 'h2o-salt-filter',
    icon = '__maraxsis__/graphics/icons/salt-filter.png',
    icon_size = 64,
    icon_mipmaps = nil,
    stack_size = 10,
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-salt-filter',
    enabled = false,
    energy_required = 1,
    ingredients = {
        {type = 'item', name = 'steel-plate',     amount = 1},
        {type = 'item', name = 'iron-gear-wheel', amount = 2},
    },
    results = {
        {type = 'item', name = 'h2o-salt-filter', amount = 1},
    },
    category = 'crafting',
}}
add_to_tech('h2o-salt-filter')

data:extend {{
    type = 'recipe',
    name = 'h2o-salt-filter-recycling',
    enabled = false,
    energy_required = 1.25,
    ingredients = {
        {type = 'item',  name = 'h2o-saturated-salt-filter', amount = 1},
        {type = 'fluid', name = 'water',                     amount = 20},
    },
    results = {
        {type = 'item',  name = 'h2o-salt-filter', amount = 1, catalyst_amount = 1, probability = 0.99},
        {type = 'item',  name = 'steel-plate', amount = 1, probability = 0.01},
        {type = 'fluid', name = 'saline-water',    amount = 20},
    },
    category = 'crafting-with-fluid',
    main_product = 'h2o-salt-filter',
}}
add_to_tech('h2o-salt-filter-recycling')
