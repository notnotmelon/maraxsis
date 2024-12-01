require "prototypes.collision-mask"
require "prototypes.swimming"

data.raw["technology"]["maraxsis-promethium-productivity"].unit.ingredients = table.deepcopy(data.raw["technology"]["research-productivity"].unit.ingredients)

data.raw.radar["maraxsis-sonar"].next_upgrade = nil -- fix crash with 5dim

-- alien biomes compatibility
for _, planet in pairs{"maraxsis", "maraxsis-trench"} do
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