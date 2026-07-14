data:extend {{
    name = "maraxsis-abyssal-diving-gear",
    type = "technology",
    icons = util.technology_icon_constant_equipment("__maraxsis__/graphics/technology/abyssal-diving-gear.png"),
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-abyssal-diving-gear"
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-sentience-storage-receptacle"
        },
    },
    prerequisites = {"maraxsis-nuclear-submarine", "quantum-processor"},
    order = "ex[hydro-plant]",
    unit = {
        count = 5000,
        ingredients = {
            {"automation-science-pack",      1},
            {"logistic-science-pack",        1},
            {"military-science-pack",        1},
            {"chemical-science-pack",        1},
            {"space-science-pack",           1},
            {"production-science-pack",      1},
            {"utility-science-pack",         1},
            {"metallurgic-science-pack",     1},
            {"electromagnetic-science-pack", 1},
            {"agricultural-science-pack",    1},
            {"hydraulic-science-pack",       1},
            {"cryogenic-science-pack",       1},
        },
        time = 60,
    },
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-abyssal-diving-gear",
    enabled = false,
    energy_required = 10,
    categories = {"maraxsis-hydro-plant"},
    ingredients = {
        {type = "item", name = "low-density-structure",                 amount = 10},
        {type = "item", name = "pipe-to-ground",                        amount = 2},
        {type = "item", name = "maraxsis-sentience-storage-receptacle", amount = 1},
        {type = "item", name = "pump",                                  amount = 1},
        {type = "item", name = "maraxsis-glass-panes",                  amount = 50},
        {type = "item", name = "maraxsis-super-sealant-substance",      amount = 50},
    },
    auto_recycle = true,
    results = {
        {type = "item", name = "maraxsis-abyssal-diving-gear", amount = 1},
    },
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
    type = "item",
    name = "maraxsis-abyssal-diving-gear",
    icon = "__maraxsis__/graphics/icons/abyssal-diving-gear.png",
    icon_size = 64,
    stack_size = 5,
    place_as_equipment_result = "maraxsis-abyssal-diving-gear",
    subgroup = "equipment",
    order = "q-a[maraxsis-abyssal-diving-gear]",
}}

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
    type = "equipment-category",
    name = "maraxsis-armor-category",
}}

data:extend {{
    name = "maraxsis-abyssal-diving-gear",
    type = "movement-bonus-equipment",
    categories = {"maraxsis-armor-category"},
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        input_flow_limit = "500kW",
        drain = "400kW"
    },
    energy_consumption = "1W",
    movement_bonus = 0.35,
    sprite = {
        filename = "__maraxsis__/graphics/equipment/abyssal-diving-gear.png",
        width = 256,
        height = 256,
        priority = "medium"
    },
    take_result = "maraxsis-abyssal-diving-gear",
    shape = {
        width = 2,
        height = 2,
        type = "full"
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

local disabled = table.deepcopy(data.raw["movement-bonus-equipment"]["maraxsis-abyssal-diving-gear"])
disabled.name = "maraxsis-abyssal-diving-gear-disabled"
disabled.movement_bonus = 0
disabled.energy_consumption = "1W"
disabled.localised_name = {"equipment-name.maraxsis-abyssal-diving-gear"}
disabled.localised_description = {"", {"equipment-description.maraxsis-abyssal-diving-gear"}, "\n", {"equipment-description.maraxsis-abyssal-diving-gear-disabled"}}
data:extend {disabled}
