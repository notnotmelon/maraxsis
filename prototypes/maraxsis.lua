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
    icon = '__maraxsis__/graphics/technology/maraxsis.png',
    icon_size = 256,
    order = 'ce[maraxsis]',
    pollutant_type = 'nil',
    solar_power_in_space = 150,
    --[[autoplace = {
        autoplace_settings = { ---@diagnostic disable-next-line: missing-fields
            entity = {treat_missing_as_default = false}, ---@diagnostic disable-next-line: missing-fields
            tile = {treat_missing_as_default = false}, ---@diagnostic disable-next-line: missing-fields
            decorative = {treat_missing_as_default = false},
        }, ---@diagnostic disable-next-line: missing-fields
        cliff_settings = {
            cliff_elevation_0 = 1024
        }
    },--]]
    distance = 15,
    orientation = 0.2,
})}