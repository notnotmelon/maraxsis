local function get_surface()
	return game.surfaces[maraxsis.TRENCH_SURFACE_NAME]
end

return {
	get_surface = get_surface,
	type = "maraxsis-trench",
}
