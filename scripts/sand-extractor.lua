maraxsis.on_event(maraxsis.events.on_entity_clicked(), function(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    local cursor_stack = player.cursor_stack
    if not cursor_stack or not cursor_stack.valid_for_read then return end
    if cursor_stack.count == 0 then return end
    if not maraxsis.MARAXSIS_SAND_EXTRACTORS[cursor_stack.name] then return end

    local surface = player.surface
    if surface.name ~= maraxsis.MARAXSIS_SURFACE_NAME then return end
    local position = event.cursor_position

    if surface.entity_prototype_collides(cursor_stack.name, position, false) then return end

    surface.create_entity {
        name = cursor_stack.name .. "-sand-extractor",
        position = position,
        force = player.force,
        player = player,
        quality = cursor_stack.quality,
    }

    cursor_stack.count = cursor_stack.count - 1
end)
