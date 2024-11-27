data:extend {{
    type = "technology",
    name = "maraxsis-project-seadragon",
    icon = "__maraxsis__/graphics/technology/project-seadragon.png",
    icon_size = 256,
    effects = {
        {
            type = "nothing",
            use_icon_overlay_constant = true,
            icon = "__maraxsis__/graphics/technology/project-seadragon.png",
            icon_size = 256,
            effect_description = {"modifier-description.maraxsis-project-seadragon"}
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-rocket-part"
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-super-sealant-substance"
        },
    },
    prerequisites = {"hydraulic-science-pack", "coal-liquefaction"},
    unit = {
        count = 500,
        ingredients = {
            {"hydraulic-science-pack", 1},
        },
        time = 30,
    },
    order = "ea[seadragon]",
}}

local maraxsis_rocket_part = table.deepcopy(data.raw["recipe"]["rocket-part"])
maraxsis_rocket_part.name = "maraxsis-rocket-part"
maraxsis_rocket_part.localised_name = maraxsis_rocket_part.localised_name  or {"item-name.rocket-part"}
table.insert(maraxsis_rocket_part.ingredients, {type = "item", name = "maraxsis-super-sealant-substance", amount = 1})
maraxsis_rocket_part.enabled = false
maraxsis_rocket_part.surface_conditions = {
    {property = "pressure", min = 200000, max = 200000},
}
maraxsis_rocket_part.order = data.raw.item["rocket-part"].order .. "-a[maraxsis]"
data:extend {maraxsis_rocket_part}

data:extend {{
    type = "recipe",
    name = "maraxsis-super-sealant-substance",
    enabled = false,
    energy_required = 2,
    ingredients = {
        {type = "item", name = "sulfur", amount = 1},
        {type = "fluid", name = "heavy-oil", amount = 200},
        {type = "fluid", name = "steam", amount = 100},
    },
    results = {
        {type = "item", name = "maraxsis-super-sealant-substance", amount = 1},
    },
    enabled = false,
    category = "chemistry-or-cryogenics",
    allow_productivity = true,
    surface_conditions = {{
        property = "gravity",
        min = 0,
        max = 0,
    }}
}}

data:extend {{
    type = "item",
    name = "maraxsis-super-sealant-substance",
    icon = "__maraxsis__/graphics/icons/super-sealant-substance.png",
    icon_size = 64,
    stack_size = data.raw.item["rocket-fuel"].stack_size,
    weight = data.raw.item["rocket-fuel"].weight,
}}