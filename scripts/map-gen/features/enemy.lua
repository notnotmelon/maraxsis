---comment
---@param x number
---@param y number
---@param surface LuaSurface
---@param enemy string
---@param fallback string
Mapgen.spawn_enemy = function(x, y, surface, enemy, fallback)
	if not script.active_mods.pyaliens then
		surface.spill_item_stack({x, y}, {name = fallback or enemy, count = 1}, false)
        return
	end

	surface.create_entity{
		name = enemy,
		position = {x, y}
	}
end