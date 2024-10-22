data:extend {{
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
            {'metallurgic-science-pack', 1},
            {'electromagnetic-science-pack', 1},
            {'agricultural-science-pack', 1},
        },
        time = 60,
    },
    order = 'ea[wyrm-confinement]',
}}

data:extend {{
    type = 'ammo-category',
    name = 'h2o-torpedoes'
}}

local torpedo = table.deepcopy(data.raw['ammo']['rocket'])
torpedo.order = 'de[torpedoes]-a[torpedo]'
torpedo.name = 'h2o-torpedo'
torpedo.icon = '__maraxsis__/graphics/icons/torpedo.png'
torpedo.icon_size = 64
torpedo.icon_mipmaps = nil
torpedo.ammo_type.category = 'h2o-torpedoes'
torpedo.ammo_type.action.action_delivery.projectile = 'h2o-torpedo-projectile'
data:extend {torpedo}

local explosive_torpedo = table.deepcopy(data.raw['ammo']['explosive-rocket'])
explosive_torpedo.order = 'de[torpedoes]-b[explosive-torpedo]'
explosive_torpedo.name = 'h2o-explosive-torpedo'
explosive_torpedo.icon = '__maraxsis__/graphics/icons/explosive-torpedo.png'
explosive_torpedo.icon_size = 64
explosive_torpedo.icon_mipmaps = nil
explosive_torpedo.ammo_type.category = 'h2o-torpedoes'
explosive_torpedo.ammo_type.action.action_delivery.projectile = 'h2o-explosive-torpedo-projectile'
data:extend {explosive_torpedo}

local atomic_torpedo = table.deepcopy(data.raw['ammo']['atomic-bomb'])
atomic_torpedo.order = 'de[torpedoes]-c[atomic-torpedo]'
atomic_torpedo.name = 'h2o-atomic-torpedo'
atomic_torpedo.icon = '__maraxsis__/graphics/icons/atomic-torpedo.png'
atomic_torpedo.icon_size = 64
atomic_torpedo.icon_mipmaps = nil
atomic_torpedo.ammo_type.category = 'h2o-torpedoes'
atomic_torpedo.ammo_type.action.action_delivery.projectile = 'h2o-atomic-torpedo-projectile'
data:extend {atomic_torpedo}

data:extend {{
    type = 'recipe',
    name = 'h2o-torpedo',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'rocket',      amount = 1},
        {type = 'item', name = 'rocket-fuel', amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-torpedo', amount = 1},
    },
    category = 'crafting'
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-explosive-torpedo',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'explosive-rocket', amount = 1},
        {type = 'item', name = 'rocket-fuel',      amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-explosive-torpedo', amount = 1},
    },
    category = 'crafting'
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-atomic-torpedo',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'atomic-bomb',          amount = 1},
        {type = 'item', name = 'h2o-heart-of-the-sea', amount = 1},
        {type = 'item', name = 'rocket-fuel',          amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-atomic-torpedo', amount = 1},
    },
    category = 'h2o-hydro-plant'
}}

local bubbles = table.deepcopy(data.raw['trivial-smoke']['smoke-fast'])
bubbles.name = 'h2o-bubbles'
bubbles.animation = {
    filename = '__maraxsis__/graphics/entity/bubbles/bubbles.png',
    priority = 'high',
    width = 64,
    height = 64,
    scale = 0.4,
    flags = {'smoke'},
    frame_count = 1,
}
bubbles.duration = 180
bubbles.cyclic = true
bubbles.show_when_smoke_off = true
bubbles.start_scale = 1
bubbles.end_scale = 5
bubbles.fade_away_duration = 120
data:extend {bubbles}

local submarine_bubbles = table.deepcopy(bubbles)
submarine_bubbles.name = 'h2o-submarine-bubbles'
submarine_bubbles.show_when_smoke_off = fakse
submarine_bubbles.tint = {1, 1, 1, 0.15}
submarine_bubbles.render_layer = 'lower-object-above-shadow'
data:extend {submarine_bubbles}

