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
        (not mods.pystellarexpedition) and {
            type = "unlock-recipe",
            recipe = "maraxsis-petroleum-gas-cracking"
        } or nil,
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
maraxsis_rocket_part.enabled = false
maraxsis_rocket_part.surface_conditions = {
    {property = "pressure", min = 200000, max = 200000},
}
maraxsis_rocket_part.auto_recycle = false
maraxsis_rocket_part.order = data.raw.item["rocket-part"].order .. "-a[maraxsis]"
data:extend {maraxsis_rocket_part}

data:extend {{
    type = "recipe",
    name = "maraxsis-super-sealant-substance",
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = "item",  name = "sulfur",    amount = 3},
        {type = "fluid", name = "heavy-oil", amount = 25},
        {type = "fluid", name = "hydrogen",     amount = 100},
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
