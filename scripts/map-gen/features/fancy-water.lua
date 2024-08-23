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

	local result = 'py-coastline-shader'
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

---draws py fancy water shaders in an area
---@param planet Planet
---@param chunkpos ChunkPosition
Mapgen.generate_fancy_water = function(planet, noise, chunkpos)
	if not planet:is_fancy_water() then return end
	local surface = planet:get_surface()

	local x1 = chunkpos.x * 32
	local y1 = chunkpos.y * 32
	local x2 = x1 + 31
	local y2 = y1 + 31

	if planet.is_fancy_water == 'always' then
		surface.create_entity{
			name = 'py-water-shader-32-1-1',
			position = {x1 + 16, y1 + 16},
			create_build_effect_smoke = false
		}
		return
	end

	local land_squares = {}
	local all_land, all_water = true, true

	local grid = {}
	for x = x1, x2 do
		grid[x] = {}
		for y = y1, y2 do
			noise:set_location(x, y)
			grid[x][y] = planet:is_fancy_water(noise, x, y)
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
		surface.create_entity{
			name = 'py-water-shader-32-1-1',
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
				--one_expanded_grid[x][y] = planet:is_fancy_water(noisefield[x][y], x, y)
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
						surface.create_entity{
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
			local name = 'py-water-shader-' .. size .. '-' .. math.floor((x % 32)/size) + 1 .. '-' .. math.floor((y % 32)/size) + 1
			surface.create_entity{
				name = name,
				position = {x, y},
				create_build_effect_smoke = false
			}
		end
	end
end