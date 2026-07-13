-- "build" and "build-ghost" and "super-forced-build" are custom keybind inputs

local function construct_sand_extractor(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

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

    if not maraxsis_constants.MARAXSIS_SAND_EXTRACTORS[name] then return end
    name = name .. "-sand-extractor"

    local surface = player.surface
    if surface.name ~= maraxsis_constants.MARAXSIS_SURFACE_NAME then return end
    local position = event.cursor_position
    local player_position = player.physical_position
    
    if surface.entity_prototype_collides(name, position, false) then return end
    
    if surface.get_tile(position).hidden_tile then 
        player.create_local_flying_text{
            text = {"console.can-not-place-here-unnatural-tile"},
            surface = surface,
            create_at_cursor = true,
            speed = 0.01,
        }
        return -- If tile is unnatural, like concrete, then don't place mine. Muluna addition.
    end
    
    do
        local distance = math.sqrt((position.x - player_position.x)^2 + (position.y - player_position.y)^2)
        local is_ghost = (not cursor_stack_valid) or event.input_name == "build-ghost" or event.input_name == "super-forced-build"
        if player.character and (distance >= player.character.build_distance) and not is_ghost then
            return -- If unreachable, then don't place
        end
    end

    surface.create_entity {
        name = is_ghost and "entity-ghost" or name,
        inner_name = is_ghost and name or nil,
        position = position,
        force = player.force,
        player = player,
        quality = quality,
    }

    if not is_ghost then
        cursor_stack.count = cursor_stack.count - 1
        force.get_entity_build_count_statistics(surface).on_flow(name, 1)
    end
end
maraxsis.register_delayed_function("construct_sand_extractor", construct_sand_extractor)

maraxsis.on_event({"build", "build-ghost", "super-forced-build"}, function(event)
    maraxsis.execute_later("construct_sand_extractor", 1, event)
end)
