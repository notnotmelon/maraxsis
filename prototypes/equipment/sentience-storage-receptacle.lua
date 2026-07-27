data:extend {{
    type = "item",
    name = "maraxsis-sentience-storage-receptacle",
    icon = "__maraxsis__/graphics/equipment/sentience-storage-receptacle.png",
    icon_size = 256,
    stack_size = 5,
    place_as_equipment_result = "maraxsis-sentience-storage-receptacle",
    subgroup = "equipment",
    order = "q-b[maraxsis-sentience-storage-receptacle]",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-sentience-storage-receptacle",
    enabled = false,
    energy_required = 10,
    categories = {"maraxsis-hydro-plant"},
    ingredients = {
        {type = "item", name = "low-density-structure", amount = 10},
        {type = "item", name = "quantum-processor",     amount = 20},
        {type = "item", name = "maraxsis-tropical-fish",              amount = 1, quality_min = "legendary", quality_max = "legendary"},
    },
    auto_recycle = false,
    results = {
        {type = "item", name = "maraxsis-sentience-storage-receptacle", amount = 1, quality_change = 1},
    },
}}

data:extend {{
    name = "maraxsis-sentience-storage-receptacle",
    type = "movement-bonus-equipment",
    categories = {"maraxsis-armor-category"},
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        input_flow_limit = "500kW",
        buffer_capacity = "10kJ",
        drain = "400kW"
    },
    energy_consumption = "1W",
    movement_bonus = 0,
    sprite = {
        filename = "__maraxsis__/graphics/equipment/sentience-storage-receptacle.png",
        width = 256,
        height = 256,
        priority = "medium"
    },
    take_result = "maraxsis-sentience-storage-receptacle",
    shape = {
        width = 2,
        height = 2,
        type = "full"
    },
}}