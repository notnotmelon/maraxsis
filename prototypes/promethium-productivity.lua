data:extend {{
    type = "technology",
    name = "maraxsis-promethium-productivity",
    icons = util.technology_icon_constant_recipe_productivity("__maraxsis__/graphics/technology/promethium-productivity.png"),
    icon_size = 256,
    effects = {
        {
            type = "change-recipe-productivity",
            recipe = "promethium-science-pack",
            change = 0.1
        },
    },
    prerequisites = {"promethium-science-pack"},
    unit = {
        count_formula = "1.5^L*1000",
        ingredients = {},
        -- note: ingredients are set in data-final-fixes.lua
        time = 120
    },
    max_level = "infinite",
    upgrade = true
}}
