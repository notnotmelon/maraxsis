local noise = require 'noise'
local tne = noise.to_noise_expression

---Returns a random number generator based on another generator.
---@param generator LuaRandomGenerator
---@return LuaRandomGenerator
h2o.reseed = function(generator)
	return game.create_random_generator(generator(341, 2147483647))
end

---Sets a noise constant which can be accessed inside a named_noise_expression. WARNING: Prone to floating point inaccuracies, don't use this to transfer worldgen seeds.
---@param i integer
---@param surface LuaSurface
---@param data number
h2o.set_noise_constant = function(i, surface, data)
	local mgs = surface.map_gen_settings
	mgs.autoplace_controls = mgs.autoplace_controls or {}
	mgs.autoplace_controls['h2o-autoplace-control-' .. i] = mgs.autoplace_controls['h2o-autoplace-control-' .. i] or {}
	mgs.autoplace_controls['h2o-autoplace-control-' .. i].richness = data
	surface.map_gen_settings = mgs
end

---Data stage only. Gets a noise constant which can be accessed inside a named_noise_expression.
---@param i integer
h2o.get_noise_constant = function(i)
	return noise.get_control_setting('h2o-autoplace-control-' .. i).richness_multiplier
end

---Returns a noise expression which is an approximation of perlin noise. The output ranges from -1.2 to 1.2.
---@param x NoiseExpression
---@param y NoiseExpression
---@param seed integer
---@param zoom number
h2o.basis_noise = function(x, y, seed, zoom)
	return {
		type = 'function-application',
		function_name = 'factorio-basis-noise',
		arguments = {
			x = x,
			y = y,
			seed0 = tne(noise.var('map_seed')),
			seed1 = tne(seed),
			input_scale = tne(0.9999728452) / zoom,
			output_scale = tne(1.2 / 1.7717819213867)
		}
	}
end