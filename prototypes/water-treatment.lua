local function add_to_tech(recipe)
    table.insert(data.raw.technology["maraxsis-hydro-plant"].effects, {
        type = "unlock-recipe",
        recipe = recipe,
    })
end

data:extend {{
    type = "fluid",
    name = "saline-water",
    icon = "__maraxsis__/graphics/icons/saline-water.png",
    icon_size = 64,
    base_flow_rate = data.raw.fluid.water.base_flow_rate,
    default_temperature = data.raw.fluid["water"].default_temperature,
    heat_capacity = data.raw.fluid["water"].heat_capacity,
    base_color = {5, 9, 83},
    flow_color = {105, 109, 183},
    max_temperature = data.raw.fluid["water"].max_temperature,
    pressure_to_speed_ratio = data.raw.fluid["water"].pressure_to_speed_ratio,
    flow_to_energy_ratio = data.raw.fluid["water"].flow_to_energy_ratio,
}}

data:extend {{
    type = "fluid",
    name = "brackish-water",
    icon = "__maraxsis__/graphics/icons/brackish-water.png",
    icon_size = 64,
    base_flow_rate = data.raw.fluid.water.base_flow_rate,
    default_temperature = data.raw.fluid["water"].default_temperature,
    heat_capacity = data.raw.fluid["water"].heat_capacity,
    flow_color = {105, 109, 183},
    base_color = {5, 9, 83},
    max_temperature = data.raw.fluid["water"].max_temperature,
    pressure_to_speed_ratio = data.raw.fluid["water"].pressure_to_speed_ratio,
    flow_to_energy_ratio = data.raw.fluid["water"].flow_to_energy_ratio,
}}

data:extend {{
    type = "fluid",
    name = "oxygen",
    icon = "__maraxsis__/graphics/icons/oxygen.png",
    icon_size = 64,
    base_flow_rate = data.raw.fluid.steam.base_flow_rate,
    default_temperature = data.raw.fluid["water"].default_temperature,
    heat_capacity = data.raw.fluid["water"].heat_capacity,
    base_color = {0.75, 0.40, 0.40},
    flow_color = {0.80, 0.60, 0.60},
    max_temperature = data.raw.fluid["water"].max_temperature,
    pressure_to_speed_ratio = data.raw.fluid["water"].pressure_to_speed_ratio,
    flow_to_energy_ratio = data.raw.fluid["water"].flow_to_energy_ratio,
}}

data:extend {{
    type = "fluid",
    name = "hydrogen",
    icon = "__maraxsis__/graphics/icons/hydrogen.png",
    icon_size = 64,
    base_flow_rate = data.raw.fluid.steam.base_flow_rate,
    default_temperature = data.raw.fluid["water"].default_temperature,
    heat_capacity = data.raw.fluid["water"].heat_capacity,
    base_color = {0.50, 0.50, 0.50},
    flow_color = {1, 1, 1},
    max_temperature = data.raw.fluid["water"].max_temperature,
    pressure_to_speed_ratio = data.raw.fluid["water"].pressure_to_speed_ratio,
    flow_to_energy_ratio = data.raw.fluid["water"].flow_to_energy_ratio,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-saline-electrolysis",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "fluid", name = "brackish-water", amount = 300},
    },
    results = {
        {type = "item",  name = "salt",     amount = 1},
        {type = "fluid", name = "oxygen",   amount = 100},
        {type = "fluid", name = "hydrogen", amount = 200},
    },
    category = "maraxsis-hydro-plant",
    icon = "__maraxsis__/graphics/icons/saline-electrolysis.png",
    icon_size = 128,
    allow_productivity = true,
}}
add_to_tech("maraxsis-saline-electrolysis")

data:extend {{
    type = "recipe",
    name = "maraxsis-water",
    enabled = false,
    energy_required = 2,
    ingredients = {
        {type = "fluid", name = "oxygen",   amount = 100},
        {type = "fluid", name = "hydrogen", amount = 200},
    },
    results = {
        {type = "fluid", name = "water", amount = 300},
    },
    allow_productivity = true,
    category = "maraxsis-hydro-plant",
    main_product = "water",
}}
add_to_tech("maraxsis-water")

data:extend {{
    type = "item",
    name = "maraxsis-saturated-salt-filter",
    icon = "__maraxsis__/graphics/icons/saturated-salt-filter.png",
    icon_size = 64,
    stack_size = 10,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-saturated-salt-filter",
    enabled = false,
    energy_required = 2.5,
    ingredients = {
        {type = "item",  name = "maraxsis-salt-filter", amount = 1},
        {type = "fluid", name = "saline-water",    amount = 100},
    },
    results = {
        {type = "item",  name = "maraxsis-saturated-salt-filter", amount = 1,  ignored_by_stats = 1, ignored_by_stats = 1},
        {type = "fluid", name = "brackish-water",            amount = 100},
    },
    category = "chemistry",
    main_product = "brackish-water",
    allow_productivity = true,
}}
add_to_tech("maraxsis-saturated-salt-filter")

local salt_variants = {}
for i = 1, 3 do
    salt_variants[i] = {
        filename = "__maraxsis__/graphics/icons/salt-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 2,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = "salt",
    icon = "__maraxsis__/graphics/icons/salt-2.png",
    pictures = salt_variants,
    icon_size = 64,
    stack_size = 10,
}}

data:extend {{
    type = "item",
    name = "maraxsis-salt-filter",
    icon = "__maraxsis__/graphics/icons/salt-filter.png",
    icon_size = 64,
    stack_size = 10,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-salt-filter",
    enabled = false,
    energy_required = 1,
    ingredients = {
        {type = "item", name = "steel-plate",     amount = 1},
        {type = "item", name = "iron-gear-wheel", amount = 2},
        {type = "item", name = "carbon-fiber",    amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-salt-filter", amount = 1},
    },
    category = "crafting",
}}
add_to_tech("maraxsis-salt-filter")

data:extend {{
    type = "recipe",
    name = "maraxsis-salt-filter-recycling",
    enabled = false,
    energy_required = 1.25,
    ingredients = {
        {type = "item",  name = "maraxsis-saturated-salt-filter", amount = 1},
        {type = "fluid", name = "water",                     amount = 20},
    },
    results = {
        {type = "item",  name = "maraxsis-salt-filter", amount = 1, catalyst_amount = 1, probability = 0.99},
        {type = "item",  name = "steel-plate",     amount = 1, probability = 0.01},
        {type = "fluid", name = "saline-water",    amount = 20},
    },
    category = "crafting-with-fluid",
    main_product = "maraxsis-salt-filter",
}}
add_to_tech("maraxsis-salt-filter-recycling")
