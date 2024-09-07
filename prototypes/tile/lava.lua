data:extend {
    h2o.merge(data.raw.tile['deepwater'], {
        name = 'lava',
        autoplace = 'nil',
        effect = 'nil',
        effect_color = 'nil',
        effect_color_secondary = 'nil',
        collision_mask = {
            layers = {
                ['resource-layer'] = true,
                ['object'] = true,
                ['item'] = true,
                ['player'] = true,
                ['doodad-layer'] = true,
                [maraxsis_collision_mask] = true
            }
        },
        variants = {
            main =
            {
                {
                    picture = '__maraxsis__/graphics/tile/lava/hr-lava-1.png',
                    count = 8,
                    scale = 0.5,
                    size = 1
                },
                {
                    picture = '__maraxsis__/graphics/tile/lava/hr-lava-2.png',
                    count = 8,
                    scale = 0.5,
                    size = 2
                },
                {
                    picture = '__maraxsis__/graphics/tile/lava/hr-lava-4.png',
                    count = 8,
                    scale = 0.5,
                    size = 4
                }
            },
            empty_transitions = true
        },
        map_color = {r = 255, g = 140, b = 0},
    })
}

water_tile_type_names[#water_tile_type_names + 1] = 'lava'

data:extend {{
    name = 'lava-lamp',
    type = 'lamp',
    localised_name = {'', {'tile-name.lava'}, ' (lamp)'},
    energy_usage_per_tick = '1W',
    energy_source = {type = 'void'},
    picture_on = h2o.empty_image(),
    picture_off = h2o.empty_image(),
    light = {
        type = 'basic',
        intensity = 0.5,
        size = 14,
        color = {1, 0.3, 0},
        always_on = true
    },
    collision_mask = {layers = {}}
}}
