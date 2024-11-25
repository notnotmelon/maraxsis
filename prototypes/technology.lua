data:extend {{
    type = "technology",
    name = "h2o-maraxsis",
    icons = util.technology_icon_constant_planet("__maraxsis__/graphics/technology/maraxsis.png"),
    icon_size = 256,
    essential = true,
    localised_name = {"space-location-name.maraxsis"},
    localised_description = {"space-location-description.maraxsis"},
    effects = {
        {
            type = "unlock-space-location",
            space_location = "maraxsis",
            use_icon_overlay_constant = true
        },
        {
            type = "unlock-recipe",
            recipe = "h2o-hydro-plant",
        },
        {
            type = "unlock-recipe",
            recipe = "h2o-diesel-submarine",
        },
    },
    prerequisites = {
        "advanced-asteroid-processing"
    },
    unit = {
        count = 3000,
        ingredients = {
            {"automation-science-pack",      1},
            {"logistic-science-pack",        1},
            {"chemical-science-pack",        1},
            {"space-science-pack",           1},
            {"production-science-pack",      1},
            {"utility-science-pack",         1},
            {"metallurgic-science-pack",     1},
            {"electromagnetic-science-pack", 1},
            {"agricultural-science-pack",    1},
        },
        time = 60,
    },
    order = "ea[maraxsis]",
}}
