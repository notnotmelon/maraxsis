data:extend{{
    type = 'technology',
    name = 'h2o-color-confinement',
    icon = '__dihydrogen-monoxide__/graphics/technology/color-confinement.png',
    icon_size = 256,
    icon_mipmaps = nil,
    effects = {},
    prerequisites = {'h2o-water-treatment'},
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