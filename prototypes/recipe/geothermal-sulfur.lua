data:extend {{
    type = "recipe",
    name = "maraxsis-geothermal-sulfur",
    ingredients = {
        {type = "fluid", name = "maraxsis-supercritical-steam", amount = 100},
        {type = "fluid", name = "brackish-water",  amount = 100},
    },
    results = {
        {type = "item", name = "sulfur", amount = 2},
    },
    energy_required = 3,
    enabled = false,
    categories = {"maraxsis-geothermal-generator"},
    icon = "__maraxsis__/graphics/icons/geothermal-sulfur.png",
    icon_size = 64,
    allow_productivity = true,
}}
