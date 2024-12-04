local collision_mask_util = require "__core__/lualib/collision-mask-util"

data:extend {{
    name = maraxsis_collision_mask,
    type = "collision-layer",
}}

data:extend {{
    name = maraxsis_dome_collision_mask,
    type = "collision-layer",
}}

data:extend {{
    name = maraxsis_lava_collision_mask,
    type = "collision-layer",
}}

data:extend {{
    name = maraxsis_fishing_tower_collision_mask,
    type = "collision-layer",
}}

data:extend {{
    name = maraxsis_trench_entrance_collision_mask,
    type = "collision-layer",
}}

local processed_prototypes = table.deepcopy(defines.prototypes.entity)
for prototype, _ in pairs(processed_prototypes) do
    processed_prototypes[prototype] = false
end

local prototypes_that_cant_be_placed_on_water = {
    "container",
    "linked-container",
    "logistic-container",
    "accumulator",
    "lab",
    "assembling-machine",
    "boiler",
    "burner-generator",
    "electric-energy-interface",
    "fire",
    "furnace",
    "beacon",
    "generator",
    "market",
    "reactor",
    "tree",
    "simple-entity-with-force",
    "simple-entity-with-owner",
    "fusion-reactor",
    "fusion-generator",
    "curved-rail-a",
    "curved-rail-b",
    "legacy-curved-rail",
    "legacy-straight-rail",
    "half-diagonal-rail",
    "rail-ramp",
    "rail-support",
    "heat-pipe",
    "straight-rail",
    data.raw.roboport["aai-signal-sender"],
    data.raw.roboport["aai-signal-receiver"],
}

local prototypes_that_cant_be_placed_in_a_dome = {
    "rocket-silo",
    "turret",
    "ammo-turret",
    "electric-turret",
    "land-mine",
    "cargo-landing-pad",
    "cargo-bay",
    "agricultural-tower",
    data.raw.radar["maraxsis-sonar"],
    "mining-drill",
}

local prototypes_that_cant_be_placed_in_a_dome_or_on_water = {
    "artillery-turret",
    "artillery-wagon",
    "car",
    "fluid-turret",
    "spider-leg",
    "spider-vehicle",
    "roboport",
    data.raw.radar.radar,
    data.raw["mining-drill"]["burner-mining-drill"]
}

local prototypes_that_cannot_be_placed_in_the_trench = {
    "rocket-silo",
    "cargo-landing-pad",
    "cargo-bay",
    "curved-rail-a",
    "curved-rail-b",
    "legacy-curved-rail",
    "legacy-straight-rail",
    "half-diagonal-rail",
    "rail-ramp",
    "rail-support",
    "straight-rail",
    "elevated-curved-rail-a",
    "elevated-curved-rail-b",
    "elevated-half-diagonal-rail",
    "elevated-straight-rail",
}

local prototypes_that_can_be_placed_whereever = {
    data.raw.container["sp-spidertron-dock"],
    data.raw["assembling-machine"]["maraxsis-hydro-plant"],
    data.raw["assembling-machine"]["maraxsis-hydro-plant-extra-module-slots"],
    data.raw["assembling-machine"]["chemical-plant"],
    data.raw["electric-energy-interface"]["electric-energy-interface"],
    data.raw["electric-energy-interface"]["ee-infinity-accumulator-primary-output"],
    data.raw["electric-energy-interface"]["ee-infinity-accumulator-secondary-output"],
    data.raw["electric-energy-interface"]["ee-infinity-accumulator-tertiary-output"],
    data.raw["electric-energy-interface"]["ee-infinity-accumulator-primary-input"],
    data.raw["electric-energy-interface"]["ee-infinity-accumulator-secondary-input"],
    data.raw["electric-energy-interface"]["ee-infinity-accumulator-tertiary-input"],
    data.raw["electric-energy-interface"]["ee-infinity-accumulator-tertiary-buffer"],
    data.raw["spider-leg"]["maraxsis-submarine-leg"],
    data.raw["spider-vehicle"]["maraxsis-diesel-submarine"],
    data.raw["spider-vehicle"]["spidertron-enhancements-dummy-maraxsis-diesel-submarine"],
    data.raw["spider-vehicle"]["constructron"],
    data.raw["spider-vehicle"]["spidertron-enhancements-dummy-constructron"],
    data.raw["spider-vehicle"]["maraxsis-nuclear-submarine"],
    data.raw["spider-vehicle"]["spidertron-enhancements-dummy-maraxsis-nuclear-submarine"],
    data.raw.roboport.service_station,
    data.raw.roboport["maraxsis-pressure-dome"],
}

