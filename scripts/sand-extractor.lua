-- "build" and "build-ghost" are custom keybind inputs

maraxsis.on_event({"build", "build-ghost", "super-forced-build"}, function(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    local cursor_stack = player.cursor_stack
    local cursor_stack_valid = cursor_stack and cursor_stack.valid_for_read and cursor_stack.count > 0 

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

    if not maraxsis.MARAXSIS_SAND_EXTRACTORS[name] then return end
    name = name .. "-sand-extractor"

    local surface = player.surface
    if surface.name ~= maraxsis.MARAXSIS_SURFACE_NAME then return end
    local position = event.cursor_position

    if surface.entity_prototype_collides(name, position, false) then return end
    local is_ghost = (not cursor_stack_valid) or event.input_name == "build-ghost" or event.input_name == "super-forced-build"
    
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
    end
end)
