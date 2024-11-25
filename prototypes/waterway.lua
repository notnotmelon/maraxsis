do return end

local collision_mask_util = require "__core__/lualib/collision-mask-util"

data:extend {maraxsis.merge(data.raw["straight-rail"]["straight-rail"], {
    name = "maraxsis-straight-waterway",
    icon = data.raw.fluid.water.icon,
    localised_name = {"entity-name.maraxsis-waterway"},
    localised_description = {"entity-description.maraxsis-waterway"},
    icon_size = 64,
    collision_mask = {layers = {["water_tile"] = true, ["object"] = true}},
})}

data:extend {maraxsis.merge(data.raw["curved-rail"]["curved-rail"], {
    name = "maraxsis-curved-waterway",
    icon = data.raw.fluid.water.icon,
    localised_name = {"entity-name.maraxsis-waterway"},
    localised_description = {"entity-description.maraxsis-waterway"},
    icon_size = 64,
    collision_mask = {layers = {["water_tile"] = true, ["object"] = true}},
    placeable_by = {item = "maraxsis-waterway", count = data.raw["curved-rail"]["curved-rail"].placeable_by.count},
})}

data:extend {{
    type = "rail-planner",
    name = "maraxsis-waterway",
    straight_rail = "maraxsis-straight-waterway",
    place_result = "maraxsis-straight-waterway",
    curved_rail = "maraxsis-curved-waterway",
    stack_size = 100,
    localised_name = {"entity-name.maraxsis-waterway"},
    localised_description = {"entity-description.maraxsis-waterway"},
    icon = "__maraxsis__/graphics/icons/waterway.png", -- todo: make this icon
    icon = data.raw.fluid.water.icon,
    icon_size = 64,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-waterway",
    energy_required = 5,
    ingredients = {
        {type = "fluid", amount = 50, name = "saline-water"}
    },
    results = {
        {type = "item", amount = 1, name = "maraxsis-waterway"}
    },
    category = "crafting-with-fluid",
    enabled = false,
}}

table.insert(data.raw.technology["maraxsis"].effects, {
    type = "unlock-recipe",
    recipe = "maraxsis-waterway"
})
