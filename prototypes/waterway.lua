local collision_mask_util = require '__core__/lualib/collision-mask-util'

data:extend{h2o.merge(data.raw['straight-rail']['straight-rail'], {
    type = 'straight-rail',
    name = 'h2o-waterway',
    icon = data.raw.fluid.water.icon,
    icon_size = 64,
    icon_mipmaps = 'nil',
    collision_mask = {'water-tile', 'ground-tile', 'object-layer'},
})}

data:extend {h2o.merge(data.raw['curved-rail']['curved-rail'], {
    type = 'straight-rail',
    name = 'h2o-waterway',
    icon = data.raw.fluid.water.icon,
    icon_size = 64,
    icon_mipmaps = 'nil',
    collision_mask = {'water-tile', 'ground-tile', 'object-layer'},
})}

data:extend{{
    type = 'item',
    name = 'h2o-waterway',
    place_result = 'h2o-waterway',
    stack_size = 50,
    icon = '__maraxsis__/graphics/icons/waterway.png', -- todo: make this icon
    icon = data.raw.fluid.water.icon,
    icon_size = 64,
    icon_mipmaps = nil,
}}

data:extend{{
    type = 'recipe',
    name = 'h2o-waterway',
    energy_required = 5,
    ingredients = {
        {type = 'fluid', amount = 50, name = 'saline-water'}
    },
    results = {
        {type = 'item', amount = 1, name = 'h2o-waterway'}
    },
    category = 'crafting-with-fluid',
    enabled = false,
}}

table.insert(data.raw.technology['h2o-maraxsis'].effects, {
    type = 'unlock-recipe',
    recipe = 'h2o-waterway'
})