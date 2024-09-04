local collision_mask_util = require '__core__/lualib/collision-mask-util'

local processed_prototypes = table.deepcopy(defines.prototypes.entity)
for prototype, _ in pairs(processed_prototypes) do
    processed_prototypes[prototype] = false
end

local prototypes_that_cant_be_placed_on_water = {
    'container',
    'linked-container',
    'logistic-container',
    'infinity-container',
    'accumulator',
    'lab',
    'assembling-machine',
    'boiler',
    'burner-generator',
    'electric-energy-interface',
    'fire',
    'furnace',
    'generator',
    'market',
    'reactor',
    'roboport',
    'tree',
    'power-switch',
    'simple-entity-with-force',
    'simple-entity-with-owner',
    'solar-panel',
}

local prototypes_that_cant_be_placed_in_a_dome = {
    'rocket-silo',
    'turret',
    'ammo-turret',
    'electric-turret',
    'land-mine',
    data.raw['assembling-machine']['h2o-hydro-plant'],
    data.raw['assembling-machine']['h2o-hydro-plant-extra-module-slots'],
    data.raw['radar']['h2o-sonar'],
}

local prototypes_that_cant_be_placed_in_a_dome_or_on_water = {
    'artillery-turret',
    'artillery-wagon',
    'car',
    'cargo-wagon',
    'combat-robot',
    'curved-rail',
    'fluid-turret',
    'fluid-wagon',
    'locomotive',
    'spider-leg',
    'spider-vehicle',
    'straight-rail',
    'unit',
    'unit-spawner',
    'tile',
    'radar', -- todo: add sonar
    data.raw['mining-drill']['burner-mining-drill']
}

local prototypes_that_can_be_placed_whereever = {
    data.raw['straight-rail']['straight-rail'],
    data.raw['curved-rail']['curved-rail'],
    data.raw['assembling-machine']['chemical-plant'],
    data.raw['electric-energy-interface']['electric-energy-interface'],
    data.raw['electric-energy-interface']['ee-infinity-accumulator-primary-output'],
    data.raw['electric-energy-interface']['ee-infinity-accumulator-secondary-output'],
    data.raw['electric-energy-interface']['ee-infinity-accumulator-tertiary-output'],
    data.raw['electric-energy-interface']['ee-infinity-accumulator-primary-input'],
    data.raw['electric-energy-interface']['ee-infinity-accumulator-secondary-input'],
    data.raw['electric-energy-interface']['ee-infinity-accumulator-tertiary-input'],
    data.raw['electric-energy-interface']['ee-infinity-accumulator-tertiary-buffer'],
    data.raw['spider-leg']['h2o-submarine-leg'],
    data.raw['spider-vehicle']['h2o-diesel-submarine'],
    data.raw['spider-vehicle']['h2o-nuclear-submarine'],
    data.raw.tile['h2o-pressure-dome-tile'],

    'arithmetic-combinator',
    'constant-combinator',
    'decider-combinator',

    'linked-belt',
    'loader',
    'loader-1x1',
    'splitter',
    'underground-belt',
    'transport-belt',

    'infinity-pipe',
    'pipe',
    'pipe-to-ground',
    'storage-tank',

    'train-stop',
    'rail-chain-signal',
    'rail-remnants',
    'rail-signal',
    
    'gate',
    'wall',

    'electric-pole', -- todo: consider replacing with fiber optic cable
    'arrow',
    'artillery-flare',
    'artillery-projectile',
    'beacon',
    'beam',
    'character',
    'character-corpse',
    'cliff',
    'construction-robot',
    'logistic-robot',
    'corpse',
    'deconstructible-tile-proxy',
    'entity-ghost',
    'explosion',
    'fish',
    'flame-thrower-explosion',
    'flying-text',
    'heat-interface',
    'heat-pipe',
    'highlight-box',
    'inserter', -- todo: consider loaders?
    'item-entity',
    'item-request-proxy',
    'lamp',
    'leaf-particle',
    'mining-drill',
    'offshore-pump',
    'particle',
    'particle-source',
    'player-port',
    'programmable-speaker',
    'projectile',
    'pump',
    'resource',
    'rocket-silo-rocket',
    'rocket-silo-rocket-shadow',
    'simple-entity',
    'smoke',
    'smoke-with-trigger',
    'speech-bubble',
    'sticker',
    'stream',
    'tile-ghost',
}

for _, anywhere in pairs(prototypes_that_can_be_placed_whereever) do
    if type(anywhere) == 'string' then
       processed_prototypes[anywhere] = true
    end
end

local function block_placement_tile(tile, layer)
    local item_to_place
    for _, item in pairs(data.raw.item) do
        if item.place_as_tile and item.place_as_tile.result == tile.name then
            item_to_place = item
            break
        end
    end
    if not item_to_place then return end
    
    local place_as_tile = item_to_place.place_as_tile
    place_as_tile.condition = place_as_tile.condition or {}
    collision_mask_util.add_layer(place_as_tile.condition, layer)
end

local function block_placement(prototype, layer)
    if prototype.allow_maraxsis_water_placement then return end -- this check is not used by maraxsis however it may be useful for 3rd party mods doing compatibility

    for _, e in pairs(prototypes_that_can_be_placed_whereever) do
        if e == prototype then return end
    end

    if prototype.type and prototype.type == 'tile' then
        block_placement_tile(prototype, layer)
        return
    end

    prototype.collision_mask = collision_mask_util.get_mask(prototype)
    if not next(prototype.collision_mask) then goto continue end -- skip if no collision mask to save UPS
    collision_mask_util.add_layer(prototype.collision_mask, layer)
    ::continue::
end

local function add_collision_layer_to_prototypes(prototypes, layer)
    for _, blacklisted in pairs(prototypes) do
        if type(blacklisted) == 'table' then
            block_placement(blacklisted, layer)
        else
            for _, prototype in pairs(data.raw[blacklisted]) do
                block_placement(prototype, layer)
            end
            processed_prototypes[blacklisted] = true
        end
    end
end

local function remove_collision_layer_to_prototypes(prototypes, layer)
    for _, blacklisted in pairs(prototypes) do
        if type(blacklisted) == 'table' then
            blacklisted.collision_mask = collision_mask_util.get_mask(blacklisted)
            collision_mask_util.remove_layer(blacklisted.collision_mask, layer)
        else
            for _, prototype in pairs(data.raw[blacklisted]) do
                prototype.collision_mask = collision_mask_util.get_mask(prototype)
                collision_mask_util.remove_layer(prototype.collision_mask, layer)
            end
        end
    end
end

add_collision_layer_to_prototypes(prototypes_that_cant_be_placed_in_a_dome_or_on_water, maraxsis_collision_mask)
add_collision_layer_to_prototypes(prototypes_that_cant_be_placed_in_a_dome_or_on_water, dome_collision_mask)
add_collision_layer_to_prototypes(prototypes_that_cant_be_placed_on_water, maraxsis_collision_mask)
remove_collision_layer_to_prototypes(prototypes_that_cant_be_placed_on_water, dome_collision_mask)
add_collision_layer_to_prototypes(prototypes_that_cant_be_placed_in_a_dome, dome_collision_mask)
remove_collision_layer_to_prototypes(prototypes_that_cant_be_placed_in_a_dome, maraxsis_collision_mask)

for prototype, processed in pairs(processed_prototypes) do
    assert(processed, 'Error in Maraxsis collision mask algorithms! Unrecognized prototype ' .. prototype)
end