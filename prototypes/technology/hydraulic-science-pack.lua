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
    research_trigger = {
        type = "craft-item",
        item = "maraxsis-wyrm-specimen",
        amount = 1,
    },
    prerequisites = {
        "maraxsis-wyrm-confinement",
    },
    order = "eg[hydraulic-science-pack]",
}}

data:extend {{
    type = "recipe",
    name = "hydraulic-science-pack",
    enabled = false,
    energy_required = 30,
    ingredients = {
        {type = "item",  name = "maraxsis-wyrm-specimen", amount = 1},
        {type = "item",  name = "maraxsis-salt",          amount = 1},
        {type = "fluid", name = "maraxsis-saline-water",  amount = 300},
    },
    results = {
        {type = "item", name = "hydraulic-science-pack", amount = 1},
    },
    allow_productivity = true,
    category = "maraxsis-hydro-plant",
    auto_recycle = false,
    surface_conditions = maraxsis.surface_conditions(),
}}
