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
    type = "recipe",
    name = "ske_h2o",
    icon = "__maraxsis__/graphics/icons/maraxsis-water.png",
    icon_size = 64,
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
    auto_recycle = false,
    categories = {"chemistry", "cryogenics"},
    main_product = "water",
    hidden = not not mods.skewer_planet_vesta,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-hydrolox-rocket-fuel",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "fluid", name = "oxygen",   amount = 200},
        {type = "fluid", name = "hydrogen", amount = 200},
    },
    results = {
        {type = "item", name = "rocket-fuel", amount = 1},
    },
    icon = "__maraxsis__/graphics/icons/hydrolox-rocket-fuel.png",
    icon_size = 64,
    allow_productivity = true,
    categories = {"maraxsis-hydro-plant"},
    main_product = "rocket-fuel",
    auto_recycle = false,
}}