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
	mgs.autoplace_controls["h2o-autoplace-control-" .. i] = mgs.autoplace_controls["h2o-autoplace-control-" .. i] or {}
	mgs.autoplace_controls["h2o-autoplace-control-" .. i].richness = data
	surface.map_gen_settings = mgs
end
