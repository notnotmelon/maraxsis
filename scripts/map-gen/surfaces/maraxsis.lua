maraxsis.on_event(defines.events.on_chunk_generated, function(event)
	local surface = event.surface
	local surface_name = surface.name
	if surface_name ~= maraxsis.MARAXSIS_SURFACE_NAME and surface_name ~= maraxsis.TRENCH_SURFACE_NAME then return end

	local chunkpos = event.position
	local x = chunkpos.x * 32 + 16
	local y = chunkpos.y * 32 + 16

	local fancy_water = surface.create_entity {
		name = "maraxsis-water-shader",
		position = {x, y},
		create_build_effect_smoke = false
	}
	fancy_water.active = false
	fancy_water.destructible = false
	fancy_water.minable = false
end)

local function get_surface()
	return game.planets[maraxsis.MARAXSIS_SURFACE_NAME].create_surface()
end

maraxsis.on_event(defines.events.on_script_trigger_effect, function(event)
	if event.effect_id ~= "maraxsis-cliff-created" then return end

	local old_cliff = event.target_entity
	local surface = old_cliff.surface
	local position = old_cliff.position
	local force_index = old_cliff.force_index
	local cliff_orientation = old_cliff.cliff_orientation

	old_cliff.destroy()
	local new_cliff = surface.create_entity {
		name = "cliff-maraxsis",
		position = position,
		cliff_orientation = cliff_orientation,
		force = force_index,
		create_build_effect_smoke = false
	}
end)

return {
	type = "maraxsis",
	get_surface = get_surface,
}
