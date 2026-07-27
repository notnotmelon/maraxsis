local super_sealant_substance_variants = {}
for i = 1, 3 do
    super_sealant_substance_variants[i] = {
        filename = "__maraxsis__/graphics/icons/super-sealant-substance-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 2,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = "maraxsis-super-sealant-substance",
    icon = "__maraxsis__/graphics/icons/super-sealant-substance-1.png",
    icon_size = 64,
    stack_size = data.raw.item["rocket-fuel"].stack_size,
    weight = data.raw.item["rocket-fuel"].weight,
    pictures = super_sealant_substance_variants,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-super-sealant-substance",
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = "item",  name = "maraxsis-fish-oil", amount = 1},
        {type = "item",  name = "sulfur", amount = 3},
        {type = "fluid", name = "heavy-oil", amount = 200},
        {type = "fluid", name = "hydrogen", amount = 100},
    },
    results = {
        {type = "item", name = "maraxsis-super-sealant-substance", amount = 1},
    },
    categories = {"chemistry", "cryogenics"},
    allow_productivity = true,
    auto_recycle = false,
    sort_item_ingredients = false
}}
