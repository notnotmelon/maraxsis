-- "build" and "build-ghost" are custom keybind inputs

maraxsis.on_event({"build", "build-ghost"}, function(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    local cursor_stack = player.cursor_stack
    if not cursor_stack or not cursor_stack.valid_for_read then return end
    if cursor_stack.count == 0 then return end
    if not maraxsis.MARAXSIS_SAND_EXTRACTORS[cursor_stack.name] then return end

    local surface = player.surface
    if surface.name ~= maraxsis.MARAXSIS_SURFACE_NAME then return end
    local position = event.cursor_position

    local name = cursor_stack.name .. "-sand-extractor"
    if surface.entity_prototype_collides(name, position, false) then return end
    local is_ghost = event.input_name == "build-ghost"

    surface.create_entity {
        name = is_ghost and "entity-ghost" or name,
        inner_name = is_ghost and name or nil,
        position = position,
        force = player.force,
        player = player,
        quality = cursor_stack.quality,
    }

    cursor_stack.count = cursor_stack.count - 1
end)
