do return end

local collision_mask_util = require "__core__/lualib/collision-mask-util"

data:extend {h2o.merge(data.raw["straight-rail"]["straight-rail"], {
    name = "h2o-straight-waterway",
    icon = data.raw.fluid.water.icon,
    localised_name = {"entity-name.h2o-waterway"},
    localised_description = {"entity-description.h2o-waterway"},
    icon_size = 64,
    collision_mask = {layers = {["water_tile"] = true, ["object"] = true}},
})}

data:extend {h2o.merge(data.raw["curved-rail"]["curved-rail"], {
    name = "h2o-curved-waterway",
    icon = data.raw.fluid.water.icon,
    localised_name = {"entity-name.h2o-waterway"},
    localised_description = {"entity-description.h2o-waterway"},
    icon_size = 64,
    collision_mask = {layers = {["water_tile"] = true, ["object"] = true}},
    placeable_by = {item = "h2o-waterway", count = data.raw["curved-rail"]["curved-rail"].placeable_by.count},
})}

data:extend {{
    type = "rail-planner",
    name = "h2o-waterway",
    straight_rail = "h2o-straight-waterway",
    place_result = "h2o-straight-waterway",
    curved_rail = "h2o-curved-waterway",
    stack_size = 100,
    localised_name = {"entity-name.h2o-waterway"},
    localised_description = {"entity-description.h2o-waterway"},
    icon = "__maraxsis__/graphics/icons/waterway.png", -- todo: make this icon
    icon = data.raw.fluid.water.icon,
    icon_size = 64,
}}

data:extend {{
    type = "recipe",
    name = "h2o-waterway",
    energy_required = 5,
    ingredients = {
        {type = "fluid", amount = 50, name = "saline-water"}
    },
    results = {
        {type = "item", amount = 1, name = "h2o-waterway"}
    },
    category = "crafting-with-fluid",
    enabled = false,
}}

table.insert(data.raw.technology["h2o-maraxsis"].effects, {
    type = "unlock-recipe",
    recipe = "h2o-waterway"
})
