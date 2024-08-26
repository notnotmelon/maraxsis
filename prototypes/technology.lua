data:extend {{
    type = 'technology',
    name = 'h2o-maraxsis',
    icon = '__dihydrogen-monoxide__/graphics/technology/maraxsis.png',
    icon_size = 256,
    icon_mipmaps = nil,
    effects = {
        {
            type = 'unlock-recipe',
            recipe = 'h2o-hydro-plant',
        },
        {
            type = 'unlock-recipe',
            recipe = 'h2o-diesel-submarine',
        },
    },
    prerequisites = {
        'rocket-silo'
    },
    unit = {
        count = 3000,
        ingredients = {
            {'automation-science-pack',    1},
            {'logistic-science-pack',      1},
            {'chemical-science-pack',      1},
            {'space-science-pack',         1},
            {'production-science-pack',    1},
            {'utility-science-pack',       1},
            --{'metallurgic-science-pack', 1},
            --{'electromagnetic-science-pack', 1},
            --{'agricultural-science-pack', 1},
        },
        time = 60,
    },
    order = 'ea[maraxsis]',
}}