data:extend{h2o.merge(data.raw.planet.gleba, {
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
    order = 'ce[maraxsis]',
    pollutant_type = 'nil',
    solar_power_in_space = 150,
})}