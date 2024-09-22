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
    type = 'noise-function',
    name = 'maraxsis_elevation_bonus',
    parameters = {'distance_from_0_0'},
    expression = [[
        (1 - maraxsis_distance_from_0_0 / maraxsis_starting_area)
    ]]
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_moisture',
    expression = [[
        abs(multioctave_noise{
            x = x,
            y = y,
            persistence = 0.25,
            seed0 = map_seed,
            seed1 = 1,
            octaves = 3,
            input_scale = 1/1300,
            output_scale = 1
        })
  ]]
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_elevation',
    expression = [[
        if(
            maraxsis_distance_from_0_0 < maraxsis_starting_area,
            maraxsis_moisture + maraxsis_elevation_bonus(maraxsis_distance_from_0_0),
            min(1, maraxsis_moisture)
        )
    ]],
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_trench_moisture',
    expression = [[
        if(
            maraxsis_distance_from_0_0 < (maraxsis_starting_area + 4),
            cliff_grid_aligned_moisture + maraxsis_elevation_bonus(cliff_grid_aligned_distance_from_0_0),
            min(1, cliff_grid_aligned_moisture)
        )
    ]],
    local_expressions = {
        x4 = 'x - (x % 4)',
        y4 = 'y - (y % 4)',
        cliff_grid_aligned_distance_from_0_0 = 'sqrt(x4 * x4 + y4 * y4)',
        cliff_grid_aligned_moisture = [[
            abs(multioctave_noise{
                x = x4,
                y = y4,
                persistence = 0.25,
                seed0 = map_seed,
                seed1 = 1,
                octaves = 3,
                input_scale = 1/1300,
                output_scale = 1
            })
        ]]
    }
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_trench_entrance',
    expression = 'maraxsis_trench_moisture < 0.07'
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_water_32x32',
    expression = '(x % 32 + y % 32) == 0'
}}

data:extend{{
    type = 'noise-expression',
    name = 'maraxsis_tropical_fish',
    expression = 'random_penalty_between(0, 1, map_seed) > 0.9999'
}}