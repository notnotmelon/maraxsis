h2o.on_event('on_init', function()
    global.breath = global.breath or {}
end)

h2o.on_nth_tick(71, function()
    for _, player in pairs(game.connected_players) do
        local character = player.character
        if not character then goto continue end
        local surface = player.surface
        local surface_name = surface.name

        if surface_name ~= h2o.MARAXIS_SURFACE_NAME and surface_name ~= h2o.TRENCH_SURFACE_NAME then
            goto continue
        end

        local max_health = character.prototype.max_health
        local true_damage = character.health - max_health * 0.1
        if true_damage < 0 then
            character.die('neutral')
        else
            character.health = true_damage
        end
        player.print({'maraxsis.drowning'}, {
            skip = defines.print_skip.if_visible
        })

        ::continue::
    end
end)