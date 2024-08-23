local cliff_vectors = {
	['east-to-none'] = {-1, -1},
	['east-to-north'] = {1, -1},
	['east-to-south'] = {-1, -1},
	['east-to-west'] = {0, -1},
	['none-to-east'] = {-1, 1},
	['none-to-north'] = {1, 1},
	['none-to-south'] = {-1, -1},
	['none-to-west'] = {1, -1},
	['north-to-east'] = {-1, 1},
	['north-to-none'] = {-1, 1},
	['north-to-south'] = {-1, -0},
	['north-to-west'] = {-1, -1},
	['south-to-east'] = {1, 1},
	['south-to-none'] = {1, -1},
	['south-to-north'] = {1, 0},
	['south-to-west'] = {1, -1},
	['west-to-east'] = {0, 1},
	['west-to-none'] = {1, 1},
	['west-to-north'] = {1, 1},
	['west-to-south'] = {-1, 1},
}

---cliff graphics only make sense if the cliff has either 1 neighbour or 2 neighbours. this algorithm removes invalid gridspaces
---@param grid table<integer, table<integer, number>>
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
local function remove_0_neighbour_cells_and_3_neighbour_cells(grid, x1, y1, x2, y2)
	for x, row in pairs(grid) do
		for y, _ in pairs(row) do
			local is_outside_scope = x < x1 or x > x2 or y < y1 or y > y2
			if is_outside_scope then goto continue end

			local neighbour_count = 0
			for _, pos in pairs{{-1, 0}, {1, 0}, {0, -1}, {0, 1}} do
				local i, j = pos[1], pos[2]
				if grid[x + i] and grid[x + i][y + j] then
					neighbour_count = neighbour_count + 1
				end
			end
			if neighbour_count > 2 or neighbour_count == 0 then
				grid[x][y] = nil
			end
			::continue::
		end
	end
end

---finds the best dot product between a vector and a set of cliff orientations
---@param vector table<string, number>
---@param options string[]
---@return string
local function find_best_dot_product(vector, options)
	local best
	local best_dot_product
	for _, option in pairs(options) do
		local x, y = table.unpack(cliff_vectors[option])
		local dot_product = vector.x * x + vector.y * y
		if not best_dot_product or dot_product < best_dot_product then
			best = option
			best_dot_product = dot_product
		end
	end
	return best
end

---after performing all calculations, this function spawns cliffs at the calculated positions
---@param planet Planet
---@param grid table<integer, table<integer, number>>
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
local function spawn_cliffs_at_positions(planet, grid, x1, y1, x2, y2)
	local surface = planet:get_surface()

	for x, row in pairs(grid) do
		for y, angle in pairs(row) do
			local is_outside_scope = x < x1 or x > x2 or y < y1 or y > y2
			if is_outside_scope then goto continue end

			local compass = {
				['north'] = grid[x][y - 1],
				['south'] = grid[x][y + 1],
				['west'] = grid[x - 1] and grid[x - 1][y],
				['east'] = grid[x + 1] and grid[x + 1][y],
			}
			local first = next(compass)
			if not first then goto continue end
			local second = next(compass, first)
			second = second or 'none'

			local vector = {x = math.cos(angle), y = math.sin(angle)}
			local orientation = find_best_dot_product(vector, {first .. '-to-' .. second, second .. '-to-' .. first})

			local cliff_name, f = planet:which_cliff_to_use(x * 4, y * 4)
			local cliff = surface.create_entity{
				name = cliff_name,
				position = {x * 4, y * 4},
				cliff_orientation = orientation,
				create_build_effect_smoke = false,
				force = 'neutral',
			}
			if f then f(cliff) end

			::continue::
		end
	end
end

local positions = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {-1, -1}, {1, -1}, {-1, 1}, {1, 1}}
---generates cliffs in a square area
---@param planet Planet
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
function Mapgen.generate_cliffs(planet, x1, y1, x2, y2)
	if not planet.prototype.cliff_thresholds or table_size(planet.prototype.cliff_thresholds) == 0 then return end

	x1 = math.floor(x1 / 4)
	y1 = math.floor(y1 / 4)
	x2 = math.floor(x2 / 4)
	y2 = math.floor(y2 / 4)

	local grid = {}
	for x = x1 - 1, x2 + 1 do
		grid[x] = {}
		for y = y1 - 1, y2 + 1 do
			grid[x][y] = planet:elevation(x * 4, y * 4)
		end
	end

	local cliff_locations = {}

	for x = x1 - 1, x2 + 1 do
		local xx = x * 4 + 2
		for y = y1 - 1, y2 + 1 do
			local yy = y * 4 + 2

			local elevation = grid[x][y]
			if not elevation then goto continue end

			local threshold = 999999
			local threshold_index
			for i, _threshold in pairs(planet.prototype.cliff_thresholds) do
				if elevation < _threshold then
					threshold = _threshold
					threshold_index = i
					break
				end
			end

			if not threshold_index then goto continue end

			for _, pos in pairs(positions) do
				local i, j = pos[1], pos[2]
				local neighbor = grid[x + i] and grid[x + i][y + j]
				if neighbor and neighbor >= threshold then
					local angle
					local is_outside_scope = x < x1 or x > x2 or y < y1 or y > y2
					if is_outside_scope then
						angle = true
					else
						local h = 0.01
						local dx = (planet:elevation(xx + h, yy) - planet:elevation(xx - h, yy)) / (2 * h)
						local dy = (planet:elevation(xx, yy + h) - planet:elevation(xx, yy - h)) / (2 * h)
						angle = math.atan2(dy, dx)
					end

					cliff_locations[threshold_index] = cliff_locations[threshold_index] or {}
					cliff_locations[threshold_index][x] = cliff_locations[threshold_index][x] or {}
					cliff_locations[threshold_index][x][y] = angle
					break
				end
			end
			::continue::
		end
	end

	for _, grid in pairs(cliff_locations) do
		remove_0_neighbour_cells_and_3_neighbour_cells(grid, x1, y1, x2, y2)
		spawn_cliffs_at_positions(planet, grid, x1, y1, x2, y2)
	end
end