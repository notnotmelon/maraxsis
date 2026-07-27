local limestone_variants = {}
for i = 1, 3 do
    limestone_variants[i] = {
        filename = "__maraxsis__/graphics/icons/limestone-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 2,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = "limestone",
    icon = "__maraxsis__/graphics/icons/limestone-1.png",
    icon_size = 64,
    pictures = limestone_variants,
    stack_size = 200,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-limestone-crushing",
    enabled = false,
    energy_required = 20,
    ingredients = {
        {type = "item", name = "limestone", amount = 1},
    },
    results = {
        {type = "item", name = "calcite", amount = 1, quality_change = 1, shared_probability = {min = 0/3, max = 1/3}},
        {type = "item", name = "calcite", amount = 1, quality_change = 2, shared_probability = {min = 1/3, max = 2/3}},
        {type = "item", name = "calcite", amount = 1, quality_change = 3, shared_probability = {min = 2/3, max = 3/3}},
    },
    icons = PlanetsLib.crushing_recipe_icons("__maraxsis__/graphics/icons/limestone-2.png", 64),
    allow_productivity = true,
    categories = {"crushing"},
    allow_decomposition = false,
    main_product = "calcite",
    auto_recycle = false,
    subgroup = "space-crushing",
    order = "i[limestone-processing]"
}}