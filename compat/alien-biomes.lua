for _, planet in pairs {"maraxsis", "maraxsis-trench"} do
    planet = data.raw.planet[planet]
    local decoratives = planet.map_gen_settings.autoplace_settings.decorative.settings
    for name in pairs(decoratives) do
        local decorative = data.raw["optimized-decorative"][name]
        if not decorative then
            error("Decorative " .. name .. " not found")
        elseif not decorative.autoplace then
            decoratives[name] = nil
        end
    end
end

if not mods["alien-biomes"] then return end

for _, tile in pairs(data.raw.tile) do
    if tile.name:find("%-underwater") and tile.collision_mask.layers[maraxsis_collision_mask] then
        tile.collision_mask.layers.item = nil
    end
end
