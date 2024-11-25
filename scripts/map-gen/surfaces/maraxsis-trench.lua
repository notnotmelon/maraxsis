local function get_surface()
	local surface = game.surfaces[h2o.TRENCH_SURFACE_NAME]

	if not surface then
		surface = game.create_surface(h2o.TRENCH_SURFACE_NAME, {
			seed = h2o.prototypes[h2o.MARAXSIS_SURFACE_NAME].get_surface().map_gen_settings.seed,
			autoplace_settings = {
				entity = {
					treat_missing_as_default = false,
					maraxsis_trench_wall = {},
				},
				tile = {
					treat_missing_as_default = false,
				},
				decorative = {
					treat_missing_as_default = false,
				},
			},
			cliff_settings = {
				cliff_elevation_0 = 1024
			}
		})

		surface.daytime = 0.5
		surface.freeze_daytime = true
		surface.show_clouds = false
		surface.brightness_visual_weights = {r = 1, g = 1, b = 1}
		surface.min_brightness = 0
	end

	return surface
end

-- uses game.player, call this from the ingame terminal
function teleport_to_maraxsis_trench()
	local player = game.player
	local surface = get_surface()
	player.teleport({0, 0}, surface)
end

return {
	get_surface = get_surface,
	type = "maraxsis-trench",
}
