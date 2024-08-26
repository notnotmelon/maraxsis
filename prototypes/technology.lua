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
    prerequisites = {},
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

data:extend {{
    type = 'technology',
    name = 'h2o-nuclear-submarine',
    icon = '__dihydrogen-monoxide__/graphics/technology/nuclear-submarine.png',
    icon_size = 256,
    icon_mipmaps = nil,
    effects = {
        {
            type = 'unlock-recipe',
            recipe = 'h2o-nuclear-submarine',
        },
    },
    prerequisites = {'h2o-hydraulic-science-pack'},
    unit = {
        count = 3000,
        ingredients = {
            {'automation-science-pack', 1},
            {'logistic-science-pack',   1},
            {'chemical-science-pack',   1},
            {'military-science-pack',   1},
            {'production-science-pack', 1},
            {'utility-science-pack',    1},
            --{'metallurgic-science-pack', 1},
            --{'electromagnetic-science-pack', 1},
            --{'agricultural-science-pack', 1},
            {'h2o-hydraulic-science-pack', 1},
        },
        time = 60,
    },
    order = 'a',
}}