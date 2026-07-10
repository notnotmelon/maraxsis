data:extend {{
    type = "recipe",
    name = "maraxsis-geothermal-sulfur",
    ingredients = {
        {type = "fluid", name = "maraxsis-supercritical-steam", amount = 100},
        {type = "fluid", name = "lava",  amount = 100},
    },
    results = {
        {type = "item", name = "sulfur", amount = 2},
    },
    energy_required = 3,
    enabled = false,
    categories = {"maraxsis-geothermal-generator"},
    surface_conditions = {{
        property = "pressure",
        min = 400000,
        max = 400000,
    }},
    icon = "__maraxsis__/graphics/icons/geothermal-sulfur.png",
    icon_size = 64,
    allow_productivity = true,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-petroleum-gas-cracking",
    ingredients = {
        {type = "fluid", name = "petroleum-gas", amount = 40},
        {type = "fluid", name = "water",         amount = 30},
    },
    results = {
        {type = "fluid", name = "heavy-oil", amount = 10},
    },
    allow_productivity = true,
    categories = {"maraxsis-hydro-plant"},
    energy_required = 2,
    subgroup = "fluid-recipes",
    order = "b[fluid-chemistry]-c[petroleum-gas-cracking]",
    enabled = false,
    icon = "__maraxsis__/graphics/icons/petroleum-gas-cracking.png",
    icon_size = 64,
    auto_recycle = false,
    allow_decomposition = false,
    maximum_productivity = 1.5,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-bio-oil",
    categories = {"organic"},
    ingredients = {
        {type = "fluid", name = "lubricant", amount = 30},
        {type = "fluid", name = "steam", amount = 100},
        {type = "item", name = "maraxsis-fish-oil", amount = 1},
    },
    results = {
        {type = "fluid", name = "light-oil", amount = 200},
    },
    main_product = "light-oil",
    allow_productivity = true,
    energy_required = 5,
    enabled = false,
    icon = "__maraxsis__/graphics/icons/bio-oil.png"
}}

data:extend { {
    type = "recipe",
    name = "maraxsis-holmium-recrystalization",
    categories = { "maraxsis-hydro-plant" },
    ingredients = {
        { type = "fluid", name = "holmium-solution", amount = 50 },
        { type = "item",  name = "holmium-ore",      amount = 1 },
    },
    results = {
        { type = "item", name = "holmium-plate", amount = 5 },
    },
    energy_required = data.raw.recipe["holmium-plate"].energy_required * 5,
    caregories = { "maraxsis-hydro-plant" },
    enabled = false,
    auto_recycle = false,
    icons = {
        {
            icon = "__space-age__/graphics/icons/holmium-plate.png",
            icon_size = 64,
        },
        {
            icon = "__space-age__/graphics/icons/fluid/holmium-solution.png",
            icon_size = 64,
            size = 0.5,
            shift = { -8, -8 }
        },
    }
} }

table.insert(data.raw.technology["holmium-processing"].effects, {
    type = "unlock-recipe",
    recipe = "maraxsis-holmium-recrystalization"
})
