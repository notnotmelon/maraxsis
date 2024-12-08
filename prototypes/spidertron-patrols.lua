local submarine_automation = data.raw["technology"]["sp-spidertron-automation"]

submarine_automation.icon = "__maraxsis__/graphics/technology/submarine-automation.png"
submarine_automation.unit = nil
submarine_automation.research_trigger = {
    type = "build-entity",
    entity = "maraxsis-diesel-submarine"
}
submarine_automation.order = "eb[submarine-automation]"
submarine_automation.prerequisites = {"planet-discovery-maraxsis"}

table.insert(submarine_automation.effects, {
    type = "unlock-recipe",
    recipe = "constructron",
})

data.raw.recipe["sp-spidertron-dock"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["sp-spidertron-dock"].ingredients = {
    {type = "item", name = "tungsten-plate", amount = 16},
    {type = "item", name = "bulk-inserter",  amount = 4},
}

local function add_surface_conditions_to_submarine_dock(dock_name)
    local dock = data.raw.container[dock_name]
    if not dock then return end
    dock.surface_conditions = maraxsis.surface_conditions()
end

for i = 1, 200 do
    add_surface_conditions_to_submarine_dock("sp-spidertron-dock-" .. i)
end
add_surface_conditions_to_submarine_dock("sp-spidertron-dock")
add_surface_conditions_to_submarine_dock("sp-spidertron-dock-closing")
