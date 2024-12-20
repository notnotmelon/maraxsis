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
        {
            type = "unlock-recipe",
            recipe = "maraxsis-petroleum-gas-cracking"
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
maraxsis_rocket_part.localised_name = maraxsis_rocket_part.localised_name or {"item-name.rocket-part"}
table.insert(maraxsis_rocket_part.ingredients, {type = "item", name = "maraxsis-super-sealant-substance", amount = 1})
maraxsis_rocket_part.enabled = false
maraxsis_rocket_part.surface_conditions = {
    {property = "pressure", min = 200000, max = 200000},
}
maraxsis_rocket_part.auto_recycle = false
maraxsis_rocket_part.order = data.raw.item["rocket-part"].order .. "-a[maraxsis]"
data:extend {maraxsis_rocket_part}

data:extend {{
    type = "recipe",
    name = "maraxsis-hydrolox-rocket-fuel",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "fluid", name = "maraxsis-oxygen",   amount = 200},
        {type = "fluid", name = "maraxsis-hydrogen", amount = 200},
    },
    results = {
        {type = "item", name = "rocket-fuel", amount = 1},
    },
    icon = "__maraxsis__/graphics/icons/hydrolox-rocket-fuel.png",
    icon_size = 64,
    allow_productivity = true,
    category = "maraxsis-hydro-plant",
    main_product = "rocket-fuel",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-super-sealant-substance",
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = "item",  name = "sulfur",    amount = 1},
        {type = "fluid", name = "heavy-oil", amount = 100},
        {type = "fluid", name = "steam",     amount = 100},
    },
    results = {
        {type = "item", name = "maraxsis-super-sealant-substance", amount = 1},
    },
    enabled = false,
    category = "chemistry-or-cryogenics",
    allow_productivity = true,
    auto_recycle = false,
}}

local super_sealant_substance_variants = {}
for i = 1, 3 do
    super_sealant_substance_variants[i] = {
        filename = "__maraxsis__/graphics/icons/super-sealant-substance-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 2,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = "maraxsis-super-sealant-substance",
    icon = "__maraxsis__/graphics/icons/super-sealant-substance-1.png",
    icon_size = 64,
    stack_size = data.raw.item["rocket-fuel"].stack_size,
    weight = data.raw.item["rocket-fuel"].weight,
    pictures = super_sealant_substance_variants,
}}

data:extend {{
    type = "technology",
    name = "maraxsis-super-sealant-substance-productivity",
    icons = util.technology_icon_constant_recipe_productivity("__maraxsis__/graphics/technology/super-sealant-substance-productivity.png"),
    icon_size = 256,
    effects = {
        {
            type = "change-recipe-productivity",
            recipe = "maraxsis-super-sealant-substance",
            change = 0.1
        },
    },
    prerequisites = {"maraxsis-project-seadragon"},
    unit = {
        count_formula = "1.5^L*1000",
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack",   1},
            {"chemical-science-pack",   1},
            {"utility-science-pack",    1},
            {"hydraulic-science-pack",  1},
        },
        time = 60
    },
    max_level = "infinite",
    upgrade = true
}}
