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
    type = "recipe",
    name = "brackish-water",
    enabled = false,
    energy_required = 2.5,
    ingredients = {
        {type = "item",  name = "maraxsis-salt-filter",  amount = 1},
        {type = "fluid", name = "saline-water", amount = 100},
    },
    results = {
        {type = "fluid", name = "brackish-water",        amount = 100},
        {type = "item",  name = "maraxsis-saturated-salt-filter", amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1},
    },
    categories = {"maraxsis-hydro-plant", "chemistry"},
    auto_recycle = false,
    main_product = "brackish-water",
    allow_productivity = true,
}}
