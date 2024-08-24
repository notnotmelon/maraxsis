local random = math.random

local function is_fancy_water(noise, x, y)
	local moisture_land = noise.moisture + noise.moisture_octave_1 / 4 + noise.moisture_octave_2 / 32
	return moisture_land <= 0.95
end

local perlin = function(surface, x, y, layer_name)
	local properties = surface.calculate_tile_properties({layer_name}, {{x, y}})
	return properties[layer_name][1] or error('Noise layer ' .. layer_name .. ' is not defined for planet: ' .. tostring(self))
end

local function elevation(surface, x, y)
	local moisture = perlin(surface, x, y, 'moisture') + perlin(surface, x, y, 'moisture_octave_1') / 4
	return math.abs(moisture)
end

local function which_cliff_to_use(surface, x, y)
	local trench_noise = elevation(surface, x, y)
	if trench_noise < 0.07 then
		return 'cliff-underwater', function(cliff)
			surface.create_entity {
				name = 'dirt-5-trench-' .. cliff.cliff_orientation,
				position = {x + 2, y + 2},
				create_build_effect_smoke = false,
				force = 'neutral',
			}.graphics_variation = cliff.graphics_variation
		end
	end

	return 'cliff-underwater'
end

---comment
---@param grid table<number, table<number, boolean>>
---@param size integer
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@return table<number, table<number, integer>>
local function find_subsquares_of_size(grid, size, x1, y1, x2, y2)
	local results = {}

	for x = x1, x2 - size + 1, size do
		for y = y1, y2 - size + 1, size do
			local is_subsquare = true
			for i = 0, size - 1 do
				for j = 0, size - 1 do
					if not grid[x + i][y + j] then
						is_subsquare = false
						break
					end
				end
				if not is_subsquare then break end
			end
			if is_subsquare then
				results[#results + 1] = {x, y}
				for i = 0, size - 1 do
					for j = 0, size - 1 do
						grid[x + i][y + j] = nil
					end
				end
			end
		end
	end
	return results
end

local X = '-sand'

local O = '-water'
---helps draw the coastline. uses convolution to determine the correct shader to use
---@param grid table<number, table<number, boolean>>
---@param x integer
---@param y integer
---@return string?
local calculate_1x1_shader_name = function(grid, x, y)
	local all_water = grid[x - 1][y - 1] and grid[x][y - 1] and grid[x + 1][y - 1] and grid[x - 1][y] and grid[x + 1][y] and grid[x - 1][y + 1] and grid[x][y + 1] and grid[x + 1][y + 1]
	if all_water then return nil end

	local result = 'h2o-coastline-shader'
	if grid[x - 1][y - 1] then result = result .. O else result = result .. X end
	if grid[x][y - 1] then result = result .. O else result = result .. X end
	if grid[x + 1][y - 1] then result = result .. O else result = result .. X end
	if grid[x - 1][y] then result = result .. O else result = result .. X end
	result = result .. O
	if grid[x + 1][y] then result = result .. O else result = result .. X end
	if grid[x - 1][y + 1] then result = result .. O else result = result .. X end
	if grid[x][y + 1] then result = result .. O else result = result .. X end
	if grid[x + 1][y + 1] then result = result .. O else result = result .. X end

	return result
end

---draws fancy water shaders in an area
---@param surface LuaSurface
---@param noise ?
---@param chunkpos ChunkPosition
local function generate_fancy_water(surface, noise, chunkpos)
	local x1 = chunkpos.x * 32
	local y1 = chunkpos.y * 32
	local x2 = x1 + 31
	local y2 = y1 + 31

	local land_squares = {}
	local all_land, all_water = true, true

	local grid = {}
	for x = x1, x2 do
		grid[x] = {}
		for y = y1, y2 do
			noise:set_location(x, y)
			grid[x][y] = is_fancy_water(noise, x, y)
			if grid[x][y] then
				all_land = false
			else
				all_water = false
				land_squares[#land_squares + 1] = {x, y}
			end
		end
	end

	if all_land then return end
	if all_water then
		surface.create_entity {
			name = 'h2o-water-shader-32-1-1',
			position = {x1 + 16, y1 + 16},
			create_build_effect_smoke = false
		}
		return
	end

	local one_expanded_grid = {}
	for x = x1 - 1, x2 + 1 do
		one_expanded_grid[x] = {}
		for y = y1 - 1, y2 + 1 do
			if x >= x1 and x <= x2 and y >= y1 and y <= y2 then
				one_expanded_grid[x][y] = grid[x][y]
			else
				--one_expanded_grid[x][y] = is_fancy_water(noisefield[x][y], x, y)
				one_expanded_grid[x][y] = false
			end
		end
	end

	local entity_prototypes = game.entity_prototypes
	for _, land_square in pairs(land_squares) do
		local x, y = land_square[1], land_square[2]
		for i = -1, 1 do
			for j = -1, 1 do
				local x = x + i
				local y = y + j
				if grid[x] and grid[x][y] then
					local name = calculate_1x1_shader_name(one_expanded_grid, x, y)
					if name and entity_prototypes[name] then
						surface.create_entity {
							name = name,
							position = {x, y},
							create_build_effect_smoke = false
						}
						grid[x][y] = nil
					end
				end
			end
		end
	end

	for size = 5, 0, -1 do
		size = 2 ^ size
		local subsquares = find_subsquares_of_size(grid, size, x1, y1, x2, y2)
		for _, subsquare in pairs(subsquares) do
			local x, y = subsquare[1], subsquare[2]
			x = x + math.ceil(size / 2)
			y = y + math.ceil(size / 2)
			local name = 'h2o-water-shader-' .. size .. '-' .. math.floor((x % 32) / size) + 1 .. '-' .. math.floor((y % 32) / size) + 1
			surface.create_entity {
				name = name,
				position = {x, y},
				create_build_effect_smoke = false
			}
		end
	end
end

local function generate_terrain(surface, noise, x, y)
	local position = {x, y}
	local tile, decorative

	local moisture = noise.moisture + noise.moisture_octave_1 / 4
	local moisture_land = moisture + noise.moisture_octave_2 / 32
	if moisture_land > 0.95 then
		tile = 'sand-1'
		if moisture_land > 0.98 then
			local sap_noise = noise.sap_tree + noise.sap_tree_2 / 2
			if random() > 0.9 and sap_noise > 0.5 then
				surface.create_entity {
					name = 'sap-tree',
					position = h2o.randomize_position(position),
					force = 'neutral'
				}
				if random() > 0.9 then decorative = {name = 'enemy-decal-transparent', amount = 1, position = position} end
			elseif random() > 0.85 and sap_noise < 0.2 then
				if surface.count_entities_filtered {name = {'rock-huge', 'sand-rock-big'}, position = position, radius = 2, limit = 1} == 0 then
					local rock_noise = noise.rocks
					if rock_noise > 0.8 then
						surface.create_entity {
							name = 'rock-huge',
							position = h2o.randomize_position(position),
							force = 'neutral'
						}
					elseif rock_noise > 0.6 then
						surface.create_entity {
							name = 'sand-rock-big',
							position = h2o.randomize_position(position),
							force = 'neutral'
						}
					end
				end
			end
		end
	elseif moisture_land > 0.94 then
		tile = 'sand-1-underwater-submarine-exclusion-zone'
		if random() > 0.9 then
			decorative = {name = 'muddy-stump-abovewater', amount = 2, position = position}
		end
	else
		local x4, y4 = math.floor(x / 4) * 4, math.floor(y / 4) * 4
		local trench_moisture = noise:get_at('moisture', x4, y4) + noise:get_at('moisture_octave_1', x4, y4) / 4

		if trench_moisture > -0.07 and trench_moisture < 0.07 then
			tile = 'trench-entrance'
			return tile
		end

		if moisture_land > 0.87 then
			tile = 'sand-1-underwater-submarine-exclusion-zone'
		elseif moisture_land > -0.25 and moisture_land < 0.25 then
			tile = 'dirt-5-underwater'
		else
			tile = 'sand-1-underwater'
		end

		local rock_noise = noise.rocks + noise.rocks_2 / 4
		if rock_noise > 0.85 then
			if random() > 0.6 then
				if surface.count_entities_filtered {name = 'sand-rock-big-underwater', position = position, radius = 2, limit = 1} == 0 then
					if rock_noise > 0.9 then
						surface.create_entity {
							name = 'sand-rock-big-underwater',
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

		if random() > 0.99 then
			surface.create_entity {
				name = 'fish',
				position = position,
				force = 'neutral'
			}
		end
	end

	if not decorative and moisture_land > 0.94 then
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
	sap_tree = {zoom = 32},
	sap_tree_2 = {zoom = 16},
	shrub = {zoom = 32},
	shrub_2 = {zoom = 32},
	brown_asterisk = {zoom = 100},
	brown_asterisk_2 = {zoom = 16},
}

local function get_surface()
	local surface = game.surfaces[h2o.MARAXIS_SURFACE_NAME]

	if not surface then
		surface = game.create_surface(h2o.MARAXIS_SURFACE_NAME, {
			seed = game.surfaces['nauvis'].map_gen_settings.seed + 2,
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

		surface.daytime = 0.5
		surface.freeze_daytime = true
		surface.min_brightness = 0
	end

	return surface
end

local cliff_thresholds = {0.07, 0.11, 0.15, 0.2, 0.24, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9}
table.sort(cliff_thresholds)

-- uses game.player, call this from the ingame terminal
function teleport_to_maraxis()
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
