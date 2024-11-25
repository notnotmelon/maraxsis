data:extend {{
    type = "technology",
    name = "maraxsis-glassworking",
    icon = "__maraxsis__/graphics/technology/glassworking.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-glass-panes",
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-pressure-dome",
        },
    },
    prerequisites = {"maraxsis"},
    unit = {
        count = 3000,
        ingredients = {
            {"automation-science-pack",      1},
            {"logistic-science-pack",        1},
            {"chemical-science-pack",        1},
            {"space-science-pack",           1},
            {"production-science-pack",      1},
            {"utility-science-pack",         1},
            {"metallurgic-science-pack",     1},
            {"electromagnetic-science-pack", 1},
            {"agricultural-science-pack",    1},
        },
        time = 60,
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
        {type = "item", name = "sand",      amount = 3},
        {type = "item", name = "limestone", amount = 1},
        {type = "item", name = "salt",      amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-glass-panes", amount = 1},
    },
    allow_productivity = true,
    category = "metallurgy"
}}

local glass_variants = {}
for i = 1, 9 do
    glass_variants[i] = {
        filename = "__maraxsis__/graphics/icons/glass-panes-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 3,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = "maraxsis-glass-panes",
    icon = "__maraxsis__/graphics/icons/glass-panes-1.png",
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
        scale = 1 / 3,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = "sand",
    icon = "__maraxsis__/graphics/icons/sand-3.png",
    pictures = sand_variants,
    icon_size = 64,
    stack_size = 100,
}}
