local noise = require 'noise'
local tne = noise.to_noise_expression

local transforms = {}

transforms.rotate_x = function(x, y, tile, map)
	local sin = py.get_noise_constant(2)
	local cos = py.get_noise_constant(3)

	return 2 * (x * cos - y * sin)
end

transforms.rotate_y = function(x, y, tile, map)
	local sin = py.get_noise_constant(2)
	local cos = py.get_noise_constant(3)

	return 2 * (y * cos - x * sin)
end

local seed = 12322
transforms.noise_strech_x = function(x, y, tile, map)
	seed = seed + 4461
	local shiftx_1 = tne(py.basis_noise(x, y, seed, tne(30)))
	seed = seed + 4461
	local shiftx_2 = tne(py.basis_noise(x, y, seed, tne(15)))

	return x + shiftx_1 + shiftx_2 / 2 * 16
end

transforms.noise_strech_y = function(x, y, tile, map)
	seed = seed + 4461
	local shiftx_1 = tne(py.basis_noise(x, y, seed, tne(30)))
	seed = seed + 4461
	local shiftx_2 = tne(py.basis_noise(x, y, seed, tne(15)))

	return y + shiftx_1 + shiftx_2 / 2 * 16
end

transforms.factorize_x = function(x, y, tile, map)
	local factor = tne(200) * tne(0.03) ^ (1.3 + tne(py.basis_noise(x, y, 774432, tne(256))))
	local powx = tne(py.basis_noise(x, y, 115123, tne(128)))
	local powy = tne(py.basis_noise(x, y, 9271995, tne(128)))
	return x/tne(2.5) + factor * powx + powy * tne(10)
end

transforms.factorize_y = function(x, y, tile, map)
	local factor = tne(200) * tne(0.03) ^ (1.3 + tne(py.basis_noise(x, y, 774432, tne(256))))
	local powx = tne(py.basis_noise(x, y, 115123, tne(128)))
	local powy = tne(py.basis_noise(x, y, 9271995, tne(128)))
	return y/tne(2.5) + factor * powy + powx * tne(10)
end

return transforms