local nuclear_bubbles = table.deepcopy(bubbles)
nuclear_bubbles.name = 'h2o-nuclear-bubbles'
nuclear_bubbles.animation.tint = {0.5, 1, 0.5}
data:extend {nuclear_bubbles}

local names = {
    'torpedo',
    'explosive-torpedo',
    'atomic-torpedo',
}

local action = {
    type = 'instant',
    target_effects = {
        {
            type = 'create-entity',
            entity_name = 'big-explosion',
        },
        {
            type = 'create-entity',
            entity_name = 'small-scorchmark',
            check_buildability = true,
        },
        {
            type = 'nested-result',
            action = {
                type = 'area',
                radius = 4,
                action_delivery = {
                    type = 'instant',
                    target_effects = {
                        {
                            type = 'damage',
                            damage = {amount = 300, type = 'explosion'},
                        },
                        {
                            type = 'create-entity',
                            entity_name = 'explosion',
                        },
                        {
                            type = 'show-explosion-on-chart',
                            scale = 0.5,
                        },
                    },
                },
            },
        },
    },
}

local action_delivery = {
    action,
    table.deepcopy(action),
    table.deepcopy(data.raw.projectile['atomic-rocket'].action.action_delivery)
}

action_delivery[2].target_effects[1].entity_name = 'massive-explosion'
action_delivery[2].target_effects[3].action.radius = 12
action_delivery[2].target_effects[3].action.action_delivery.target_effects[1].damage.amount = 150

action_delivery[3].target_effects[4].ease_out_duration = 255
action_delivery[3].target_effects[4].strength = 20
action_delivery[3].target_effects[4].full_strength_max_distance = 400
action_delivery[3].target_effects[4].max_distance = 1600

local bubble_shockwave = table.deepcopy(data.raw['projectile']['atomic-bomb-wave-spawns-fire-smoke-explosion'])
bubble_shockwave.name = 'h2o-bubble-shockwave'
bubble_shockwave.action[1].action_delivery.target_effects[1].max_movement_distance = 3
data:extend {bubble_shockwave}

table.insert(action_delivery[2].target_effects, {
    action = {
        action_delivery = {
            projectile = 'h2o-bubble-shockwave',
            starting_speed = 0.125,
            starting_speed_deviation = 0.075,
            type = 'projectile'
        },
        radius = 2,
        repeat_count = 100,
        show_in_tooltip = false,
        target_entities = false,
        trigger_from_target = true,
        type = 'area'
    },
    type = 'nested-result'
})

for i = 1, 3 do
    data:extend {{
        type = 'projectile',
        name = 'h2o-' .. names[i] .. '-projectile',
        flags = {'not-on-map'},
        acceleration = 0.005,
        action = {
            type = 'direct',
            action_delivery = action_delivery[i],
        },
        animation = {
            filename = '__maraxsis__/graphics/entity/torpedoes/' .. names[i] .. '.png',
            frame_count = 5,
            line_length = 5,
            width = 13,
            height = 100,
            shift = {0, 0},
            priority = 'high',
            scale = 1.5
        },
        shadow = {
            filename = '__maraxsis__/graphics/entity/torpedoes/torpedo-shadow.png',
            frame_count = 1,
            width = 12,
            height = 40,
            priority = 'high',
            shift = {0, 0},
            scale = 1.5
        },
        smoke = {
            {
                name = i == 3 and 'h2o-nuclear-bubbles' or 'h2o-bubbles',
                deviation = {0.35, 0.35},
                frequency = 1,
                position = {0, 1},
                slow_down_factor = 1,
                starting_frame = 3,
                starting_frame_deviation = 50,
                starting_frame_speed = 0,
                starting_frame_speed_deviation = 5,
            },
        },
        light = {intensity = 0.5, size = 12, color = (i == 3 and {0.5, 1, 0.5} or {r = 1.0, g = 0.75, b = 0.5})},
    }}
end
