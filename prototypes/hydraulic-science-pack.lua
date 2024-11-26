data:extend {{
    type = "tool",
    name = "hydraulic-science-pack",
    icon = "__maraxsis__/graphics/icons/hydraulic-science-pack.png",
    icon_size = 64,
    subgroup = "science-pack",
    order = "j[hydraulic-science-pack]",
    stack_size = data.raw.tool["automation-science-pack"].stack_size,
    durability = data.raw.tool["automation-science-pack"].durability,
    durability_description_key = data.raw.tool["automation-science-pack"].durability_description_key,
    durability_description_value = data.raw.tool["automation-science-pack"].durability_description_value,
    weight = data.raw.tool["automation-science-pack"].weight,
}}

data:extend {{
    type = "technology",
    name = "hydraulic-science-pack",
    icon = "__maraxsis__/graphics/technology/hydraulic-science-pack.png",
    icon_size = 256,
    essential = true,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "hydraulic-science-pack",
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
        "maraxsis-wyrm-confinement",
        "maraxsis-piscary",
    },
    order = "eg[hydraulic-science-pack]",
}}

data:extend {{
    type = "recipe",
    name = "hydraulic-science-pack",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "item", name = "maraxsis-wyrm-specimen", amount = 1},
    },
    results = {
        {type = "item", name = "hydraulic-science-pack", amount = 1},
    },
    allow_productivity = true,
    category = "maraxsis-hydro-plant"
}}
