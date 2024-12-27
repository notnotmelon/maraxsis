if not mods["aai-industry"] then return end

data.raw.recipe["motor"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["electric-motor"].category = "maraxsis-hydro-plant-or-assembling"

local engine_unit_productivity = data.raw["technology"]["maraxsis-engine-unit-productivity"]
table.insert(engine_unit_productivity.effects, {
    type = "change-recipe-productivity",
    recipe = "motor",
    change = 0.1
})
table.insert(engine_unit_productivity.effects, {
    type = "change-recipe-productivity",
    recipe = "electric-motor",
    change = 0.1
})