for _, anywhere in pairs(prototypes_that_can_be_placed_whereever) do
    processed_prototypes[anywhere.name] = true
end

local function block_placement(prototype, layer)
    if prototype.allow_maraxsis_water_placement then return end -- this check is not used by maraxsis however it may be useful for 3rd party mods doing compatibility

    if processed_prototypes[prototype.name] then return end
    processed_prototypes[prototype.name] = true

    prototype.collision_mask = collision_mask_util.get_mask(prototype)
    if not next(prototype.collision_mask) then goto continue end -- skip if no collision mask to save UPS
    prototype.collision_mask.layers[layer] = true
    ::continue::
end

local function add_collision_layer_to_prototypes(prototypes, layer)
    for _, blacklisted in pairs(prototypes) do
        if type(blacklisted) == "table" then
            block_placement(blacklisted, layer)
        else
            for _, prototype in pairs(data.raw[blacklisted]) do
                block_placement(prototype, layer)
            end
        end
    end
end

local function remove_collision_layer_to_prototypes(prototypes, layer)
    for _, blacklisted in pairs(prototypes) do
        if type(blacklisted) == "table" then
            blacklisted.collision_mask = collision_mask_util.get_mask(blacklisted)
            blacklisted.collision_mask.layers[layer] = nil
        else
            for _, prototype in pairs(data.raw[blacklisted]) do
                prototype.collision_mask = collision_mask_util.get_mask(prototype)
                prototype.collision_mask.layers[layer] = nil
            end
        end
    end
end

local function blacklist_via_surface_condition(entity, max_pressure)
    if processed_prototypes[entity.name] then return end
    processed_prototypes[entity.name] = true

    entity.surface_conditions = table.deepcopy(entity.surface_conditions or {})

    for _, surface_condition in pairs(entity.surface_conditions) do
        if surface_condition.property == "pressure" then
            assert((surface_condition.min or 0) < max_pressure, "An error occurred while blacklisting " .. entity.name .. " from being placed in a dome or on water.")
            surface_condition.max = math.min(max_pressure, surface_condition.max or max_pressure)
            return
        end
    end

    table.insert(entity.surface_conditions, {
        property = "pressure",
        max = max_pressure
    })
end

add_collision_layer_to_prototypes(prototypes_that_cant_be_placed_on_water, maraxsis_collision_mask)
remove_collision_layer_to_prototypes(prototypes_that_cant_be_placed_on_water, maraxsis_dome_collision_mask)
add_collision_layer_to_prototypes(prototypes_that_cant_be_placed_in_a_dome, maraxsis_dome_collision_mask)
remove_collision_layer_to_prototypes(prototypes_that_cant_be_placed_in_a_dome, maraxsis_collision_mask)

for _, blacklisted in pairs(prototypes_that_cant_be_placed_in_a_dome_or_on_water) do
    if type(blacklisted) == "table" then
        blacklist_via_surface_condition(blacklisted, 50000)
    else
        for _, prototype in pairs(data.raw[blacklisted]) do
            blacklist_via_surface_condition(prototype, 50000)
        end
    end
end

for _, blacklisted in pairs(prototypes_that_cannot_be_placed_in_the_trench) do
    if type(blacklisted) == "table" then
        processed_prototypes[blacklisted.name] = false
        blacklist_via_surface_condition(blacklisted, 300000)
    else
        for _, prototype in pairs(data.raw[blacklisted]) do
            processed_prototypes[prototype.name] = false
            blacklist_via_surface_condition(prototype, 300000)
        end
    end
end

for _, ramp in pairs(data.raw["rail-ramp"]) do
    for _, rule in pairs(ramp.tile_buildability_rules or {}) do
        if rule.required_tiles and rule.required_tiles.layers and rule.required_tiles.layers.ground_tile then
            rule.required_tiles.layers[maraxsis_dome_collision_mask] = true
        end
    end
end
