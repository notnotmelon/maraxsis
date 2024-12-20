data:extend {{
    type = "recipe",
    name = "maraxsis-geothermal-sulfur",
    ingredients = {
        {type = "fluid", name = "steam", amount = 100},
        {type = "fluid", name = "lava",  amount = 100},
    },
    results = {
        {type = "item", name = "sulfur", amount = 2},
    },
    energy_required = 2,
    enabled = false,
    category = "maraxsis-hydro-plant",
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
    category = "maraxsis-hydro-plant-or-chemistry",
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
