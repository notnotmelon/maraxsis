data:extend {{
    type = "recipe",
    name = "maraxsis-hydrolox-rocket-fuel",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "fluid", name = "oxygen",   amount = 200},
        {type = "fluid", name = "hydrogen", amount = 200},
    },
    results = {
        {type = "item", name = "rocket-fuel", amount = 1},
    },
    icon = "__maraxsis__/graphics/icons/hydrolox-rocket-fuel.png",
    icon_size = 64,
    allow_productivity = true,
    categories = {"maraxsis-hydro-plant"},
    main_product = "rocket-fuel",
    auto_recycle = false,
}}