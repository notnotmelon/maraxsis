local random = math.random
local min = math.min
local abs = math.abs
local sqrt = math.sqrt
local floor = math.floor

local function perlin(surface, x, y, layer_name)
	local properties = surface.calculate_tile_properties({layer_name}, {{x, y}})
	return properties[layer_name][1] or error('Noise layer ' .. layer_name .. ' is not defined for planet: ' .. tostring(self))
end

SPAWN_AREA = 1000
local SPAWN_AREA = SPAWN_AREA
local SPAWN_AREA_4 = SPAWN_AREA + 4

function h2o.elevation_bonus(distance_from_0_0)
	return (1 - distance_from_0_0 / SPAWN_AREA)
end

local function elevation(surface, x, y)
	local moisture = abs(perlin(surface, x, y, 'moisture') + perlin(surface, x, y, 'moisture_octave_1') / 4)

	local distance_from_0_0 = sqrt(x * x + y * y)
	if distance_from_0_0 < SPAWN_AREA then
		return moisture + h2o.elevation_bonus(distance_from_0_0)
	end
	return min(1, moisture)
end

---returns cliff generation information
---@param surface LuaSurface
---@param x integer
---@param y integer
---@return string, boolean, function?
local function which_cliff_to_use(surface, x, y)
	local trench_noise = elevation(surface, x, y)
	if trench_noise < 0.07 then
		return 'cliff-underwater', function(cliff)
			local cliff_transition = surface.create_entity {
				name = 'dirt-5-trench-' .. cliff.cliff_orientation,
				position = {x + 2, y + 2},
				create_build_effect_smoke = false,
				force = 'neutral',
			}
			cliff_transition.graphics_variation = cliff.graphics_variation

			cliff.destructible = false
			cliff.minable = false
			cliff.active = false
			cliff_transition.destructible = false
			cliff_transition.minable = false
			cliff_transition.active = false
		end
	end

	return 'cliff-underwater'
end

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

local function generate_terrain(surface, noise, x, y)
	local position = {x, y}
	local tile, decorative

	local moisture = abs(noise.moisture + noise.moisture_octave_1 / 4 + noise.moisture_octave_2 / 32)

	local distance_from_0_0 = sqrt(x * x + y * y)
	if distance_from_0_0 < SPAWN_AREA then
		local elevation_bonus = (SPAWN_AREA - min(distance_from_0_0, SPAWN_AREA)) / SPAWN_AREA
		moisture = moisture + elevation_bonus
	else
		moisture = min(1, moisture)
	end
	
	local x4, y4 = floor(x / 4) * 4, floor(y / 4) * 4
	local trench_moisture = abs(noise:get_at('moisture', x4, y4) + noise:get_at('moisture_octave_1', x4, y4) / 4)

	if distance_from_0_0 < SPAWN_AREA_4 then
		local distance_from_0_0 = sqrt(x4 * x4 + y4 * y4)
		trench_moisture = trench_moisture + h2o.elevation_bonus(distance_from_0_0)
	else
		trench_moisture = min(1, trench_moisture)
	end

	if trench_moisture < 0.07 then
		tile = 'trench-entrance'
		return tile
	end

	if moisture > 0.5 then
		tile = 'sand-1-underwater'
	else
		tile = 'dirt-5-underwater'
	end

	local rock_noise = noise.rocks + noise.rocks_2 / 4
	if rock_noise > 0.85 then
		if random() > 0.6 then
			if surface.count_entities_filtered {name = 'big-sand-rock-underwater', position = position, radius = 2, limit = 1} == 0 then
				if rock_noise > 0.9 then
					surface.create_entity {
						name = 'big-sand-rock-underwater',
						position = h2o.randomize_position(position),
						force = 'neutral'
					}
				end
			end
		elseif random() > 0.5 then
			decorative = {name = random() > 0.5 and 'sand-rock-small' or 'sand-rock-medium', amount = 1, position = position}
		end
	end

	if not decorative and random() > 0.7 then
		local brown_asterisk = noise.brown_asterisk + noise.brown_asterisk / 4
		if -0.2 < brown_asterisk and brown_asterisk < 0.2 and noise.brown_asterisk_2 > 0.5 then
			decorative = {name = 'brown-asterisk', amount = random(2, 6), position = position}
		end
	end

	if not decorative then
		if random() > 0.94 then
			decorative = {name = 'light-mud-decal', amount = 1, position = position}
		elseif random() > 0.995 then
			decorative = {name = 'sand-decal', amount = 1, position = position}
		end
	end

	if random() > 0.9999 then
		surface.create_entity {
			name = 'h2o-tropical-fish-' .. random(1, 15),
			position = position,
			force = 'neutral'
		}
	end

	if not decorative then
		if random() > 0.97 then
			decorative = {name = 'light-mud-decal', amount = 1, position = position}
		elseif random() > 0.998 then
			decorative = {name = 'sand-decal', amount = 1, position = position}
		else
			local shrub = noise.shrub
			if shrub > -0.2 and shrub < 0.2 and noise.shrub_2 > 0.5 then
				decorative = {name = 'red-pita', amount = 1, position = position}
			end
		end
	end

	return tile, decorative
end

local noise_layers = {
	moisture = {zoom = 1300},
	moisture_octave_1 = {zoom = 256},
	moisture_octave_2 = {zoom = 32},
	rocks = {zoom = 100},
	rocks_2 = {zoom = 15},
	shrub = {zoom = 32},
	shrub_2 = {zoom = 32},
	brown_asterisk = {zoom = 100},
	brown_asterisk_2 = {zoom = 16},
}

local function get_surface()
	local surface = game.surfaces[h2o.MARAXSIS_SURFACE_NAME]

	if not surface then
		surface = game.create_surface(h2o.MARAXSIS_SURFACE_NAME, {
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
			mgs.property_expression_names[noise_layer] = 'h2o-' .. noise_layer .. '-maraxsis'
			mgs.autoplace_controls['h2o-autoplace-control-' .. i] = mgs.autoplace_controls['h2o-autoplace-control-' .. i] or {}
			mgs.autoplace_controls['h2o-autoplace-control-' .. i].size = settings.zoom
			i = i + 1
		end
		surface.map_gen_settings = mgs

		surface.show_clouds = true
		surface.brightness_visual_weights = {r = 1, g = 1, b = 1}
		surface.min_brightness = 0.05
		surface.ticks_per_day = 15000
	end

	return surface
end

local cliff_thresholds = {0.07, 0.11, 0.15, 0.2, 0.24, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.1}
table.sort(cliff_thresholds)

-- uses game.player, call this from the ingame terminal
function teleport_to_maraxsis()
	local player = game.player
	local surface = get_surface()
	player.teleport({0, 0}, surface)
end

return {
	generate_terrain = generate_terrain,
	is_fancy_water = is_fancy_water,
	elevation = elevation,
	which_cliff_to_use = which_cliff_to_use,
	noise_layers = noise_layers,
	type = 'maraxsis',
	get_surface = get_surface,
	generate_fancy_water = generate_fancy_water,
	cliff_thresholds = cliff_thresholds,
}
