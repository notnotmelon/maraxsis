data:extend{{
    type = 'technology',
    name = 'h2o-torpedoes',
    icon = '__maraxsis__/graphics/technology/torpedoes.png',
    icon_size = 256,
    icon_mipmaps = nil,
    effects = {
        {
            type = 'unlock-recipe',
            recipe = 'h2o-torpedo'
        },
        {
            type = 'unlock-recipe',
            recipe = 'h2o-explosive-torpedo'
        }
    },
    prerequisites = {'h2o-maraxsis', 'explosive-rocketry'},
    unit = {
        count = 3000,
        ingredients = {
            {'automation-science-pack', 1},
            {'logistic-science-pack',   1},
            {'military-science-pack',   1},
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
    order = 'ea[wyrm-confinement]',
}}

data:extend{{
    type = 'ammo-category',
    name = 'h2o-torpedoes'
}}

local torpedo = table.deepcopy(data.raw['ammo']['rocket'])
torpedo.name = 'h2o-torpedo'
torpedo.icon = '__maraxsis__/graphics/icons/torpedo.png'
torpedo.icon_size = 64
torpedo.icon_mipmaps = nil
torpedo.ammo_type.category = 'h2o-torpedoes'
data:extend{torpedo}

local explosive_torpedo = table.deepcopy(data.raw['ammo']['explosive-rocket'])
explosive_torpedo.name = 'h2o-explosive-torpedo'
explosive_torpedo.icon = '__maraxsis__/graphics/icons/explosive-torpedo.png'
explosive_torpedo.icon_size = 64
explosive_torpedo.icon_mipmaps = nil
explosive_torpedo.ammo_type.category = 'h2o-torpedoes'
data:extend{explosive_torpedo}

local atomic_torpedo = table.deepcopy(data.raw['ammo']['atomic-bomb'])
atomic_torpedo.name = 'h2o-atomic-torpedo'
atomic_torpedo.icon = '__maraxsis__/graphics/icons/atomic-torpedo.png'
atomic_torpedo.icon_size = 64
atomic_torpedo.icon_mipmaps = nil
atomic_torpedo.ammo_type.category = 'h2o-torpedoes'
data:extend{atomic_torpedo}

data:extend{{
    type = 'recipe',
    name = 'h2o-torpedo',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'rocket', amount = 1},
        {type = 'item', name = 'rocket-fuel', amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-torpedo', amount = 1},
    },
    category = 'crafting'
}}

data:extend{{
    type = 'recipe',
    name = 'h2o-explosive-torpedo',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'explosive-rocket', amount = 1},
        {type = 'item', name = 'rocket-fuel', amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-explosive-torpedo', amount = 1},
    },
    category = 'crafting'
}}

data:extend{{
    type = 'recipe',
    name = 'h2o-atomic-torpedo',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'atomic-bomb', amount = 1},
        {type = 'item', name = 'h2o-heart-of-the-sea', amount = 1},
        {type = 'item', name = 'rocket-fuel', amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-atomic-torpedo', amount = 1},
    },
    category = 'h2o-hydro-plant'
}}