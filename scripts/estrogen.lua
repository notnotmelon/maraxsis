local function apply_estrogen_max_duration(player)
    local c = player.character
    if not c or not c.valid then return end
    local resistance = maraxsis.get_estrogen_resistance(player)
    local max_duration = resistance * maraxsis_constants.ESTROGEN_DURATION
    for _, sticker in pairs(c.stickers) do
        if sticker.name == "maraxsis-estrogen-sticker" or sticker.name == "maraxsis-estrogen-sticker-behind" then
            if sticker.time_to_live > max_duration then
                sticker.time_to_live = max_duration
            end
        end
    end
end

maraxsis.on_event(defines.events.on_script_trigger_effect, function(event)
	local effect_id = event.effect_id
	if effect_id ~= "maraxsis-estrogen-sticker-applied" then return end

    for _, player in pairs(game.players) do
        apply_estrogen_max_duration(player)
    end
end)

maraxsis.on_event({
    defines.events.on_player_armor_inventory_changed,
    defines.events.on_equipment_inserted,
    defines.events.on_equipment_removed,
}, function()
    for _, player in pairs(game.players) do
        apply_estrogen_max_duration(player)
    end
end)
