local salt_variants = {}
for i = 1, 3 do
    salt_variants[i] = {
        filename = "__maraxsis__/graphics/icons/salt-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 2,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = "salt",
    icon = "__maraxsis__/graphics/icons/salt-2.png",
    pictures = salt_variants,
    icon_size = 64,
    stack_size = 200,
}}

data:extend {{
    type = "recipe",
    name = "salt",
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = "fluid", name = "brackish-water", amount = 300},
    },
    results = {
        {type = "item",  name = "salt",     amount = 3, quality_change = 1},
        {type = "fluid", name = "oxygen",   amount = 100},
        {type = "fluid", name = "hydrogen", amount = 200},
    },
    categories = {"maraxsis-hydro-plant", "electromagnetics", mods.Krastorio2 and "kr-electrolysis" or nil},
    icon = "__maraxsis__/graphics/icons/saline-electrolysis.png",
    icon_size = 64,
    auto_recycle = false,
    allow_productivity = true,
    main_product = "salt",
    localised_name = {"recipe-name.salt"},
}}