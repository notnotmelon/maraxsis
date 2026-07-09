data:extend {{
    type = "technology",
    name = "maraxsis-omega_3",
    icons = util.technology_icon_constant_recipe_productivity("__maraxsis__/graphics/technology/omega-3.png"),
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-omega-3",
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-vitamin-infused-agricultural-science",
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-vitamin-infused-hydraulic-science",
        },
    },
    prerequisites = {"maraxsis-project-seadragon", "agricultural-science-pack", "maraxsis-liquid-atmosphere", "epic-quality"},
    unit = {
        count = 5000,
        ingredients = {
            {"agricultural-science-pack", 1},
            {"hydraulic-science-pack",    1},
        },
        time = 60
    },
}}

data:extend {{
    type = "technology",
    name = "maraxsis-promethium-quality-1",
    icons = util.technology_icon_constant_recipe_productivity("__maraxsis__/graphics/technology/promethium-quality.png"),
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-vitamin-infused-promethium-science-1",
        },
    },
    prerequisites = {"promethium-science-pack", "maraxsis-omega_3", "legendary-quality"},
    unit = {
        count = 5000000,
        time = 120,
        ingredients = {}, -- ingredients are filled in final-fixes
    },
}}

data:extend {{
    type = "technology",
    name = "maraxsis-promethium-quality-2",
    icons = util.technology_icon_constant_recipe_productivity("__maraxsis__/graphics/technology/promethium-quality.png"),
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-vitamin-infused-promethium-science-2",
        },
    },
    prerequisites = {"maraxsis-promethium-quality-1"},
    unit = {
        count = 50000000,
        time = 120,
        ingredients = {}, -- ingredients are filled in final-fixes
    },
}}

data:extend {{
    type = "technology",
    name = "maraxsis-promethium-quality-3",
    icons = util.technology_icon_constant_recipe_productivity("__maraxsis__/graphics/technology/promethium-quality.png"),
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-vitamin-infused-promethium-science-3",
        },
    },
    prerequisites = {"maraxsis-promethium-quality-2"},
    unit = {
        count = 500000000,
        time = 120,
        ingredients = {}, -- ingredients are filled in final-fixes
    },
}}


data:extend {{
    type = "technology",
    name = "maraxsis-promethium-quality-4",
    icons = util.technology_icon_constant_recipe_productivity("__maraxsis__/graphics/technology/promethium-quality.png"),
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-vitamin-infused-promethium-science-4",
        },
    },
    prerequisites = {"maraxsis-promethium-quality-3"},
    unit = {
        count = 5000000000,
        time = 120,
        ingredients = {}, -- ingredients are filled in final-fixes
    },
}}

data:extend {{
    type = "fluid",
    name = "maraxsis-omega-3",
    icon = "__maraxsis__/graphics/icons/omega-3.png",
    icon_size = 64,
    default_temperature = 15,
    base_color = {255, 255, 8},
    flow_color = {255, 133, 3},
    gas_temperature = 365,
    auto_barrel = true,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-omega-3",
    icon = "__maraxsis__/graphics/icons/omega-3.png",
    icon_size = 64,
    enabled = false,
    energy_required = 20,
    ingredients = {
        {type = "item", name = "maraxsis-fish-oil", amount = 1},
        {type = "item", name = "nutrients", amount = 1},
        {type = "fluid", name = "maraxsis-liquid-atmosphere", amount = 5},
        {type = "fluid", name = "water", amount = 160},
    },
    results = {
        {type = "fluid", name = "maraxsis-omega-3", amount = 80},
    },
    categories = {"cryogenics"},
    allow_productivity = true,
    allow_quality = false,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-vitamin-infused-agricultural-science",
    energy_required = 4,
    enabled = false,
    categories = {"maraxsis-hydro-plant"},
    ingredients = {
        {type = "item", name = "agricultural-science-pack", amount = 1, quality_max = "normal"},
        {type = "fluid", name = "maraxsis-omega-3", amount = 10},
    },
    results = {
        {type = "item", name = "agricultural-science-pack", amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1, quality_min = "uncommon"},
        {type = "fluid", name = "water", amount = 20},
    },
    allow_productivity = false,
    can_set_quality = false,
    main_product = "agricultural-science-pack",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-vitamin-infused-hydraulic-science",
    energy_required = 4,
    enabled = false,
    categories = {"maraxsis-hydro-plant"},
    ingredients = {
        {type = "item", name = "hydraulic-science-pack", amount = 1, quality_max = "rare", quality_min = "rare"},
        {type = "fluid", name = "maraxsis-omega-3", amount = 10},
    },
    results = {
        {type = "item", name = "hydraulic-science-pack", amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1, quality_min = "epic"},
        {type = "fluid", name = "water", amount = 20},
    },
    allow_productivity = false,
    can_set_quality = false,
    main_product = "hydraulic-science-pack",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-vitamin-infused-promethium-science-1",
    energy_required = 6,
    enabled = false,
    categories = {"maraxsis-hydro-plant"},
    ingredients = {
        {type = "item", name = "promethium-science-pack", amount = 1, quality_max = "normal", quality_min = "normal"},
        {type = "fluid", name = "maraxsis-omega-3", amount = 15},
    },
    results = {
        {type = "item", name = "promethium-science-pack", amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1, quality_min = "uncommon"},
        {type = "fluid", name = "water", amount = 25},
    },
    allow_productivity = false,
    can_set_quality = false,
    main_product = "promethium-science-pack",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-vitamin-infused-promethium-science-2",
    energy_required = 8,
    enabled = false,
    categories = {"maraxsis-hydro-plant"},
    ingredients = {
        {type = "item", name = "promethium-science-pack", amount = 1, quality_max = "uncommon", quality_min = "uncommon"},
        {type = "item", name = "nutrients", amount = 1, quality_min = "normal"},
        {type = "fluid", name = "maraxsis-omega-3", amount = 20},
    },
    results = {
        {type = "item", name = "promethium-science-pack", amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1, quality_min = "rare"},
        {type = "fluid", name = "water", amount = 30},
    },
    allow_productivity = false,
    can_set_quality = false,
    main_product = "promethium-science-pack",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-vitamin-infused-promethium-science-3",
    energy_required = 10,
    enabled = false,
    categories = {"maraxsis-hydro-plant"},
    ingredients = {
        {type = "item", name = "promethium-science-pack", amount = 1, quality_max = "rare", quality_min = "rare"},
        {type = "item", name = "nutrients", amount = 1, quality_min = "uncommon"},
        {type = "fluid", name = "maraxsis-omega-3", amount = 25},
    },
    results = {
        {type = "item", name = "promethium-science-pack", amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1, quality_min = "epic"},
        {type = "fluid", name = "water", amount = 35},
    },
    allow_productivity = false,
    can_set_quality = false,
    main_product = "promethium-science-pack",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-vitamin-infused-promethium-science-4",
    energy_required = 20,
    enabled = false,
    categories = {"maraxsis-hydro-plant"},
    ingredients = {
        {type = "item", name = "promethium-science-pack", amount = 1, quality_max = "epic", quality_min = "epic"},
        {type = "item", name = "nutrients", amount = 1, quality_min = "rare"},
        {type = "fluid", name = "maraxsis-omega-3", amount = 30},
    },
    results = {
        {type = "item", name = "promethium-science-pack", amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1, quality_min = "legendary"},
        {type = "fluid", name = "water", amount = 40},
    },
    allow_productivity = false,
    can_set_quality = false,
    main_product = "promethium-science-pack",
}}
