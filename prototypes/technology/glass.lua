data:extend {{
    type = "technology",
    name = "maraxsis-glassworking",
    icon = "__maraxsis__/graphics/technology/glassworking.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-sand-extraction",
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-glass-panes",
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-pressure-dome",
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-atmosphere",
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-limestone-processing",
        },
    },
    prerequisites = {"planet-discovery-maraxsis"},
    research_trigger = {
        type = "mine-entity",
        entity = "maraxsis-mollusk-husk"
    },
    order = "eb[glassworking]",
}}

local limestone_variants = {}
for i = 1, 3 do
    limestone_variants[i] = {
        filename = "__maraxsis__/graphics/icons/limestone-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 2,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = "limestone",
    icon = "__maraxsis__/graphics/icons/limestone-1.png",
    icon_size = 64,
    pictures = limestone_variants,
    stack_size = 200,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-glass-panes",
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = "item", name = maraxsis_constants.SAND_ITEM_NAME,      amount = 3},
        {type = "item", name = "limestone", amount = 1},
        {type = "item", name = "salt",      amount = 2},
    },
    results = {
        {type = "item", name = "maraxsis-glass-panes", amount = 1},
    },
    allow_productivity = true,
    category = "metallurgy",
    auto_recycle = true
}}

local glass_variants = {}
for i = 1, 6 do
    glass_variants[i] = {
        filename = "__maraxsis__/graphics/icons/glass-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 2,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = "maraxsis-glass-panes",
    icon = "__maraxsis__/graphics/icons/glass-1.png",
    pictures = glass_variants,
    icon_size = 64,
    stack_size = 200,
}}

local sand_variants = {}
for i = 1, 3 do
    sand_variants[i] = {
        filename = "__maraxsis__/graphics/icons/sand-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 0.575,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = maraxsis_constants.SAND_ITEM_NAME,
    icon = "__maraxsis__/graphics/icons/sand-3.png",
    pictures = sand_variants,
    icon_size = 64,
    stack_size = 100,
    localised_name = {"item-name.sand"},
    localised_description = {"item-description.sand"},
}}

data:extend {{
    type = "technology",
    name = "maraxsis-glass-productivity",
    icons = util.technology_icon_constant_recipe_productivity("__maraxsis__/graphics/technology/glass-productivity.png"),
    icon_size = 256,
    effects = {
        {
            type = "change-recipe-productivity",
            recipe = "maraxsis-glass-panes",
            change = 0.1
        },
    },
    prerequisites = {"maraxsis-project-seadragon"},
    unit = {
        count_formula = "1.5^L*1000",
        ingredients = {
            {"automation-science-pack",  1},
            {"logistic-science-pack",    1},
            {"chemical-science-pack",    1},
            {"production-science-pack",  1},
            {"utility-science-pack",     1},
            {"metallurgic-science-pack", 1},
            {"hydraulic-science-pack",   1},
        },
        time = 60
    },
    max_level = "infinite",
    upgrade = true
}}

if data.raw.recipe["glass"] or mods["aai-industry"] then
    table.insert(data.raw.technology["maraxsis-glass-productivity"].effects, 1, {
        type = "change-recipe-productivity",
        recipe = "glass",
        change = 0.1
    })
end

data:extend {{
    type = "recipe",
    name = "maraxsis-limestone-processing",
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = "item", name = "limestone", amount = 1},
    },
    results = {
        {type = "item", name = "calcite", amount = 1},
        {type = "item", name = "stone",   amount = 1},
    },
    icon = "__maraxsis__/graphics/icons/limestone-processing.png",
    icon_size = 64,
    allow_productivity = true,
    category = "maraxsis-hydro-plant-or-foundry",
    allow_decomposition = false,
    main_product = "calcite",
    auto_recycle = false,
}}
