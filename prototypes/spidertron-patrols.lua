local submarine_automation = data.raw["technology"]["sp-spidertron-automation"]

submarine_automation.icon = "__maraxsis__/graphics/technology/submarine-automation.png"
submarine_automation.unit = nil
submarine_automation.research_trigger = {
    type = "build-entity",
    entity = "maraxsis-diesel-submarine"
}
submarine_automation.order = "eb[submarine-automation]"
submarine_automation.prerequisites = {"planet-discovery-maraxsis"}

data.raw.recipe["sp-spidertron-dock"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["sp-spidertron-dock"].ingredients = {
    {type = "item", name = "tungsten-plate", amount = 16},
    {type = "item", name = "bulk-inserter",  amount = 4},
}
