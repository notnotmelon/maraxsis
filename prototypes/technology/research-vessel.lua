data:extend {{
    type = "technology",
    name = "maraxsis-research-vessel",
    icon = "__maraxsis__/graphics/technology/research-vessel.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-empty-research-vessel"
        }
    },
    order = "es[maraxsis-research-vessel]",
    prerequisites = {"maraxsis-project-seadragon", "agricultural-science-pack"},
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
    type = "item",
    name = "maraxsis-empty-research-vessel",
    icon = "__maraxsis__/graphics/icons/research-vessel-tipped.png",
    icon_size = 64,
    stack_size = 20,
    weight = 1000000 / 100,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-empty-research-vessel",
    enabled = false,
    energy_required = 1,
    ingredients = {
        {type = "item", name = "maraxsis-glass-panes", amount = 10},
        {type = "item", name = "steel-plate",          amount = 10},
    },
    results = {
        {type = "item", name = "maraxsis-empty-research-vessel", amount = 1},
    },
    allow_productivity = false,
    category = "crafting",
    auto_recycle = true,
}}

data:extend {{
    type = "item-subgroup",
    name = "maraxsis-empty-research-vessel",
    group = "intermediate-products",
    order = "gff",
}}

data:extend {{
    type = "item-subgroup",
    name = "maraxsis-fill-research-vessel",
    group = "intermediate-products",
    order = "gfff",
}}
