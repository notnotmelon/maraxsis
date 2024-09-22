data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_starting_area',
    expression = '1000'
}}

data:extend {{
    type = 'noise-expression',
    name = 'distance_from_0_0',
    expression = 'sqrt(x * x + y * y)'
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_elevation_bonus',
    expression = [[
        (1 - distance_from_0_0 / maraxsis_starting_area)
    ]]
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_moisture',
    expression = [[
        abs(multioctave_noise{
            x = maraxsis_wx,
            y = maraxsis_wy,
            persistence = 0.25,
            seed0 = map_seed,
            seed1 = 1,
            octaves = 2,
            input_scale = 1/1300,
            output_scale = 1
        })
  ]]
}}

data:extend {{ -- distorted x. Also offset grid so that the starting area is in the middle of a cell
    type = 'noise-expression',
    name = 'maraxsis_wx',
    expression = 'fulgora_wx'
}}
data:extend {{ -- distorted y. Also offset grid so that the starting area is in the middle of a cell
    type = 'noise-expression',
    name = 'maraxsis_wy',
    expression = 'fulgora_wy'
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_elevation',
    expression = [[
        1 - (1 - min(1, elevation) + 0.03) ^ 3 + elevation/3
    ]],
    local_expressions = {
        elevation = [[
            if(
                distance_from_0_0 < maraxsis_starting_area,
                maraxsis_moisture + maraxsis_elevation_bonus,
                maraxsis_moisture
            )
        ]]
    }
}}

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_trench_entrance',
    expression = 'maraxsis_elevation < 0.03'
}}

for i = 1, table_size(h2o.tropical_fish_names) do
    data:extend {{
        type = 'noise-expression',
        name = 'maraxsis_tropical_fish_' .. i,
        expression = 'rand > 0.99999',
        local_expressions = {
            wx = 'maraxsis_wx + ' .. i * 97,
            wy = 'maraxsis_wy + ' .. i * 61,
            seed = 'map_seed + ' .. i * 100,
            rand = '1 - random_penalty{x = wx, y = wy, seed = seed, source = 1, amplitude = 1}'
        }
    }}
end

data.raw.tile['sand-1-underwater'].autoplace = {
    probability_expression = [[
        maraxsis_elevation > 0.703
    ]],
    order = 'a[sand]-a[maraxsis]'
}

data.raw.tile['sand-2-underwater'].autoplace = {
    probability_expression = [[
        maraxsis_elevation > 0.503
    ]],
    order = 'a[sand]-b[maraxsis]'
}

data.raw.tile['sand-3-underwater'].autoplace = {
    probability_expression = [[
        maraxsis_elevation > 0.303
    ]],
    order = 'a[sand]-c[maraxsis]'
}

data.raw.tile['dirt-5-underwater'].autoplace = {
    probability_expression = [[
        1
    ]],
    order = 'a[sand]-d[maraxsis]'
}
