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
        ingredients = {
            {"automation-science-pack",  1},
            {"logistic-science-pack",    1},
            {"chemical-science-pack",    1},
            {"military-science-pack",    1},
            {"space-science-pack",    1},
            {"production-science-pack",  1},
            {"utility-science-pack",     1},
            {"metallurgic-science-pack", 1},
            {"electromagnetic-science-pack", 1},
            {"agricultural-science-pack", 1},
            {"hydraulic-science-pack",   1},
            {"cryogenic-science-pack",   1},
            {"promethium-science-pack",   1},
        },
        time = 120
    },
    max_level = "infinite",
    upgrade = true
}}
