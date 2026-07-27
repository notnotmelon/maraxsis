data:extend {{
    type = "technology",
    name = "maraxsis-piscary",
    icon = "__maraxsis__/graphics/technology/piscary.png",
    icon_size = 256,
    effects = {},
    prerequisites = {"maraxsis-glassworking", "maraxsis-hydro-plant"},
    research_trigger = {
        type = "craft-item",
        item = "maraxsis-pressure-dome"
    },
    order = "ed[piscary]",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-carbon",
    enabled = false,
    energy_required = 4,
    ingredients = {
        {type = "item", name = "maraxsis-tropical-fish", amount = 1},
    },
    results = {
        {type = "item", name = "carbon", amount = 8},
    },
    categories = {"organic", "smelting"},
    allow_productivity = true,
    main_product = "carbon",
    icon = "__maraxsis__/graphics/icons/burnt-fish.png",
    icon_size = 64,
    show_amount_in_title = false,
    auto_recycle = false,
    surface_conditions = maraxsis.surface_conditions(),
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-nutrients-from-tropical-fish",
    icon = "__maraxsis__/graphics/icons/nutrients-from-tropical-fish.png",
    icon_size = 64,
    enabled = false,
    energy_required = 2,
    ingredients = {
        {type = "item", name = "maraxsis-tropical-fish", amount = 1},
    },
    results = {
        {type = "item", name = "nutrients", amount = 6, quality_change = -1},
    },
    auto_recycle = false,
    allow_decomposition = false,
    allow_productivity = true,
    categories = {"organic"},
    subgroup = "nauvis-agriculture",
    order = "g[maraxsis]"
}}

local function add_to_tech(recipe)
    table.insert(data.raw.technology["maraxsis-piscary"].effects, {type = "unlock-recipe", recipe = recipe})
end

add_to_tech("maraxsis-carbon")
add_to_tech("maraxsis-fishing-tower")
add_to_tech("maraxsis-fish-food")
add_to_tech("maraxsis-shrinkflation")
add_to_tech("maraxsis-nutrients-from-tropical-fish")
add_to_tech("microplastics")
add_to_tech("maraxsis-smelt-microplastics")
