data:extend {{
    type = "fluid",
    name = "maraxsis-atmosphere",
    default_temperature = 0,
    max_temperature = 100,
    heat_capacity = "1kJ",
    base_flow_rate = data.raw.fluid.steam.base_flow_rate,
    base_color = {1, 1, 1},
    flow_color = {0.5, 0.5, 1},
    icon = "__maraxsis__/graphics/icons/atmosphere.png",
    icon_size = 64,
    gas_temperature = 25,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-atmosphere",
    category = "chemistry",
    energy_required = 10,
    ingredients = {},
    results = {
        {type = "fluid", name = "maraxsis-atmosphere", amount = 100, temperature = 25}
    },
    enabled = false,
    main_product = "maraxsis-atmosphere",
    surface_conditions = {{
        property = "pressure",
        min = 100,
        max = 4000,
    }}
}}
