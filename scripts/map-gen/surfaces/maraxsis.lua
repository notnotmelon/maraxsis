h2o.on_event(defines.events.on_surface_created, function(event)
	local surface = game.get_surface(event.surface_index)
	if surface.name ~= h2o.MARAXSIS_SURFACE_NAME then return end

	surface.show_clouds = true
	surface.brightness_visual_weights = {r = 1, g = 1, b = 1}
	surface.ticks_per_day = 15000
end)

h2o.on_event(defines.events.on_chunk_generated, function(event)
	local surface = event.surface
	local surface_name = surface.name
	if surface_name ~= h2o.MARAXSIS_SURFACE_NAME and surface_name ~= h2o.TRENCH_SURFACE_NAME then return end

	local chunkpos = event.position
	local x = chunkpos.x * 32 + 16
	local y = chunkpos.y * 32 + 16

	local fancy_water = surface.create_entity {
		name = 'h2o-water-shader',
		position = {x, y},
		create_build_effect_smoke = false
	}
	fancy_water.active = false
	fancy_water.destructible = false
	fancy_water.minable = false
end)

local function get_surface()
	local surface = game.surfaces[h2o.MARAXSIS_SURFACE_NAME]

	return surface
end

return {
	type = 'maraxsis',
	get_surface = get_surface,
}
