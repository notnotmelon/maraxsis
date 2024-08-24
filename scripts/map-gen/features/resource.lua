local ore_info = require 'prototypes.ore-info'

local min_resource_strength = 1000000000
h2o.create_resource = function(planet, x, y, resources, strength)
	local num_resources = table_size(resources)
	if num_resources == 0 then return end

	local name, resource
	if num_resources == 1 then
		name, resource = next(resources)
	else
		local _, noise = Cellular.noise(x, y, 80, planet.cellular_noise.resource)
		noise = noise % 1
		for _name, _resource in pairs(resources) do
			if _resource.threshold >= noise then
				name, resource = _name, _resource
				break
			end
		end
	end

	strength = math.max(0, math.min(1, strength))
	if resource.inverted_stages then strength = 1 - strength end
	local info = ore_info[name]
	if not info then error('Could not find ore info for ' .. name .. ' in ore-info.lua\nPlease update the file to contain this ore.') end
	
	local amount
	if resource.infinite then
		amount = min_resource_strength - math.floor((1 - strength) * info.stage_counts)
		name = name .. '-infinite'
	else
		local richness = resource.richness or info
		amount = richness.min + strength * (richness.max - richness.min)
	end
	
	planet:get_surface().create_entity{
		name = name,
		amount = math.max(1, amount),
		position = {x, y}
	}
end