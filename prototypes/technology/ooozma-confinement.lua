data:extend {{
    type = "technology",
    name = "maraxsis-ooozma-confinement",
    icon = "__maraxsis__/graphics/technology/ooozma-confinement.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-ooozma-confinement-cell",
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-ooozma-specimen",
        }
    },
    prerequisites = {"maraxsis-piscary", "ducts", "maraxsis-geothermal-energy"},
    research_trigger = {
        type = "scripted",
        trigger_description = {"technology-trigger.survive-estrogen"},
        icon = "__maraxsis__/graphics/icons/estrogen.png",
        icon_size = 64
    },
    order = "ee[ooozma-confinement]",
}}

data:extend {{
    type = "item",
    name = "maraxsis-ooozma-confinement-cell",
    icon = "__maraxsis__/graphics/icons/ooozma-confinement-cell.png",
    icon_size = 64,
    stack_size = 10,
}}

local ooozma_variants = {}
for i = 1, 3 do
    ooozma_variants[i] = {
        filename = "__maraxsis__/graphics/icons/ooozma-specimen-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 2,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = "maraxsis-ooozma-specimen",
    icon = "__maraxsis__/graphics/icons/ooozma-specimen-2.png",
    pictures = ooozma_variants,
    icon_size = 64,
    stack_size = 10,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-ooozma-confinement-cell",
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = "item", name = "maraxsis-glass-panes", amount = 5},
        {type = "item", name = "steel-plate",          amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-ooozma-confinement-cell", amount = 1},
    },
    auto_recycle = true,
    allow_productivity = true
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-ooozma-specimen",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "item", name = "maraxsis-ooozma-confinement-cell", amount = 1},
        {type = "item", name = "maraxsis-fish-food",             amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-ooozma-specimen", amount = 1},
    },
    auto_recycle = false,
    categories = {"maraxsis-hydro-plant"},
    surface_conditions = maraxsis.trench_surface_conditions(),
    allow_productivity = true
}}
