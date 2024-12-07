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
