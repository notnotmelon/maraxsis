
local mining_drill_prototypes = prototypes.get_entity_filtered{{filter="type", type="mining-drill"}}

local function determine_place_direction(surface, position, drill_prototype)
    local offset_width = drill_prototype.tile_width
    local offset_height = drill_prototype.tile_height
    local margin = 0.5

    -- if mining drill is not square, this code can't cleanly handle it, so fallback to north
    if offset_width ~= offset_height then return defines.direction.north end

    local area = {
        {position.x - offset_width + margin, position.y - offset_height + margin},
        {position.x + offset_width - margin, position.y + offset_height - margin}
    }
    local belt_types = {"transport-belt", "underground-belt", "splitter", "container"}

    local neighboring_belts = table.array_combine(
        surface.find_entities_filtered{
            area = area,
            type = belt_types
        },
        surface.find_entities_filtered{
            area = area,
            ghost_type = belt_types,
        }

    )

    for _, neighbor in pairs(neighboring_belts or {}) do
        local delta_pos = {x = neighbor.position.x - position.x, y = neighbor.position.y - position.y}
        if (delta_pos.x <= 0.5 and delta_pos.x >= -0.5) then
            if delta_pos.y > 0 then
                return defines.direction.south
            else
                return defines.direction.north
            end
        elseif (delta_pos.y <= 0.5 and delta_pos.y >= -0.5) then
            if delta_pos.x > 0 then
                return defines.direction.east
            else
                return defines.direction.west
            end
        end
    end

    return defines.direction.north
end

local function construct_sand_extractor(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end
    local surface = player.surface
    if surface.name ~= maraxsis_constants.MARAXSIS_SURFACE_NAME then return end

    local cursor_stack = player.cursor_stack
    local cursor_stack_valid = cursor_stack and cursor_stack.valid_for_read and cursor_stack.count > 0
    local force = player.force

    local quality
    local name
    if cursor_stack_valid then
        name = cursor_stack.name
        quality = cursor_stack.quality
    else
        local cursor_ghost = player.cursor_ghost
        if not cursor_ghost then return end
        name = cursor_ghost.name.name
        quality = cursor_ghost.quality
    end

    local drill_prototype = mining_drill_prototypes[name]
    if not drill_prototype then return end
    if not maraxsis_constants.MARAXSIS_SAND_EXTRACTORS[name] then return end
    name = name .. "-sand-extractor"
    local position = event.cursor_position
    
    if surface.entity_prototype_collides(name, position, false) then return end
    
    if surface.get_tile(position).hidden_tile then 
        player.create_local_flying_text{
            text = {"cant-build-reason.cant-build-on-tile", surface.get_tile(position).prototype.localised_name},
            surface = surface,
            create_at_cursor = true,
            speed = 0.01,
        }
        return -- If tile is unnatural, like concrete, then don't place mine. Muluna addition.
    end
    
    local distance = math.sqrt((position.x - player.physical_position.x)^2 + (position.y - player.physical_position.y)^2)
    local is_ghost = (not cursor_stack_valid) or event.input_name == "build-ghost" or event.input_name == "super-forced-build"
    if player.character and (distance >= player.character.build_distance) and not is_ghost then
        return -- If unreachable, then don't place
    end

    surface.create_entity {
        name = is_ghost and "entity-ghost" or name,
        inner_name = is_ghost and name or nil,
        position = position,
        force = player.force,
        player = player,
        quality = quality,
        direction = determine_place_direction(surface, position, drill_prototype)
    }

    if not is_ghost then
        cursor_stack.count = cursor_stack.count - 1
        force.get_entity_build_count_statistics(surface).on_flow(name, 1)
    end
end
maraxsis.register_delayed_function("construct_sand_extractor", construct_sand_extractor)

-- "build" and "build-ghost" and "super-forced-build" are custom keybind inputs
maraxsis.on_event({"build", "build-ghost", "super-forced-build"}, function(event)
    maraxsis.execute_later("construct_sand_extractor", 1, event)
end)
