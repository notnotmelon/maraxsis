local FULL_BREATH_NUM_TICKS = 2 * 60 * 60 -- two minutes before you start drowning
local WARNING_MESSAGE = FULL_BREATH_NUM_TICKS / 4
local UPDATE_RATE = 71

local SUBMARINES = {
    ['h2o-diesel-submarine'] = true,
    ['h2o-nuclear-submarine'] = true,
}

h2o.on_event('on_init', function()
    global.breath = global.breath or {}
end)

h2o.on_nth_tick(UPDATE_RATE, function()
    for _, player in pairs(game.connected_players) do
        local character = player.character
        if not character then goto continue end
        local surface = player.surface
        local surface_name = surface.name

        local is_maraxsis = surface_name == h2o.MARAXSIS_SURFACE_NAME
        local is_trench = surface_name == h2o.TRENCH_SURFACE_NAME
        if not is_maraxsis and not is_trench then
            goto continue
        end

        local vehicle = player.vehicle
        if vehicle and SUBMARINES[vehicle.name] then
            global.breath[player.index] = nil
            goto continue
        end

        local breath = global.breath[player.index] or FULL_BREATH_NUM_TICKS
        local breath_loss = UPDATE_RATE
        if is_trench then breath_loss = breath_loss * 4 end
        breath = math.max(0, breath - UPDATE_RATE)
        global.breath[player.index] = breath

        if breath <= WARNING_MESSAGE then
            player.print({'maraxsis.drowning'}, {
                skip = defines.print_skip.if_visible
            })
        end

        if breath > 0 then
            goto continue
        end

        local true_damage = character.health - character.prototype.max_health * 0.1
        if true_damage <= 0 then
            character.die('neutral')
        else
            character.health = true_damage
        end

        ::continue::
    end
end)

h2o.on_event({
    defines.events.on_player_changed_surface,
    defines.events.on_player_respawned,
    defines.events.on_player_died
}, function(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end
    global.breath[player.index] = nil
end)
