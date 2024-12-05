local effects = {}

data:extend {{
    type = "technology",
    name = "maraxsis-deepsea-research",
    icon = "__maraxsis__/graphics/technology/deepsea-research.png",
    icon_size = 256,
    effects = effects,
    prerequisites = {"maraxsis-project-seadragon"},
    unit = {
        count = 2000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack",   1},
            {"military-science-pack",   1},
            {"chemical-science-pack",   1},
            {"production-science-pack", 1},
            {"utility-science-pack",    1},
            {"hydraulic-science-pack",  1},
        },
        time = 60,
    },
    order = "ea[deepsea-research]",
}}

data:extend {{
    type = "item-subgroup",
    name = "maraxsis-deepsea-research",
    order = "yy",
    group = "intermediate-products",
}}

local automation_science = table.deepcopy(data.raw.recipe["automation-science-pack"])
local logistic_science = table.deepcopy(data.raw.recipe["logistic-science-pack"])
local military_science = table.deepcopy(data.raw.recipe["military-science-pack"])
local chemical_science = table.deepcopy(data.raw.recipe["chemical-science-pack"])
local production_science = table.deepcopy(data.raw.recipe["production-science-pack"])
local utility_science = table.deepcopy(data.raw.recipe["utility-science-pack"])

local function update_recipe_icon(recipe, fluid)
    local science_pack = data.raw.tool[recipe.name]
    if not (recipe.icon or science_pack.icon) then return end
    fluid = data.raw.fluid[fluid]
    recipe.icons = {
        {icon = recipe.icon or science_pack.icon, icon_size = recipe.icon_size or science_pack.icon_size},
        {icon = fluid.icon,                       icon_size = fluid.icon_size,                           scale = 0.4, shift = {6, 6}},
    }
    recipe.icon = nil
    recipe.icon_size = nil
end

update_recipe_icon(automation_science, "maraxsis-saline-water")
update_recipe_icon(logistic_science, "maraxsis-brackish-water")
update_recipe_icon(military_science, "lava")
update_recipe_icon(chemical_science, "maraxsis-atmosphere")
update_recipe_icon(production_science, "maraxsis-oxygen")
update_recipe_icon(utility_science, "maraxsis-hydrogen")

table.insert(automation_science.ingredients, {type = "fluid", name = "maraxsis-saline-water", amount = 50})
table.insert(logistic_science.ingredients, {type = "fluid", name = "maraxsis-brackish-water", amount = 50})
table.insert(military_science.ingredients, {type = "fluid", name = "lava", amount = 100})
table.insert(chemical_science.ingredients, {type = "fluid", name = "maraxsis-atmosphere", amount = 100})
table.insert(production_science.ingredients, {type = "fluid", name = "maraxsis-oxygen", amount = 100})
table.insert(utility_science.ingredients, {type = "fluid", name = "maraxsis-hydrogen", amount = 200})

for _, recipe in pairs {
    automation_science,
    logistic_science,
    military_science,
    chemical_science,
    production_science,
    utility_science,
} do
    recipe.localised_name = {"item-name." .. recipe.name}
    recipe.name = "maraxsis-deepsea-research-" .. recipe.name
    recipe.category = "maraxsis-hydro-plant"
    recipe.subgroup = "maraxsis-deepsea-research"
    recipe.enabled = false
    recipe.auto_recycle = false
    recipe.surface_conditions = {{
        property = "pressure",
        min = 400000,
        max = 400000,
    }}
    recipe.results[1].amount = recipe.results[1].amount * 2
    effects[#effects + 1] = {type = "unlock-recipe", recipe = recipe.name}
end

data:extend {automation_science, logistic_science, military_science, chemical_science, production_science, utility_science}
