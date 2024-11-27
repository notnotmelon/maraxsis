-- This file locks the rotation of the hydro plant to either the east or west orientations
-- This exists becuase the entity graphics are incompatible with pipe connections to the north or south.
local allowed_directions = {
    [defines.direction.east] = defines.direction.west,
    [defines.direction.west] = defines.direction.east,
}

local function is_hydro_plant(entity)
    if entity.name == "maraxsis-hydro-plant" then return true end
    if entity.name == "entity-ghost" and entity.ghost_name == "maraxsis-hydro-plant" then return true end
    return false
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
