if not mods["aai-industry"] then return end

data.raw.recipe["motor"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["electric-motor"].category = "maraxsis-hydro-plant-or-assembling"

data:extend {{
    type = "recipe",
    name = "maraxsis-aai-sand-conversion",
    enabled = false,
    ingredients = {
        {type = "item", name = "maraxsis-sand", amount = 1}
    },
    results = {
        {type = "item", name = "sand", amount = 2}
    },
    localised_name = {"item-name.sand"}
}}

table.insert(data.raw.technology["sand-processing"].effects, {
    type = "unlock-recipe",
    recipe = "maraxsis-aai-sand-conversion"
})