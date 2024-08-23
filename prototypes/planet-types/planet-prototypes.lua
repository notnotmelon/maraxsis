require 'scripts.map-gen.cellular-noise'
require 'prototypes.planet-types.planet-prototype'

-- master list of all planets.
-- you must add your planet to this list for the file to be loaded.
-- TODO: add a remote interface
local planet_names = {
    'ocean',
    'trench',
}

---@type table<string, PlanetPrototype>
local planet_prototypes = {}
local unsorted_data = {}
if h2o2.stage == 'control' then
    for _, name in pairs(planet_names) do
        planet_prototypes[name] = PlanetPrototype.new(require('prototypes/planet-types/' .. name))
    end
    return planet_prototypes
elseif h2o2.stage == 'data' then
    for _, name in pairs(planet_names) do
        PlanetPrototype.data_stage_init(require('prototypes/planet-types/' .. name), unsorted_data)
    end
    local extended_data = {}
    for _, item in pairs(unsorted_data) do
        table.insert(extended_data, item)
    end
    data:extend(extended_data)
end
