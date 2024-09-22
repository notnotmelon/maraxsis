data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_starting_area',
    expression = '1000'
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_distance_from_0_0',
    expression = 'sqrt(x * x + y * y)'
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_elevation_bonus',
    expression = [[
        (1 - maraxsis_distance_from_0_0 / maraxsis_starting_area)
    ]]
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_moisture',
    expression = [[
        abs(multioctave_noise{x = x,
            y = y,
            persistence = 0.25,
            seed0 = map_seed,
            seed1 = 1,
            octaves = 3,
            input_scale = 1300,
            output_scale = 1})
  ]]
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_elevation',
    expression = [[
        100 * if(
            maraxsis_distance_from_0_0 < maraxsis_starting_area,
            maraxsis_moisture + maraxsis_elevation_bonus,
            min(1, maraxsis_moisture)
        )
    ]]
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_water_32x32',
    expression = '(x % 32 + y % 32) == 0'
}}
