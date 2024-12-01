-- This file locks the rotation of the hydro plant to either the east or west orientations
-- This exists becuase the entity graphics are incompatible with pipe connections to the north or south.
local allowed_directions = {
    [defines.direction.east] = defines.direction.west,
    [defines.direction.west] = defines.direction.east,
}

local function is_hydro_plant(entity)
    local name = entity.name == "entity-ghost" and entity.ghost_name or entity.name
    return name == "maraxsis-hydro-plant" or name == "maraxsis-hydro-plant-extra-module-slots"
end

local function rotate_hydro_plant(entity)
    local direction = entity.direction
    if allowed_directions[direction] then return end
    while not allowed_directions[direction] do
        direction = (direction + 1) % 16
    end
    entity.direction = direction
end

maraxsis.on_event(maraxsis.events.on_built(), function(event)
    local entity = event.entity
    if not entity.valid then return end
    if not is_hydro_plant(entity) then return end
    rotate_hydro_plant(entity)
end)

maraxsis.on_event(defines.events.on_player_rotated_entity, function(event)
    local entity = event.entity
    if not entity.valid then return end
    if not is_hydro_plant(entity) then return end

    local direction = entity.direction
    local previous_direction = event.previous_direction
    if allowed_directions[direction] then
        -- The player has rotated a hydro plant to a valid direction. No action needed.
        return
    end
    if allowed_directions[previous_direction] and not allowed_directions[direction] then
        -- The player has rotated a hydro plant. Swap it between the two valid directions.
        local new_rotation = allowed_directions[previous_direction]
        entity.direction = new_rotation
        return
    end
    -- Edge case: The player has rotated a hydro plant however we do not know the direction of rotation.
    -- We will rotate the drill to the nearest valid direction.
    rotate_hydro_plant(entity)
end)

local swap_target = {
    ["maraxsis-hydro-plant"] = "maraxsis-hydro-plant-extra-module-slots",
    ["maraxsis-hydro-plant-extra-module-slots"] = "maraxsis-hydro-plant",
}

-- swap the hydro plant with 2 extra modules slots in the trench surface
maraxsis.on_event(maraxsis.events.on_built(), function(event)
    local entity = event.entity
    if not entity.valid then return end

    if not is_hydro_plant(entity) then return end
    local surface = entity.surface
    local is_ghost = entity.name == "entity-ghost"
    local name = is_ghost and entity.ghost_name or entity.name

    local is_space = not not surface.platform
    if name == "maraxsis-hydro-plant" and surface.name == maraxsis.MARAXSIS_SURFACE_NAME then
        return
    elseif name == "maraxsis-hydro-plant-extra-module-slots" and surface.name == maraxsis.TRENCH_SURFACE_NAME then
        return
    elseif name == "maraxsis-hydro-plant-extra-module-slots" and is_space then
        return
    end
    local swap_target = swap_target[name]

    local player = event.player_index and game.get_player(event.player_index)

    local new_entity = surface.create_entity {
        name = is_ghost and "entity-ghost" or swap_target,
        inner_name = is_ghost and swap_target or nil,
        tags = is_ghost and entity.tags or nil,
        position = entity.position,
        direction = entity.direction,
        force = entity.force_index,
        quality = entity.quality,
        health = entity.health,
        raise_built = true,
        player = player,
        character = player and player.character,
    }
    new_entity.mirroring = entity.mirroring
    new_entity.copy_settings(entity)

    if not is_ghost then
        local modules = entity.get_module_inventory().get_contents()
        for _, item in pairs(modules) do
            local inserted_count = new_entity.insert(item)
            if inserted_count < item.count then
                item.count = item.count - inserted_count
                surface.spill_item_stack {
                    position = entity.position,
                    stack = item,
                    enable_looted = true,
                    force = entity.force_index,
                    allow_belts = false
                }
            end
        end
    end

    entity.destroy()
end)
