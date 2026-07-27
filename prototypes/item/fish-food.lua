data:extend {{
    type = "item",
    name = "maraxsis-fish-food",
    icon = "__maraxsis__/graphics/icons/fish-food.png",
    icon_size = 64,
    stack_size = 100,
    plant_result = "maraxsis-fishing-plant",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-fish-food",
    enabled = false,
    energy_required = 3,
    ingredients = {
        {type = "item", name = "maraxsis-tropical-fish", amount = 1},
        {type = "item", name = maraxsis_constants.SAND_ITEM_NAME,                   amount = 1},
        {type = "item", name = "jelly",                  amount = 1},
        {type = "item", name = "maraxsis-coral",         amount = 3},
        {type = "item", name = "plastic-bar",            amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-fish-food", amount = 3}
    },
    allow_productivity = true,
    auto_recycle = true,
    main_product = "maraxsis-fish-food",
    categories = {"maraxsis-hydro-plant", "organic"},
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-shrinkflation",
    enabled = false,
    energy_required = 3,
    ingredients = {
        {type = "item", name = maraxsis_constants.SAND_ITEM_NAME, amount = 1, quality_min = "normal", quality_max = "normal"},
        {type = "item", name = "maraxsis-fish-food", amount = 1, quality_min = "uncommon"},
    },
    results = {
        {type = "item", name = "maraxsis-fish-food", amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1, quality_change = -1},
    },
    allow_productivity = false,
    allow_quality = false,
    auto_recycle = false,
    main_product = "maraxsis-fish-food",
    icon = "__maraxsis__/graphics/icons/shrinkflation.png"
}}