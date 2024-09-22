h2o.on_event(defines.events.on_surface_created, function(event)
	local surface = game.get_surface(event.surface_index)
	if surface.name ~= h2o.MARAXSIS_SURFACE_NAME then return end

	surface.show_clouds = true
	surface.brightness_visual_weights = {r = 1, g = 1, b = 1}
	surface.min_brightness = 0.05
	surface.ticks_per_day = 15000
end)

local function get_surface()
	local surface = game.surfaces[h2o.MARAXSIS_SURFACE_NAME]

	return surface
end

return {
	type = 'maraxsis',
	get_surface = get_surface,
}
