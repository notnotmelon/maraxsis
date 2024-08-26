data:extend{{
    type = 'technology',
    name = 'h2o-glassworking',
    icon = '__dihydrogen-monoxide__/graphics/technology/glassworking.png',
    icon_size = 256,
    icon_mipmaps = nil,
    effects = {
        {
            type = 'unlock-recipe',
            recipe = 'h2o-glass-panes',
        },
    },
    prerequisites = {'h2o-maraxsis'},
    unit = {
        count = 500,
        ingredients = {
            {'automation-science-pack', 1},
            {'logistic-science-pack',   1},
            {'chemical-science-pack',   1},
            {'production-science-pack', 1},
        },
        time = 30,
    },
    order = 'a',
}}

local limestone_variants = {}
for i = 1, 3 do
    limestone_variants[i] = {
        filename = '__dihydrogen-monoxide__/graphics/icons/limestone-' .. i .. '.png',
        width = 64,
        height = 64,
        scale = 1 / 3,
        flags = {'icon'}
    }
end

data:extend {{
    type = 'item',
    name = 'limestone',
    icon = '__dihydrogen-monoxide__/graphics/icons/limestone-1.png',
    icon_size = 64,
    icon_mipmaps = nil,
    pictures = limestone_variants,
    subgroup = 'h2o-maraxsis',
    order = 'vga',
    stack_size = 200,
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-glass-panes',
    enabled = false,
    energy_required = 5,
    ingredients = {
        {type = 'item', name = 'sand', amount = 3},
        {type = 'item', name = 'limestone', amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-glass-panes', amount = 1},
    },
    category = 'h2o-hydro-plant'
}}

local glass_variants = {}
for i = 1, 9 do
    glass_variants[i] = {
        filename = '__dihydrogen-monoxide__/graphics/icons/glass-panes-' .. i .. '.png',
        width = 64,
        height = 64,
        scale = 1 / 3,
        flags = {'icon'}
    }
end

data:extend{{
    type = 'item',
    name = 'h2o-glass-panes',
    icon = '__dihydrogen-monoxide__/graphics/icons/glass-panes-1.png',
    pictures = glass_variants,
    icon_size = 64,
    icon_mipmaps = nil,
    subgroup = 'h2o-maraxsis',
    order = 'vga',
    stack_size = 200,
}}

local sand_variants = {}
for i = 1, 3 do
    sand_variants[i] = {
        filename = '__dihydrogen-monoxide__/graphics/icons/sand-' .. i .. '.png',
        width = 64,
        height = 64,
        scale = 1 / 3,
        flags = {'icon'}
    }
end

data:extend{{
    type = 'item',
    name = 'sand',
    icon = '__dihydrogen-monoxide__/graphics/icons/sand-3.png',
    pictures = sand_variants,
    icon_size = 64,
    icon_mipmaps = nil,
    subgroup = 'h2o-maraxsis',
    order = 'vga',
    stack_size = 100,
}}