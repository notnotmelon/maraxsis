data:extend {{
    type = "tool",
    name = "h2o-hydraulic-science-pack",
    icon = "__maraxsis__/graphics/icons/hydraulic-science-pack.png",
    icon_size = 64,
    icon_mipmaps = nil,
    subgroup = "science-pack",
    order = "j[hydraulic-science-pack]",
    stack_size = 200,
    durability = data.raw.tool["automation-science-pack"].durability,
}}

table.insert(data.raw.lab.lab.inputs, "h2o-hydraulic-science-pack")

data:extend {{
    type = "technology",
    name = "h2o-hydraulic-science-pack",
    icon = "__maraxsis__/graphics/technology/hydraulic-science-pack.png",
    icon_size = 256,
    icon_mipmaps = nil,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "h2o-hydraulic-science-pack",
        },
    },
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
    prerequisites = {
        "h2o-wyrm-confinement",
    },
    order = "eg[hydraulic-science-pack]",
}}

data:extend {{
    type = "recipe",
    name = "h2o-hydraulic-science-pack",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "item", name = "h2o-wyrm-specimen", amount = 1},
    },
    results = {
        {type = "item", name = "h2o-hydraulic-science-pack", amount = 1},
    },
    allow_productivity = true,
    category = "h2o-hydro-plant"
}}
