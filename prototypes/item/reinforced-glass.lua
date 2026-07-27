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
    name = "maraxsis-reinforced-glass",
    icon = "__maraxsis__/graphics/icons/glass-1.png",
    pictures = glass_variants,
    icon_size = 64,
    stack_size = 200,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-reinforced-glass",
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = "item", name = maraxsis_constants.SAND_ITEM_NAME, amount = 3},
        {type = "item", name = "limestone", amount = 1},
        {type = "item", name = "salt",      amount = 2},
    },
    results = {
        {type = "item", name = "maraxsis-reinforced-glass", amount = 1, quality_change = -1},
    },
    allow_productivity = true,
    categories = {"metallurgy", "maraxsis-hydro-plant"},
    auto_recycle = true
}}

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
            recipe = "maraxsis-reinforced-glass",
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
            recipe = "maraxsis-limestone-crushing",
        },
    },
    prerequisites = {"planet-discovery-maraxsis"},
    research_trigger = {
        type = "mine-entity",
        entities = {"maraxsis-mollusk-husk"}
    },
    order = "eb[glassworking]",
}}

data:extend {{
    type = "technology",
    name = "maraxsis-glass-productivity",
    icons = util.technology_icon_constant_recipe_productivity("__maraxsis__/graphics/technology/glass-productivity.png"),
    icon_size = 256,
    effects = {
        {
            type = "change-recipe-productivity",
            recipe = "maraxsis-pressure-dome",
            change = 0.1
        }
    },
    prerequisites = {"maraxsis-project-seadragon", "production-science-pack", "utility-science-pack", "metallurgic-science-pack"},
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
    upgrade = true,
    PlanetsLib_recipe_productivity_effects = {
        effects = {
            {
                type = "item",
                name = "maraxsis-reinforced-glass",
                change = 0.1
            },
            {
                type = "item",
                name = "glass",
                change = 0.1
            },
            {
                type = "item",
                name = "kr-glass",
                change = 0.1
            },
        },
    }
}}