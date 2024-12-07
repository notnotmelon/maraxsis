data:extend {{
    icons = {
        {
            icon = "__Constructron-Continued__/graphics/icon_texture.png",
            icon_size = 256,
            scale = 0.12
        },
        {
            icon = "__maraxsis__/graphics/icons/diesel-submarine.png",
            icon_size = 64,
            scale = 0.45
        }
    },
    name = "constructron",
    place_result = "constructron",
    stack_size = 1,
    subgroup = "transport",
    flags = {"not-stackable"},
    type = "item-with-entity-data"
}}

data:extend {{
    type = "recipe",
    name = "constructron",
    enabled = false,
    ingredients = {
        {type = "item", name = "maraxsis-diesel-submarine", amount = 1}
    },
    results = {
        {type = "item", name = "constructron", amount = 1}
    },
    energy = 1,
    category = "maraxsis-hydro-plant-or-assembling"
}}

local construction_submarine = table.deepcopy(data.raw["spider-vehicle"]["maraxsis-diesel-submarine"])
construction_submarine.name = "constructron"
construction_submarine.icon = nil
construction_submarine.icon_size = nil
construction_submarine.minable = {mining_time = 0.5, result = "constructron"}
construction_submarine.icons = table.deepcopy(data.raw["item-with-entity-data"]["constructron"].icons)
data:extend {construction_submarine}
