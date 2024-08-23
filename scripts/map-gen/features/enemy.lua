---comment
---@param x number
---@param y number
---@param surface LuaSurface
---@param enemy string
---@param fallback string
Mapgen.spawn_enemy = function(x, y, surface, enemy, fallback)
	surface.create_entity{
		name = enemy,
		position = {x, y}
	}
end