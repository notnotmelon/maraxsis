data:extend {{
    type = 'technology',
    name = 'h2o-wyrm-confinement',
    icon = '__dihydrogen-monoxide__/graphics/technology/wyrm-confinement.png',
    icon_size = 256,
    icon_mipmaps = nil,
    effects = {
        {
            type = 'unlock-recipe',
            recipe = 'h2o-wyrm-confinement-cell',
        },
        {
            type = 'unlock-recipe',
            recipe = 'h2o-wyrm-specimen',
        },
    },
    prerequisites = {'h2o-glassworking'},
    unit = {
        count = 500,
        ingredients = {
            {'automation-science-pack', 1},
            {'logistic-science-pack',   1},
            {'chemical-science-pack',   1},
            {'military-science-pack',   1},
            {'production-science-pack', 1},
        },
        time = 60,
    },
    order = 'a',
}}

data:extend {{
    type = 'item',
    name = 'h2o-wyrm-confinement-cell',
    icon = '__dihydrogen-monoxide__/graphics/icons/wyrm-confinement-cell.png',
    icon_size = 64,
    icon_mipmaps = nil,
    subgroup = 'h2o-maraxsis',
    order = 'vga',
    stack_size = 10,
}}

local wyrm_variants = {}
for i = 1, 4 do
    wyrm_variants[i] = {
        filename = '__dihydrogen-monoxide__/graphics/icons/wyrm-specimen-' .. i .. '.png',
        width = 64,
        height = 64,
        scale = 1 / 3,
        flags = {'icon'}
    }
end

data:extend{{
    type = 'item',
    name = 'h2o-wyrm-specimen',
    icon = '__dihydrogen-monoxide__/graphics/icons/wyrm-specimen-2.png',
    pictures = wyrm_variants,
    icon_size = 64,
    icon_mipmaps = nil,
    subgroup = 'h2o-maraxsis',
    order = 'vga',
    stack_size = 10,
}}

data:extend{{
    type = 'recipe',
    name = 'h2o-wyrm-confinement-cell',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'h2o-glass-panes', amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-wyrm-confinement-cell', amount = 1},
    },
}}

data:extend{{
    type = 'recipe',
    name = 'h2o-wyrm-specimen',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'h2o-wyrm-confinement-cell', amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-wyrm-specimen', amount = 1},
    },
}}