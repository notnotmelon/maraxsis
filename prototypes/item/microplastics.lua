local microplastics_variants = {}
for i = 1, 3 do
    microplastics_variants[i] = {
        filename = "__maraxsis__/graphics/icons/microplastics-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 2,
        flags = {"icon"},
    }
end

data:extend {{
    type = "item",
    name = "microplastics",
    icon = "__maraxsis__/graphics/icons/microplastics-1.png",
    icon_size = 64,
    pictures = microplastics_variants,
    stack_size = data.raw.item["plastic-bar"].stack_size / 2,
}}

data:extend {{
    type = "recipe",
    name = "microplastics",
    icon = "__maraxsis__/graphics/icons/fish-rendering.png",
    icon_size = 64,
    enabled = false,
    energy_required = 2,
    ingredients = {
        {type = "item", name = "maraxsis-tropical-fish",   amount = 1},
        {type = "item", name = "piercing-rounds-magazine", amount = 1},
    },
    results = {
        {type = "item", name = "microplastics", amount = 10},
        {type = "item", name = "jelly",                  amount = 10},
    },
    categories = {"organic", "crafting"},
    localised_name = {"recipe-name.microplastics"},
    main_product = "microplastics",
    allow_productivity = true,
    auto_recycle = false,
    always_show_made_in = true,
    surface_conditions = maraxsis.surface_conditions(),
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-smelt-microplastics",
    icon = "__maraxsis__/graphics/icons/microplastics-to-plastic.png",
    icon_size = 64,
    enabled = false,
    energy_required = data.raw.recipe["iron-plate"].energy_required,
    ingredients = {
        {type = "item", name = "microplastics", amount = 2},
    },
    results = {
        {type = "item", name = "plastic-bar", amount = 1},
    },
    categories = {"smelting"},
    allow_productivity = true,
    main_product = "plastic-bar",
    emissions_multiplier = 3,
    auto_recycle = false,
}}