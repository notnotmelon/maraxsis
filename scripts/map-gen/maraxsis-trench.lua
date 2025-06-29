maraxsis.on_event(defines.events.on_surface_created, function(event)
	local surface = game.get_surface(event.surface_index)
	if not surface or not surface.valid then return end
	if surface.name ~= maraxsis_constants.TRENCH_SURFACE_NAME then return end
	local parent_surface = game.planets[maraxsis_constants.MARAXSIS_SURFACE_NAME].create_surface()

	surface.daytime = 0.5
	surface.freeze_daytime = true
	surface.show_clouds = false
	surface.brightness_visual_weights = {r = 1, g = 1, b = 1}
	surface.min_brightness = 0
	local mgs = surface.map_gen_settings
	mgs.seed = parent_surface.map_gen_settings.seed
	surface.map_gen_settings = mgs
end)

maraxsis.on_event(defines.events.on_script_trigger_effect, function(event)
	if event.effect_id ~= "maraxsis-trench-wall-created" then return end

	local old_entity = event.target_entity
	local surface = old_entity.surface
	local position = old_entity.position
	local force_index = old_entity.force_index

	old_entity.destroy()
	local new_entity = surface.create_entity {
		name = "maraxsis-trench-wall",
		position = position,
		force = force_index,
		create_build_effect_smoke = false
	}
	new_entity.destructible = false
end)

maraxsis.on_event(defines.events.on_space_platform_changed_state, function(event)
	local platform = event.platform
	local space_location = platform.space_location
	if not space_location then return end
	if space_location.name ~= maraxsis_constants.TRENCH_SURFACE_NAME then return end
	game.print {"maraxsis.invalid-space-platform", platform.name}
	platform.destroy(0)
end)
