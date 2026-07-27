data:extend {{
    type = "item",
    name = "maraxsis-salt-filter",
    icon = "__maraxsis__/graphics/icons/salt-filter.png",
    icon_size = 64,
    stack_size = 50,
}}

data:extend {{
    type = "item",
    name = "maraxsis-saturated-salt-filter",
    icon = "__maraxsis__/graphics/icons/saturated-salt-filter.png",
    icon_size = 64,
    stack_size = 10,
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
    categories = {"maraxsis-hydro-plant", "crafting"},
    allow_productivity = true,
    auto_recycle = false,
}}

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
        {type = "item",  name = "maraxsis-salt-filter",    amount = 1, independent_probability = 0.95, ignored_by_productivity = 1, ignored_by_stats = 1, quality_change = 1},
        {type = "item",  name = "carbon-fiber",            amount = 1, independent_probability = 0.025},
        {type = "fluid", name = "brackish-water", amount = 20},
    },
    categories = {"maraxsis-hydro-plant", "chemistry"},
    main_product = "maraxsis-salt-filter",
    allow_productivity = false,
    icon = "__maraxsis__/graphics/icons/salt-filter-cleaning.png",
    icon_size = 64,
    allow_decomposition = false,
    auto_recycle = false,
}}
