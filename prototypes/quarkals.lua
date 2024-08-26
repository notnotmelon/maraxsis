data:extend {{
    type = 'technology',
    name = 'h2o-color-confinement',
    icon = '__dihydrogen-monoxide__/graphics/technology/color-confinement.png',
    icon_size = 256,
    icon_mipmaps = nil,
    effects = {
        {
            type = 'unlock-recipe',
            recipe = 'h2o-quantum-computer'
        },
        {
            type = 'unlock-recipe',
            recipe = 'h2o-heart-of-the-sea'
        }
    },
    prerequisites = {'h2o-piscary'},
    unit = {
        count = 3000,
        ingredients = {
            {'automation-science-pack', 1},
            {'logistic-science-pack',   1},
            {'chemical-science-pack',   1},
            {'space-science-pack',      1},
            {'production-science-pack', 1},
            {'utility-science-pack',    1},
            --{'metallurgic-science-pack', 1},
            --{'electromagnetic-science-pack', 1},
            --{'agricultural-science-pack', 1},
        },
        time = 60,
    },
    order = 'ef[color-confinement]',
}}

local heart_of_the_sea_variants = {}
for i = 1, 3 do
    heart_of_the_sea_variants[i] = {
        layers = {
            {
                filename = '__dihydrogen-monoxide__/graphics/icons/heart-of-the-sea-' .. i .. '.png',
                width = 128,
                height = 128,
                scale = 0.15,
                mipmap_count = 6,
                flags = {'icon'}
            },
            {
                filename = '__dihydrogen-monoxide__/graphics/icons/heart-of-the-sea-' .. i .. '.png',
                width = 128,
                height = 128,
                scale = 0.15,
                mipmap_count = 6,
                flags = {'icon'},
                draw_as_glow = true
            }
        }
    }
end

data:extend {{
    type = 'item',
    name = 'h2o-heart-of-the-sea',
    icon = '__dihydrogen-monoxide__/graphics/icons/heart-of-the-sea.png',
    pictures = heart_of_the_sea_variants,
    icon_size = 64,
    icon_mipmaps = nil,
    subgroup = 'h2o-maraxsis',
    order = 'vga',
    stack_size = 10,
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-heart-of-the-sea',
    category = 'h2o-quantum-computer',
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'h2o-up-coral',      amount = 1},
        {type = 'item', name = 'h2o-down-coral',    amount = 1},
        {type = 'item', name = 'h2o-top-coral',     amount = 1},
        {type = 'item', name = 'h2o-bottom-coral',  amount = 1},
        {type = 'item', name = 'h2o-strange-coral', amount = 1},
        {type = 'item', name = 'h2o-charm-coral',   amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-heart-of-the-sea', amount = 1},
        {type = 'item', name = 'h2o-up-coral',         amount = 1},
        {type = 'item', name = 'h2o-down-coral',       amount = 1},
        {type = 'item', name = 'limestone',            amount = 1},
    },
    enabled = false,
    order = 'a',
    main_product = 'h2o-heart-of-the-sea',
}}

data:extend {{
    type = 'item-subgroup',
    name = 'h2o-quarkals',
    group = 'intermediate-products',
    order = 'z',
}}

local types = {'up', 'down', 'strange', 'charm', 'top', 'bottom'}
local inventory_icon_indexes = {1, 3, 1, 3, 2, 3}

for j, type in ipairs(types) do
    local quarkal_variants = {}
    for i = 1, 3 do
        quarkal_variants[i] = {
            layers = {
                {
                    filename = '__dihydrogen-monoxide__/graphics/icons/quarkal/' .. type .. '-coral-' .. i .. '.png',
                    width = 64,
                    height = 64,
                    scale = 0.33,
                    mipmap_count = nil,
                    flags = {'icon'}
                },
                {
                    filename = '__dihydrogen-monoxide__/graphics/icons/quarkal/' .. type .. '-coral-' .. i .. '.png',
                    width = 64,
                    height = 64,
                    scale = 0.33,
                    mipmap_count = nil,
                    flags = {'icon'},
                    draw_as_glow = true
                }
            }
        }
    end
    data:extend {{
        type = 'item',
        name = 'h2o-' .. type .. '-coral',
        icon = '__dihydrogen-monoxide__/graphics/icons/quarkal/' .. type .. '-coral-' .. inventory_icon_indexes[j] .. '.png',
        icon_size = 64,
        icon_mipmaps = nil,
        pictures = quarkal_variants,
        subgroup = 'h2o-quarkals',
        order = 'a[' .. type .. ']',
        stack_size = 100,
        --spoil_result = 'limestone',
        --spoil_duration = 60 * 60 * 5,
    }}

    -- temp recipe to mimic spoilage
    data:extend {{
        type = 'recipe',
        name = 'h2o-' .. type .. '-coral-spoil',
        category = 'h2o-hydro-plant',
        energy_required = 1,
        ingredients = {
            {type = 'item', name = 'h2o-' .. type .. '-coral', amount = 1},
        },
        results = {
            {type = 'item', name = 'limestone', amount = 1},
        },
        main_product = 'limestone',
        enabled = true,
        order = 'a',
        localised_description = 'This is a temporary recipe to mimic spoilage. TODO: remove'
    }}
end
