data:extend {{
    type = 'technology',
    name = 'h2o-wyrm-confinement',
    icon = '__maraxsis__/graphics/technology/wyrm-confinement.png',
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
    order = 'ee[wyrm-confinement]',
}}

data:extend {{
    type = 'item',
    name = 'h2o-wyrm-confinement-cell',
    icon = '__maraxsis__/graphics/icons/wyrm-confinement-cell.png',
    icon_size = 64,
    icon_mipmaps = nil,
    stack_size = 10,
}}

local wyrm_variants = {}
for i = 1, 4 do
    wyrm_variants[i] = {
        filename = '__maraxsis__/graphics/icons/wyrm-specimen-' .. i .. '.png',
        width = 64,
        height = 64,
        scale = 1 / 3,
        flags = {'icon'}
    }
end

data:extend {{
    type = 'item',
    name = 'h2o-wyrm-specimen',
    icon = '__maraxsis__/graphics/icons/wyrm-specimen-2.png',
    pictures = wyrm_variants,
    icon_size = 64,
    icon_mipmaps = nil,
    stack_size = 10,
}}

data:extend {{
    type = 'recipe',
    name = 'h2o-wyrm-confinement-cell',
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = 'item', name = 'h2o-glass-panes',  amount = 3},
        {type = 'item', name = 'advanced-circuit', amount = 1},
        {type = 'item', name = 'steel-plate',      amount = 1},
    },
    results = {
        {type = 'item', name = 'h2o-wyrm-confinement-cell', amount = 1},
    },
}}

data:extend {{
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

--[[
local legs = {}

data:extend{h2o.merge(data.raw['spider-vehicle']['spidertron'], {
    name = 'h2o-wyrm',
    icon = '__maraxsis__/graphics/icons/wyrm-specimen-2.png', -- todo: change to an actual icon
    icon_size = 64,
    icon_mipmaps = nil,
    flags = {'placeable-enemy', 'placeable-off-grid', 'not-repairable', 'breaths-air'},
    max_health = 1000,
    healing_per_tick = 0.01,
    collision_box = {{-1.5, -1.5}, {1.5, 1.5}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    energy_source = {
        type = 'void',
    },
    collision_mask = {layers = {}},
    burner = 'nil',
    inventory_size = 0,
    -- graphics_set
    spider_engine = {legs = legs},
    -- height
    chunk_exploration_radius = 0,
    movement_energy_consumption = '1W',
    automatic_weapon_cycling = false,
    trash_inventory_size = 0,
})}

local leg = h2o.merge(data.raw['spider-leg']['spidertron-leg-' .. ((i % 8) + 1)], {
    name = 'h2o-wyrm-leg-' .. i,
    part_length = i / 4,
    flags = {'not-on-map', 'placeable-off-grid'},
    movement_acceleration = data.raw['spider-leg']['spidertron-leg-1'].movement_acceleration * (num_legs - i + 1),
    allow_maraxsis_water_placement = true,
    minimal_step_size = 0,
})
--]]