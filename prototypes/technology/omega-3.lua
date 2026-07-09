data:extend {{
    type = "technology",
    name = "maraxsis-omega_3",
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
    icons = {
        {
            icon = "__maraxsis__/graphics/technology/omega-3.png",
            icon_size = 256,
        },
        {
            icon = data.raw.quality.normal.icon,
            icon_size = data.raw.quality.normal.icon_size,
            scale = 0.5,
            shift = {45, 45},
            floating = true
        },
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
    categories = {"cryogenics", "maraxsis-hydro-plant"},
    allow_productivity = true,
    allow_quality = false,
}}

local science_pack = "agricultural-science-pack"

if mods.Krastorio2 then
    science_pack = "kr-agricultural-research-data"
end

data:extend {{
    type = "recipe",
    name = "maraxsis-vitamin-infused-agricultural-science",
    localised_name = {"recipe-name.maraxsis-vitamin-infused-agricultural-science", "normal", "uncommon"},
    energy_required = 4,
    enabled = false,
    categories = {"maraxsis-hydro-plant"},
    ingredients = {
        {type = "item", name = science_pack, amount = 1, quality_max = "normal"},
        {type = "fluid", name = "maraxsis-omega-3", amount = 10},
    },
    results = {
        {type = "item", name = science_pack, amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1, quality_min = "uncommon"},
        {type = "fluid", name = "water", amount = 20},
    },
    allow_productivity = false,
    can_set_quality = false,
    main_product = science_pack,
    icons = {
        {
            icon = data.raw.item[science_pack].icon,
            icon_size = data.raw.item[science_pack].icon_size
        },
        {
            icon = data.raw.quality.uncommon.icon,
            icon_size = data.raw.quality.uncommon.icon_size,
            scale = 0.25,
            shift = {-10, 10},
            floating = true
        },
    },
}}

local science_pack = "hydraulic-science-pack"

if mods.Krastorio2 then
    science_pack = "hydraulic-research-data"
end

data:extend {{
    type = "recipe",
    name = "maraxsis-vitamin-infused-hydraulic-science",
    localised_name = {"recipe-name.maraxsis-vitamin-infused-hydraulic-science", "rare", "epic"},
    energy_required = 4,
    enabled = false,
    categories = {"maraxsis-hydro-plant"},
    ingredients = {
        {type = "item", name = science_pack, amount = 1, quality_max = "rare", quality_min = "rare"},
        {type = "fluid", name = "maraxsis-omega-3", amount = 10},
    },
    results = {
        {type = "item", name = science_pack, amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1, quality_min = "epic"},
        {type = "fluid", name = "water", amount = 20},
    },
    allow_productivity = false,
    can_set_quality = false,
    main_product = science_pack,
    icons = {
        {
            icon = data.raw.item[science_pack].icon,
            icon_size = data.raw.item[science_pack].icon_size
        },
        {
            icon = data.raw.quality.epic.icon,
            icon_size = data.raw.quality.epic.icon_size,
            scale = 0.25,
            shift = {-10, 10},
            floating = true
        },
    },
}}
