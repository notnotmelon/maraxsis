data:extend {{
    type = 'technology',
    name = 'h2o-big-cliff-explosives',
    icon = '__dihydrogen-monoxide__/graphics/technology/big-cliff-explosives.png',
    icon_size = 256,
    icon_mipmaps = nil,
    effects = {
        {
            type = 'unlock-recipe',
            recipe = 'h2o-big-cliff-explosives'
        }
    },
    prerequisites = {'cliff-explosives', 'h2o-hydraulic-science-pack', 'atomic-bomb'},
    unit = {
        count = 3000,
        ingredients = {
            {'automation-science-pack',    1},
            {'logistic-science-pack',      1},
            {'military-science-pack',      1},
            {'chemical-science-pack',      1},
            {'space-science-pack',      1},
            {'production-science-pack',    1},
            {'utility-science-pack',       1},
            --{'metallurgic-science-pack', 1},
            --{'electromagnetic-science-pack', 1},
            --{'agricultural-science-pack', 1},
            {'h2o-hydraulic-science-pack', 1},
        },
        time = 60,
    },
    order = 'eh[big-cliff-explosives]',
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-big-cliff-explosives',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'cliff-explosives',     amount = 1},
        {type = 'item', name = 'h2o-heart-of-the-sea', amount = 1},
        {type = 'item', name = 'atomic-bomb',          amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-big-cliff-explosives', amount = 1},
    },
    category = 'chemistry',
}}

data:extend {{
    type = 'capsule',
    name = 'h2o-big-cliff-explosives',
    icon = '__dihydrogen-monoxide__/graphics/icons/big-cliff-explosives.png',
    icon_size = 64,
    icon_mipmaps = nil,
    subgroup = data.raw.capsule['cliff-explosives'].subgroup,
    order = data.raw.capsule['cliff-explosives'].order .. 'z',
    stack_size = 10,
    capsule_action = {
        type = 'destroy-cliffs',
        radius = 100,
        attack_parameters = {
            type = 'projectile',
            activation_type = 'throw',
            ammo_category = 'grenade',
            cooldown = 30,
            projectile_creation_distance = 0.6,
            range = 30,
            ammo_type = {
                category = 'grenade',
                target_type = 'position',
                action = {
                    type = 'direct',
                    action_delivery = {
                        type = 'projectile',
                        projectile = 'cliff-explosives',
                        starting_speed = 0.3
                    }
                }
            }
        }
    },
}}
