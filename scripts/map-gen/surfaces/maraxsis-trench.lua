maraxsis.on_event(defines.events.on_surface_created, function(event)
	local surface = game.get_surface(event.surface_index)
	if not surface or not surface.valid then return end
	if surface.name ~= maraxsis.TRENCH_SURFACE_NAME then return	end
	local parent_surface = game.planets[maraxsis.MARAXSIS_SURFACE_NAME].create_surface()

	surface.daytime = 0.5
	surface.freeze_daytime = true
	surface.show_clouds = false
	surface.brightness_visual_weights = {r = 1, g = 1, b = 1}
	surface.min_brightness = 0
	local mgs = surface.map_gen_settings
	mgs.seed = parent_surface.map_gen_settings.seed
	surface.map_gen_settings = mgs
end)

local function get_surface()
	return game.planets[maraxsis.TRENCH_SURFACE_NAME].create_surface()
end

return {
	get_surface = get_surface,
	type = "maraxsis-trench",
}
