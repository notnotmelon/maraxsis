data:extend{{
    type = "item",
    name = "maraxsis-fish-food",
    icon = "__maraxsis__/graphics/icons/fish-food.png",
    icon_size = 64,
    stack_size = 100
}}

data:extend{{
    type = "recipe",
    name = "maraxsis-fish-food",
    enabled = false,
    energy_required = 3,
    ingredients = {
        {type = "item", name = "maraxsis-tropical-fish", amount = 1},
        {type = "item", name = "sand", amount = 1},
        {type = "item", name = "maraxsis-coral", amount = 1},
        {type = "item", name = "plastic-bar", amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-fish-food", amount = 1}
    },
    allow_productivity = true,
    main_product = "maraxsis-fish-food",
    category = "maraxsis-hydro-plant-or-biochamber"
}}