local FULL_BREATH_NUM_TICKS = 15 * 60 * 60 -- fifteen minutes before you start drowning
local WARNING_MESSAGE = FULL_BREATH_NUM_TICKS / 5
local UPDATE_RATE = 71

maraxsis.on_event(maraxsis.events.on_init(), function()
    storage.breath = storage.breath or {}
end)

local is_abyssal_diving_gear = {
    ["maraxsis-abyssal-diving-gear"] = true,
    ["maraxsis-abyssal-diving-gear-disabled"] = true,
}

maraxsis.on_nth_tick(UPDATE_RATE, function()
    for _, player in pairs(game.connected_players) do
        local character = player.character
        if not character then goto continue end
        local position = character.position
        local surface = character.surface
        local surface_name = surface.name
        local player_surface_index = surface.index

        if not maraxsis.MARAXSIS_SURFACES[surface_name] then
            goto continue
        end

        local vehicle = player.physical_vehicle
        if vehicle then
            storage.breath[player.index] = nil
            goto continue
        end

        local grid = character.grid
        if grid then
            for _, equipment in pairs(grid.get_contents()) do
                if is_abyssal_diving_gear[equipment.name] then
                    storage.breath[player.index] = nil
                    goto continue
                end
            end
        end

        for _, pressure_dome_data in pairs(storage.pressure_domes) do
            local surface = pressure_dome_data.surface
            if not surface.valid then goto continue_2 end
            local surface_index = surface.index
            if surface_index ~= player_surface_index then goto continue_2 end

            local dome_position = pressure_dome_data.position
            local x, y = position.x - dome_position.x, position.y - dome_position.y
            if is_point_in_polygon(x, y) then
                storage.breath[player.index] = nil
                goto continue
            end

            ::continue_2::
        end

        local breath = storage.breath[player.index] or FULL_BREATH_NUM_TICKS
        local breath_loss = UPDATE_RATE
        local is_trench = surface_name == maraxsis.TRENCH_SURFACE_NAME
        if is_trench then breath_loss = breath_loss * 30 end
        breath = math.max(0, breath - breath_loss)
        storage.breath[player.index] = breath

        if breath <= WARNING_MESSAGE then
            player.print({"maraxsis.drowning"}, {
                skip = defines.print_skip.if_visible
            })
        end

        if breath > 0 then
            goto continue
        end

        local true_damage = character.health - math.min(50, character.max_health * 0.1)
        if true_damage <= 0 then
            character.die("neutral")
        else
            character.health = true_damage
        end

        ::continue::
    end
end)

maraxsis.on_event({
    defines.events.on_player_changed_surface,
    defines.events.on_player_respawned,
    defines.events.on_player_died
}, function(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end
    storage.breath[player.index] = nil
end)

maraxsis.on_event(defines.events.on_player_died, function(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end
    if not player.surface.name ~= maraxsis.TRENCH_SURFACE_NAME then return end

    local character = player.character
    if not character then return end

    character.teleport({0, 0}, "maraxsis")
end)
