local random = math.random

local function create_surface(self)
	 ---@diagnostic disable-next-line: missing-fields
	local surface = game.create_surface(self.index, {
		seed = self.parent.seed,
		autoplace_settings = { ---@diagnostic disable-next-line: missing-fields
			entity = {treat_missing_as_default = false}, ---@diagnostic disable-next-line: missing-fields
			tile = {treat_missing_as_default = false}, ---@diagnostic disable-next-line: missing-fields
			decorative = {treat_missing_as_default = false},
		}, ---@diagnostic disable-next-line: missing-fields
		cliff_settings = {
			cliff_elevation_0 = 1024
		}
	})

	surface.show_clouds = false
	surface.brightness_visual_weights = {r = 1, g = 1, b = 1}

	self.surface = surface
end

local function generate_terrain(self, noise, x, y)
	local position = {x, y}
	local surface = self.surface
	local tile, decorative

	local moisture = math.abs(noise.moisture + noise.moisture_octave_1 / 4 + noise.moisture_octave_2 / 32)

	if 0.065 < moisture and moisture < 0.077 then
		if x % 3 == 0 and y % 3 == 0 then
			local wall = surface.create_entity{
				name = 'rock-huge-trench-wall',
				position = h2o2.randomize_position(position),
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
		local lava_thickness = math.abs(noise.lava_master) * (moisture / 2) ^ 0.3 * 1.3
		if noise.lava_master_master < 0 then lava_thickness = lava_thickness * (0.3+noise.lava_master_master) / 0.3 end

		if lava_thickness > 0.15 then
			for _, lava_noise in pairs{noise.lava_river_1, noise.lava_river_2, noise.lava_river_3} do
				if -lava_thickness < lava_noise and lava_noise < lava_thickness then
					tile = Mapgen.lava_tile(surface, position)
					if -0.3 < noise.rock_1 and noise.rock_1 < 0.3 and random() > 0.9 then
						surface.create_entity{
							name = 'rock-huge',
							position = h2o2.randomize_position(position),
							force = 'neutral'
						}
					end
				end
			end

			local sum = math.max(0, noise.lava_river_1) + math.max(0, noise.lava_river_2) + math.max(0, noise.lava_river_3)
			if -lava_thickness - 0.05 > sum or sum > lava_thickness + 0.05 and surface.count_entities_filtered{name = {'geothermal-crack-infinite', 'volcanic-pipe-infinite', 'phosphate-rock-02-infinite', 'sulfur-patch-infinite'}, area = {{x - 12, y - 12}, {x + 12, y + 12}}, limit = 1} == 0 then
				Mapgen.create_resource(self, x, y, random() > 0.1 and self.prototype.resources.geothermal or self.prototype.resources.skeleton, 1)
			end
		end
	else
		local primary = noise.primary_resource_octave_1 + noise.primary_resource_octave_2 / 2 + noise.primary_resource_octave_3 / 2
		if primary > 0.95 then
			Mapgen.create_resource(self, x, y, self.prototype.resources.primary, (primary - 0.9) / 0.1)
		elseif primary < 0.8 and noise.bitumen > 0.8 and random() > 0.993 and surface.count_entities_filtered{name = 'bitumen-seep', area = {{x - 12, y - 12}, {x + 12, y + 12}}, limit = 1} == 0 then
			Mapgen.create_resource(self, x, y, self.prototype.resources.bitumen, 1)
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

local function is_fancy_water(self, noise, x, y)
	return 'always'
end

return {create_surface = create_surface, generate_terrain = generate_terrain, is_fancy_water = is_fancy_water}