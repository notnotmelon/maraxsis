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

data.raw["assembling-machine"]["kr-atmospheric-condenser"].maraxsis_buildability_rules = {water = false, dome = false, coral = false, trench = false, trench_entrance = false, trench_lava = false}
data.raw["furnace"]["kr-air-purifier"].maraxsis_buildability_rules = {water = false, dome = false, coral = false, trench = false, trench_entrance = false, trench_lava = false}

data.raw.planet["maraxsis"].map_gen_settings.autoplace_settings.entity.settings["kr-rare-metal-ore"] = {}
data.raw.planet["maraxsis"].map_gen_settings.autoplace_controls["kr-rare-metal-ore"] = {size = 10}

data.raw.recipe["maraxsis-conduit"].ingredients = {
    {type = "item", name = "beacon",                           amount = 1},
    {type = "item", name = "maraxsis-glass-panes",             amount = 25},
    {type = "item", name = "kr-rare-metals",                   amount = 50},
    {type = "item", name = "maraxsis-super-sealant-substance", amount = 15},
    {type = "item", name = "kr-energy-control-unit",           amount = 5},
}

table.insert(data.raw.technology["maraxsis-effect-transmission-2"].prerequisites, "kr-energy-control-unit")

table.insert(data.raw.technology["maraxsis-glass-productivity"].effects, {
    type = "change-recipe-productivity",
    recipe = "kr-glass",
    change = 0.1
})

data.raw.item["maraxsis-glass-panes"].localised_name = {"item-name.maraxsis-reinforced-glass"}

data.raw.technology["maraxsis-glass-productivity"].unit.ingredients = {
    {"production-science-pack",  1},
    {"utility-science-pack",     1},
    {"space-science-pack",       1},
    {"metallurgic-science-pack", 1},
    {"hydraulic-science-pack",   1},
}

table.insert(data.raw.recipe["maraxsis-abyssal-diving-gear"].ingredients, {type = "item", name = "kr-rare-metals", amount = 50})
table.insert(data.raw.recipe["maraxsis-nuclear-submarine"].ingredients, {type = "item", name = "kr-rare-metals", amount = 200})
table.insert(data.raw.recipe["maraxsis-sonar"].ingredients, {type = "item", name = "kr-rare-metals", amount = 30})
table.insert(data.raw.recipe["maraxsis-salt-reactor"].ingredients, {type = "item", name = "kr-rare-metals", amount = 100})
table.insert(data.raw.recipe["maraxsis-oversized-steam-turbine"].ingredients, {type = "item", name = "kr-rare-metals", amount = 100})
table.insert(data.raw.recipe["maraxsis-hydro-plant"].ingredients, {type = "item", name = "kr-rare-metals", amount = 10})
table.insert(data.raw.recipe["maraxsis-diesel-submarine"].ingredients, {type = "item", name = "kr-rare-metals", amount = 10})
table.insert(data.raw.recipe["maraxsis-wyrm-confinement-cell"].ingredients, {type = "item", name = "kr-rare-metals", amount = 1})

data.raw.technology["kr-quantum-computer"].prerequisites = {
    "kr-ai-core",
    "quantum-processor",
    "maraxsis-project-seadragon",
    "kr-singularity-tech-card",
}

data.raw.technology["kr-quantum-computer"].unit.ingredients = {
    {"production-science-pack",      1},
    {"utility-science-pack",         1},
    {"space-science-pack",           1},
    {"kr-singularity-tech-card",     1},
    {"metallurgic-science-pack",     1},
    {"agricultural-science-pack",    1},
    {"electromagnetic-science-pack", 1},
    {"hydraulic-science-pack",       1},
    {"cryogenic-science-pack",       1},
}

if not mods["no-quality"] then
    data.raw["assembling-machine"]["kr-quantum-computer"].effect_receiver.base_effect.quality = 5
end

data.raw.recipe["kr-quantum-computer"].category = "maraxsis-hydro-plant"

data.raw.recipe["kr-quantum-computer"].ingredients = {
    {type = "item", name = "kr-research-server",   amount = 3},
    {type = "item", name = "tungsten-plate",       amount = 100},
    {type = "item", name = "kr-rare-metals",       amount = 50},
    {type = "item", name = "kr-ai-core",           amount = 50},
    {type = "item", name = "quantum-processor",    amount = 100},
    {type = "item", name = "maraxsis-glass-panes", amount = 200},
}

data.raw["assembling-machine"]["kr-quantum-computer"].surface_conditions = {{
    property = "pressure",
    min = 400000,
    max = 400000,
}}

data.raw.recipe["maraxsis-microplastics"].ingredients = {
    {type = "item", name = "maraxsis-tropical-fish",   amount = 1},
    {type = "item", name = "shotgun-shell", amount = 1},
}
