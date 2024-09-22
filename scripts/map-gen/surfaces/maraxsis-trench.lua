local random = math.random
local min = math.min
local max = math.max
local abs = math.abs
local sqrt = math.sqrt

h2o.lava_tile = function(surface, position)
	if surface.count_entities_filtered {name = 'lava-lamp', position = position, radius = 1.5, limit = 1} == 0 then
		local light = surface.create_entity {
			name = 'lava-lamp',
			position = position,
			force = 'neutral'
		}
		light.destructible = false
		light.active = false
	end
	return 'lava'
end

h2o.on_event(defines.events.on_surface_created, function(event)
	local surface = game.get_surface(event.surface_index)
	if surface.name ~= h2o.TRENCH_SURFACE_NAME then return end

	local mgs = surface.map_gen_settings
	mgs.cliff_settings = {
		cliff_elevation_0 = 1024
	}
	surface.map_gen_settings = mgs

	surface.show_clouds = true
	surface.brightness_visual_weights = {r = 1, g = 1, b = 1}
	surface.min_brightness = 0.05
	surface.ticks_per_day = 15000
end)

local function get_surface()
	local surface = game.surfaces[h2o.TRENCH_SURFACE_NAME]

	if not surface then
		surface = game.create_surface(h2o.TRENCH_SURFACE_NAME, {
			seed = game.surfaces['nauvis'].map_gen_settings.seed + 1,
			autoplace_settings = { ---@diagnostic disable-next-line: missing-fields
				entity = {treat_missing_as_default = false}, ---@diagnostic disable-next-line: missing-fields
				tile = {treat_missing_as_default = false}, ---@diagnostic disable-next-line: missing-fields
				decorative = {treat_missing_as_default = false},
			}, ---@diagnostic disable-next-line: missing-fields
			cliff_settings = {
				cliff_elevation_0 = 1024
			}
		})

		local mgs = surface.map_gen_settings
		mgs.autoplace_controls = mgs.autoplace_controls or {}
		local i = 1
		for noise_layer, settings in pairs(noise_layers) do
			mgs.property_expression_names[noise_layer] = 'h2o-' .. noise_layer .. '-maraxsis-trench'
			mgs.autoplace_controls['h2o-autoplace-control-' .. i] = mgs.autoplace_controls['h2o-autoplace-control-' .. i] or {}
			mgs.autoplace_controls['h2o-autoplace-control-' .. i].size = settings.zoom
			i = i + 1
		end
		surface.map_gen_settings = mgs

		surface.daytime = 0.5
		surface.freeze_daytime = true
		surface.show_clouds = false
		surface.brightness_visual_weights = {r = 1, g = 1, b = 1}
		surface.min_brightness = 0
	end

	return surface
end

return {
	noise_layers = noise_layers,
	get_surface = get_surface,
	parent_type = 'maraxsis',
	type = 'maraxsis-trench',
	generate_terrain = generate_terrain,
	generate_fancy_water = generate_fancy_water
}
