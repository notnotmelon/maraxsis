if not mods["Krastorio2-spaced-out"] and not mods["Krastorio2"] then return end

if not mods["Tech_Cards_For_Modded_Planets"] then
    data.raw.tool["hydraulic-science-pack"].icon = "__maraxsis__/graphics/icons/hydraulic-tech-card.png"
    data.raw.tool["hydraulic-science-pack"].localised_name = {"item-name.hydraulic-tech-card"}
    data.raw.technology["hydraulic-science-pack"].icon = "__maraxsis__/graphics/technology/hydraulic-tech-card.png"
    data.raw.technology["hydraulic-science-pack"].localised_name = {"item-name.hydraulic-tech-card"}
end

data:extend {{
    type = "item",
    name = "hydraulic-research-data",
    stack_size = 200,
    icon = "__maraxsis__/graphics/icons/hydraulic-research-data.png",
    icon_size = 64,
    subgroup = "science-pack",
    weight = 1000,
    order = "ao75[hydraulic-research-data]"
}}

data:extend {{
    type = "recipe",
    name = "hydraulic-research-data",
    enabled = false,
    energy_required = 30,
    ingredients = {
        {type = "item",  name = "maraxsis-wyrm-specimen", amount = 1},
        {type = "item",  name = "salt",                   amount = 1},
        {type = "fluid", name = "maraxsis-saline-water",  amount = 300},
    },
    results = {
        {type = "item", name = "hydraulic-research-data", amount = 1},
    },
    allow_productivity = true,
    category = "maraxsis-hydro-plant",
    auto_recycle = false,
    surface_conditions = maraxsis.surface_conditions(),
}}
table.insert(data.raw.technology["hydraulic-science-pack"].effects, {
    type = "unlock-recipe",
    recipe = "hydraulic-research-data"
})

data:extend {{
    type = "recipe",
    name = "hydraulic-science-pack",
    enabled = false,
    energy_required = 20,
    ingredients = {
        {type = "item", name = "hydraulic-research-data", amount = 5},
        {type = "item", name = "kr-blank-tech-card",      amount = 5},
    },
    results = {
        {type = "item", name = "hydraulic-science-pack", amount = 5},
    },
    allow_productivity = true,
    category = "kr-tech-cards",
    auto_recycle = false,
    surface_conditions = maraxsis.surface_conditions(),
}}

table.insert(data.raw.recipe["maraxsis-hydrolox-rocket-fuel"].ingredients, {
    name = "iron-plate",
    amount = 1,
    type = "item"
})
data.raw.recipe["maraxsis-hydrolox-rocket-fuel"].surface_conditions = maraxsis.surface_conditions()
