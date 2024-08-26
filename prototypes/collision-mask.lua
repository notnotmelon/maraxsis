local collision_mask_util = require '__core__/lualib/collision-mask-util'

local water_placeable_blacklist = {
    'accumulator',
    'ammo-turret',
    'artillery-turret',
    'artillery-wagon',
    'assembling-machine',
    'beacon',
    'boiler',
    'burner-generator',
    'car',
    'cargo-wagon',
    'combat-robot',
    'container', -- haha
    'curved-rail',
    'electric-energy-interface',
    'electric-pole',
    'electric-turret',
    'fire',
    'fluid-turret',
    'fluid-wagon',
    'furnace',
    'generator',
    'lab',
    'linked-container',
    'locomotive',
    'logistic-container',
    'logistic-robot',
    'market',
    'reactor',
    'roboport',
    'rocket-silo',
    'solar-panel',
    'spider-leg',
    'spider-vehicle',
    'straight-rail',
    'tree',
    'turret',
    'unit',
    'unit-spawner'
}

local special_exceptions = {
    'h2o-hydro-plant',
    'h2o-hydro-plant-extra-module-slots',
    'chemical-plant',
    'h2o-submarine-leg',
}
do
    local temp = {}
    for _, k in pairs(special_exceptions) do
        temp[k] = true
    end
    special_exceptions = temp
end

for _, blacklisted in pairs(water_placeable_blacklist) do
    for _, prototype in pairs(data.raw[blacklisted]) do
        prototype.collision_mask = collision_mask_util.get_mask(prototype)
        if not next(prototype.collision_mask) then goto continue end
        if special_exceptions[prototype.name] then goto continue end
        collision_mask_util.add_layer(prototype.collision_mask, maraxsis_collision_mask)
        ::continue::
    end
end