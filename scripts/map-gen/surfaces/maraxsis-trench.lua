local random = math.random
local min = math.min
local max = math.max
local abs = math.abs
local sqrt = math.sqrt

---draws fancy water shaders in an area
---@param surface LuaSurface
---@param noise ?
---@param chunkpos ChunkPosition
local function generate_fancy_water(surface, noise, chunkpos)
	local x = chunkpos.x * 32
	local y = chunkpos.y * 32

	local fancy_water = surface.create_entity {
		name = 'h2o-water-shader-32-1-1',
		position = {x + 16, y + 16},
		create_build_effect_smoke = false
	}
	fancy_water.active = false
	fancy_water.destructible = false
	fancy_water.minable = false
end

local SPAWN_AREA = SPAWN_AREA
local TRENCH_MOVEMENT_FACTOR = h2o.TRENCH_MOVEMENT_FACTOR

local function generate_terrain(surface, noise, x, y)
	local position = {x, y}
	local tile, decorative

	local moisture = abs(noise.moisture + noise.moisture_octave_1 / 4 + noise.moisture_octave_2 / 32)

	local distance_from_0_0 = sqrt(x * x + y * y) / TRENCH_MOVEMENT_FACTOR
	if distance_from_0_0 < SPAWN_AREA then
		moisture = moisture + h2o.elevation_bonus(distance_from_0_0)
	else
		moisture = min(1, moisture)
	end

	if 0.065 < moisture and moisture < 0.077 then
		if x % 3 == 0 and y % 3 == 0 then
			local wall = surface.create_entity {
				name = 'huge-rock-trench-wall',
				position = h2o.randomize_position(position),
				force = 'neutral'
			}
			wall.destructible = false
		end
	end

	if moisture > 0.07 then
		return 'out-of-map'
	end

	if moisture > 0.065 then
		tile = 'dirt-5-underwater-submarine-exclusion-zone'
	else
		tile = 'dirt-5-underwater'
	end

	if noise.lava_master_master > -0.3 then
		local lava_thickness = abs(noise.lava_master) * (moisture / 2) ^ 0.3 * 1.3
		if noise.lava_master_master < 0 then lava_thickness = lava_thickness * (0.3 + noise.lava_master_master) / 0.3 end

		if lava_thickness > 0.15 then
			for _, lava_noise in pairs {noise.lava_river_1, noise.lava_river_2, noise.lava_river_3} do
				if -lava_thickness < lava_noise and lava_noise < lava_thickness then
					tile = h2o.lava_tile(surface, position)
					if -0.3 < noise.rock_1 and noise.rock_1 < 0.3 and random() > 0.9 then
						surface.create_entity {
							name = 'huge-rock',
							position = h2o.randomize_position(position),
							force = 'neutral'
						}
					end
				end
			end
		end
	end

	if not decorative then
		if random() > 0.995 then
			decorative = {name = 'enemy-decal-transparent', amount = 1, position = position}
		else
			local rng = random()
			local decorative_1 = noise.rock_2 + noise.rock_1 / 2
			if rng > 0.995 or (rng > 0.5 and -0.1 < decorative_1 and decorative_1 < 0.1) then
				decorative = {name = 'sand-rock-medium', amount = 1, position = position}
			end
		end
	end

	return tile, decorative
end

local noise_layers = {
	moisture = {zoom = 1300 * TRENCH_MOVEMENT_FACTOR, from_parent = true},
	moisture_octave_1 = {zoom = 256 * TRENCH_MOVEMENT_FACTOR, from_parent = true},
	moisture_octave_2 = {zoom = 32 * TRENCH_MOVEMENT_FACTOR, from_parent = true},
	lava_master_master = {zoom = 500},
	lava_master = {zoom = 256},
	lava_river_1 = {zoom = 40},
	lava_river_2 = {zoom = 40},
	lava_river_3 = {zoom = 40},
	rock_1 = {zoom = 30},
	rock_2 = {zoom = 40},
	decorative_1 = {zoom = 40},
	decorative_2 = {zoom = 40},
	primary_resource_octave_1 = {zoom = 200},
	primary_resource_octave_2 = {zoom = 100},
	primary_resource_octave_3 = {zoom = 30},
}

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

-- uses game.player, call this from the ingame terminal
function teleport_to_maraxsis_trench()
	local player = game.player
	local surface = get_surface()
	player.teleport({0, 0}, surface)
end

return {
	noise_layers = noise_layers,
	get_surface = get_surface,
	parent_type = 'maraxsis',
	type = 'maraxsis-trench',
	generate_terrain = generate_terrain,
	generate_fancy_water = generate_fancy_water
}
