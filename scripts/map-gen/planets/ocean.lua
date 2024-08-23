local random = math.random

local function create_surface(self)
	---@diagnostic disable-next-line: missing-fields
	local surface = game.create_surface(self.index, {
		seed = self.seed,
		autoplace_settings = { ---@diagnostic disable-next-line: missing-fields
			entity = {treat_missing_as_default = false}, ---@diagnostic disable-next-line: missing-fields
			tile = {treat_missing_as_default = false}, ---@diagnostic disable-next-line: missing-fields
			decorative = {treat_missing_as_default = false},
		}, ---@diagnostic disable-next-line: missing-fields
		cliff_settings = {
			cliff_elevation_0 = 1024
		}
	})

	self.surface = surface
end

local function is_fancy_water(self, noise, x, y)
	local moisture_land = noise.moisture + noise.moisture_octave_1 / 4 + noise.moisture_octave_2 / 32
	return moisture_land <= 0.95
end

local function elevation(self, x, y)
	local moisture = self:perlin(x, y, 'moisture') + self:perlin(x, y, 'moisture_octave_1') / 4
	return math.abs(moisture)
end

local function which_cliff_to_use(self, x, y)
	local trench_noise = self:elevation(x, y)
	if trench_noise < 0.07 then
		return 'cliff-underwater', function(cliff)
			self.surface.create_entity{
				name = 'dirt-5-trench-' .. cliff.cliff_orientation,
				position = {x + 2, y + 2},
				create_build_effect_smoke = false,
				force = 'neutral',
			}.graphics_variation = cliff.graphics_variation
		end
	end

	return 'cliff-underwater'
end

local function generate_terrain(self, noise, x, y)
	local position = {x, y}
	local surface = self.surface
	local tile, decorative

	local moisture = noise.moisture + noise.moisture_octave_1 / 4
	local moisture_land = moisture + noise.moisture_octave_2 / 32
	if moisture_land > 0.95 then
		tile = 'sand-1'
		if moisture_land > 0.98 then
			local sap_noise = noise.sap_tree + noise.sap_tree_2 / 2
			if random() > 0.9 and sap_noise > 0.5 then
				surface.create_entity{
					name = 'sap-tree',
					position = h2o2.randomize_position(position),
					force = 'neutral'
				}
				if random() > 0.9 then decorative = {name = 'enemy-decal-transparent', amount = 1, position = position} end
			elseif random() > 0.85 and sap_noise < 0.2 then
				if surface.count_entities_filtered{name = {'rock-huge', 'sand-rock-big'}, position = position, radius = 2, limit = 1} == 0 then
					local rock_noise = noise.rocks
					if rock_noise > 0.8 then
						surface.create_entity{
							name = 'rock-huge',
							position = h2o2.randomize_position(position),
							force = 'neutral'
						}
					elseif rock_noise > 0.6 then
						surface.create_entity{
							name = 'sand-rock-big',
							position = h2o2.randomize_position(position),
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
				if surface.count_entities_filtered{name = 'sand-rock-big-underwater', position = position, radius = 2, limit = 1} == 0 then
					if rock_noise > 0.9 then
						surface.create_entity{
							name = 'sand-rock-big-underwater',
							position = h2o2.randomize_position(position),
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
			surface.create_entity{
				name = 'seaweed',
				position = position,
				force = 'neutral'
			}
		elseif random() > 0.99 then
			surface.create_entity{
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

return {create_surface = create_surface, generate_terrain = generate_terrain, is_fancy_water = is_fancy_water, elevation = elevation, which_cliff_to_use = which_cliff_to_use}