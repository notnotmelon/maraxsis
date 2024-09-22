local planet_map_gen = require('prototypes/planet/planet-map-gen')
local asteroid_util = require('__space-age__.prototypes.planet.asteroid-spawn-definitions')

data:extend {h2o.merge(data.raw.planet.gleba, {
    name = 'maraxsis',
    starting_area = 1,
    surface_properties = {
        ['day-night-cycle'] = 10 * minute,
        ['magnetic-field'] = 25,
        ['solar-power'] = 30,
        pressure = 200000,
        gravity = 20,
    },
    starmap_icon = '__maraxsis__/graphics/planets/maraxsis.png',
    starmap_icon_size = 512,
    icon = '__maraxsis__/graphics/technology/maraxsis.png',
    icon_size = 256,
    order = 'ce[maraxsis]',
    pollutant_type = 'nil',
    solar_power_in_space = 150,
    map_gen_settings = planet_map_gen.maraxsis(),
    distance = 15,
    orientation = 0.95,
})}


data:extend {{
    type = 'space-connection',
    name = 'vulcanus-maraxsis',
    subgroup = 'planet-connections',
    from = 'vulcanus',
    to = 'maraxsis',
    order = 'f',
    length = 20000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_aquilo)
}}