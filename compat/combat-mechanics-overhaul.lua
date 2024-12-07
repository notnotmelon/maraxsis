if not mods["combat-mechanics-overhaul"] then return end

for _, tile in pairs(data.raw.tile) do
    if not tile.name:find("%-underwater") then goto continue end
    tile.collision_mask.layers.item = nil
    ::continue::
end