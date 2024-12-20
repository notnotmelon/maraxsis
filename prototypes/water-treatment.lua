local function add_to_tech(recipe)
    table.insert(data.raw.technology["maraxsis-hydro-plant"].effects, {
        type = "unlock-recipe",
        recipe = recipe,
    })
end

data:extend {{
    type = "fluid",
    name = "maraxsis-saline-water",
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
    name = "maraxsis-brackish-water",
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
    name = "maraxsis-oxygen",
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
    name = "maraxsis-hydrogen",
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
    name = "maraxsis-salt",
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = "fluid", name = "maraxsis-brackish-water", amount = 300},
    },
    results = {
        {type = "item",  name = "maraxsis-salt",     amount = 3},
        {type = "fluid", name = "maraxsis-oxygen",   amount = 100},
        {type = "fluid", name = "maraxsis-hydrogen", amount = 200},
    },
    category = "maraxsis-hydro-plant-or-chemistry",
    icon = "__maraxsis__/graphics/icons/saline-electrolysis.png",
    icon_size = 64,
    auto_recycle = false,
    allow_productivity = true,
    main_product = "maraxsis-salt",
    localised_name = {"recipe-name.maraxsis-salt"},
}}
add_to_tech("maraxsis-salt")

data:extend {{
    type = "recipe",
    name = "maraxsis-water",
    icon = "__maraxsis__/graphics/icons/maraxsis-water.png",
    icon_size = 64,
    enabled = false,
    energy_required = 2,
    ingredients = {
        {type = "fluid", name = "maraxsis-oxygen",   amount = 100},
        {type = "fluid", name = "maraxsis-hydrogen", amount = 200},
    },
    results = {
        {type = "fluid", name = "water", amount = 300},
    },
    allow_productivity = true,
    category = "chemistry-or-cryogenics",
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
    name = "maraxsis-brackish-water",
    enabled = false,
    energy_required = 2.5,
    ingredients = {
        {type = "item",  name = "maraxsis-salt-filter",  amount = 1},
        {type = "fluid", name = "maraxsis-saline-water", amount = 100},
    },
    results = {
        {type = "fluid", name = "maraxsis-brackish-water",        amount = 100},
        {type = "item",  name = "maraxsis-saturated-salt-filter", amount = 1,  ignored_by_stats = 1, ignored_by_productivity = 1},
    },
    category = "maraxsis-hydro-plant-or-chemistry",
    auto_recycle = false,
    main_product = "maraxsis-brackish-water",
    allow_productivity = true,
}}
add_to_tech("maraxsis-brackish-water")

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
    name = "maraxsis-salt",
    icon = "__maraxsis__/graphics/icons/salt-2.png",
    pictures = salt_variants,
    icon_size = 64,
    stack_size = 200,
}}

data:extend {{
    type = "item",
    name = "maraxsis-salt-filter",
    icon = "__maraxsis__/graphics/icons/salt-filter.png",
    icon_size = 64,
    stack_size = 50,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-salt-filter",
    enabled = false,
    energy_required = 1,
    ingredients = {
        {type = "item", name = "steel-plate",  amount = 2},
        {type = "item", name = "carbon-fiber", amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-salt-filter", amount = 1},
    },
    category = "maraxsis-hydro-plant-or-assembling",
    allow_productivity = true,
}}
add_to_tech("maraxsis-salt-filter")

data:extend {{
    type = "recipe",
    name = "maraxsis-salt-filter-cleaning",
    enabled = false,
    energy_required = 1.25,
    ingredients = {
        {type = "item",  name = "maraxsis-saturated-salt-filter", amount = 1},
        {type = "fluid", name = "water",                          amount = 20},
    },
    results = {
        {type = "item",  name = "maraxsis-salt-filter",    amount = 1, probability = 0.95, ignored_by_stats = 1},
        {type = "item",  name = "carbon-fiber",            amount = 1, probability = 0.025},
        {type = "fluid", name = "maraxsis-brackish-water", amount = 20},
    },
    category = "maraxsis-hydro-plant-or-chemistry",
    main_product = "maraxsis-salt-filter",
    allow_productivity = false,
    icon = "__maraxsis__/graphics/icons/salt-filter-cleaning.png",
    icon_size = 64,
    allow_decomposition = false,
    auto_recycle = false,
}}
add_to_tech("maraxsis-salt-filter-cleaning")

add_to_tech("maraxsis-hydrolox-rocket-fuel")

data:extend {{
    type = "recipe",
    name = "maraxsis-sublimation",
    ingredients = {
        {type = "item", name = "ice", amount = 1},
    },
    results = {
        {type = "fluid", name = "steam", amount = 90, temperature = 165},
    },
    allow_productivity = true,
    allow_decomposition = false,
    category = "maraxsis-hydro-plant-or-chemistry",
    energy_required = 5,
    icon = "__maraxsis__/graphics/icons/sublimation.png",
    icon_size = 64,
    enabled = false,
    subgroup = "fluid-recipes",
    order = "d[other-recipes]-c[sublimation]",
}}
add_to_tech("maraxsis-sublimation")
