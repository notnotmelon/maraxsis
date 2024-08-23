data:extend{
    py.merge(data.raw.tile['deepwater'], {
        name = 'lava',
        autoplace = 'nil',
        effect = 'nil',
        effect_color = 'nil',
        effect_color_secondary = 'nil',
        collision_mask = {
            'water-tile',
            'resource-layer',
            'item-layer',
            'player-layer',
            'doodad-layer',
            cannot_be_landfilled
        },
        variants = {
            main =
            {
              {
                picture = '__pystellarexpeditiongraphics__/graphics/tile/lava/lava-1.png',
                count = 8,
                size = 1,
                hr_version =
                {
                  picture = '__pystellarexpeditiongraphics__/graphics/tile/lava/hr-lava-1.png',
                  count = 8,
                  scale = 0.5,
                  size = 1
                }
              },
              {
                picture = '__pystellarexpeditiongraphics__/graphics/tile/lava/lava-2.png',
                count = 8,
                size = 2,
                hr_version =
                {
                  picture = '__pystellarexpeditiongraphics__/graphics/tile/lava/hr-lava-2.png',
                  count = 8,
                  scale = 0.5,
                  size = 2
                }
              },
              {
                picture = '__pystellarexpeditiongraphics__/graphics/tile/lava/lava-4.png',
                count = 8,
                size = 4,
                hr_version =
                {
                  picture = '__pystellarexpeditiongraphics__/graphics/tile/lava/hr-lava-4.png',
                  count = 8,
                  scale = 0.5,
                  size = 4
                }
              }
            },
            empty_transitions = true
          },
          map_color={r=255, g=140, b=0},
          pollution_absorption_per_second = 0,
    })
}

water_tile_type_names[#water_tile_type_names+1] = 'lava'

data:extend{{
  name = 'lava-lamp',
  type = 'lamp',
  localised_name = {'', {'tile-name.lava'}, ' (lamp)'},
  energy_usage_per_tick = '1W',
  energy_source = {type = 'void'},
  picture_on = py.empty_image(),
  picture_off = py.empty_image(),
  light = {
      type = 'basic',
      intensity = 0.5,
      size = 14,
      color = {1, 0.3, 0},
      always_on = true
  },
  collision_mask = {}
}}