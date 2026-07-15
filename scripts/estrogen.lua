local estrogen_effects = {
    switch_force = function(entity, on)
        storage.estrogen_original_forces = storage.estrogen_original_forces or {}
        if on then
            storage.estrogen_original_forces[entity.unit_number] = entity.force_index
            entity.force = "enemy"
        else
            entity.force = storage.estrogen_original_forces[entity.unit_number]
            storage.estrogen_original_forces[entity.unit_number] = nil
        end
    end,
    rotate = function(entity, on)
        storage.estrogen_rotated_entities = storage.estrogen_rotated_entities or {}

        if storage.estrogen_rotated_entities[entity.unit_number] then
            if on then return end
            entity.direction = storage.estrogen_rotated_entities[entity.unit_number]
            storage.estrogen_rotated_entities[entity.unit_number] = nil
        else
            if not on then return end
            local original_direction = entity.direction
            if not entity.flip{horizontal = true} then
                if not entity.rotate{reverse = false} then
                    return
                end
            end
            storage.estrogen_rotated_entities[entity.unit_number] = original_direction
        end
    end,
    rotate_west = function(entity, on)
        storage.estrogen_rotated_entities = storage.estrogen_rotated_entities or {}

        if storage.estrogen_rotated_entities[entity.unit_number] then
            if on then return end
            entity.direction = storage.estrogen_rotated_entities[entity.unit_number]
            storage.estrogen_rotated_entities[entity.unit_number] = nil
        else
            if not on then return end
            entity.direction = defines.direction.west
            storage.estrogen_rotated_entities[entity.unit_number] = entity.direction
        end
    end,
    random_quality_bonus = function(entity, on)

    end,
    extra_arms = function(entity, on)
        storage.estrogen_has_extra_arms = storage.estrogen_has_extra_arms or {}
        storage.estrogen_is_an_extra_arm = storage.estrogen_is_an_extra_arm or {}

        if storage.estrogen_is_an_extra_arm[entity.unit_number] then return end

        if on then
            if storage.estrogen_has_extra_arms[entity.unit_number] then return end
            local extra_arm = surface.create_entity {
                name = entity.name,
                position = entity.position,
                force = entity.force_index,
                mirror = entity.mirroring,
                quality = entity.quality,
                direction = entity.direction,
                create_build_effect_smoke = false,
                raise_built = false,
                move_stuck_players = false
            }
            extra_arm.minable_flag = false
            extra_arm.operable = false
            extra_arm.rotatable = false
            extra_arm.destructible = false
            extra_arm.rotate{}
            storage.estrogen_has_extra_arms[entity.unit_number] = extra_arm
            storage.estrogen_is_an_extra_arm[extra_arm.unit_number] = extra_arm
        else
            if not storage.estrogen_has_extra_arms[entity.unit_number] then return end
            local extra_arm = storage.estrogen_has_extra_arms[entity.unit_number]
            storage.estrogen_has_extra_arms[entity.unit_number] = nil
            if not extra_arm.valid then return end
            storage.estrogen_is_an_extra_arm[extra_arm.unit_number] = nil
            extra_arm.destroy()
        end
    end,
    explode = function(entity, on)
        entity.surface.create_entity {
            name = "atomic-rocket",
            position = entity.position,
            target = entity,
            speed = 1,
            max_range = 0.1
        }
    end,
    cant_breathe = function(entity, on)
        -- handled in pressure-dome.lua and drowning.lua
    end,
}

local EFFECTABLE_TYPES = {
    ["assembling-machine"] = estrogen_effects.random_quality_bonus,
    ["furnace"] = estrogen_effects.random_quality_bonus,
    ["rocket-silo"] = estrogen_effects.random_quality_bonus,
    ["transport-belt"] = estrogen_effects.rotate_west,
    ["inserter"] = estrogen_effects.extra_arms,
    ["splitter"] = estrogen_effects.rotate,
    ["pump"] = estrogen_effects.rotate,
    ["ammo-turret"] = estrogen_effects.switch_force,
    ["electric-turret"] = estrogen_effects.switch_force,
    ["fluid-turret"] = estrogen_effects.switch_force,
    ["artillery-turret"] = estrogen_effects.switch_force,
    ["turret"] = estrogen_effects.switch_force,
}

local EFFECTABLE_NAMES = {
    ["maraxsis-regulator"] = estrogen_effects.cant_breathe,
    ["kr-fusion-reactor"] = estrogen_effects.explode,
    ["nuclear-reactor"] = estrogen_effects.explode,
    ["fusion-reactor"] = estrogen_effects.explode,
}

maraxsis.on_event(maraxsis.events.on_init(), function()
    storage.estrogen_stickers = {}
end)

local function register_estrogen_sticker(sticker, target)
    local registration_number = script.register_on_object_destroyed(sticker)
    storage.estrogen_stickers[registration_number] = target
end

maraxsis.on_event(defines.events.on_object_destroyed, function(event)
    local target = storage.estrogen_stickers[event.registration_number]
    if not target or not target.valid then return end

    if target.type == "character" then
        target.force.script_trigger_research("maraxsis-ooozma-confinement")
    end
end)

local function apply_estrogen_max_duration(player)
    local c = player.character
    if not c or not c.valid then return end
    local resistance = maraxsis.get_estrogen_resistance(player)
    local max_duration = resistance * maraxsis_constants.ESTROGEN_DURATION
    for _, sticker in pairs(c.stickers or {}) do
        if sticker.name == "maraxsis-estrogen-sticker" or sticker.name == "maraxsis-estrogen-sticker-behind" then
            register_estrogen_sticker(sticker, c)
            if sticker.time_to_live > max_duration then
                sticker.time_to_live = max_duration
            end
        end
    end
end

maraxsis.on_event(defines.events.on_script_trigger_effect, function(event)
	local effect_id = event.effect_id
	if effect_id ~= "maraxsis-estrogen-sticker-applied" then return end

    for _, player in pairs(game.players) do
        apply_estrogen_max_duration(player)
    end
end)

maraxsis.on_event({
    defines.events.on_player_armor_inventory_changed,
    defines.events.on_equipment_inserted,
    defines.events.on_equipment_removed,
}, function()
    for _, player in pairs(game.players) do
        apply_estrogen_max_duration(player)
    end
end)
