data:extend {{
    type = "recipe",
    name = "maraxsis-geothermal-sulfur",
    ingredients = {
        {type = "fluid", name = "maraxsis-supercritical-steam", amount = 100},
        {type = "fluid", name = "lava",  amount = 100},
    },
    results = {
        {type = "item", name = "sulfur", amount = 2},
    },
    energy_required = 3,
    enabled = false,
    categories = {"maraxsis-geothermal-generator"},
    icon = "__maraxsis__/graphics/icons/geothermal-sulfur.png",
    icon_size = 64,
    allow_productivity = true,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-bio-oil",
    categories = {"organic"},
    ingredients = {
        {type = "fluid", name = "lubricant", amount = 30},
        {type = "fluid", name = "steam", amount = 100},
        {type = "item", name = "maraxsis-fish-oil", amount = 1},
    },
    results = {
        {type = "fluid", name = "light-oil", amount = 200},
    },
    main_product = "light-oil",
    allow_productivity = true,
    auto_recycle = false,
    energy_required = 5,
    enabled = false,
    icon = "__maraxsis__/graphics/icons/bio-oil.png"
}}
