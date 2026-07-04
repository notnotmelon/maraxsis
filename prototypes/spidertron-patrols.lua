local submarine_automation = data.raw["technology"]["sp-spidertron-automation"]

submarine_automation.icon = "__maraxsis__/graphics/technology/submarine-automation.png"

if settings.startup["sp-enable-spiderling"].value then return end -- https://github.com/notnotmelon/maraxsis/issues/212

submarine_automation.unit = nil
submarine_automation.research_trigger = {
    type = "build-entity",
    entity = "maraxsis-diesel-submarine"
}
submarine_automation.order = "eb[submarine-automation]"
submarine_automation.prerequisites = {"planet-discovery-maraxsis"}

if not mods.pystellarexpedition then
    table.insert(data.raw.recipe["sp-spidertron-dock"].caregories,"maraxsis-hydro-plant")
end
data.raw.recipe["sp-spidertron-dock"].ingredients = {
    {type = "item", name = "tungsten-plate", amount = 16},
    {type = "item", name = "bulk-inserter",  amount = 4},
}
