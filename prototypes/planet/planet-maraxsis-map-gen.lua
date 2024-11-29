data:extend {{
    type = "noise-expression",
    name = "maraxsis_starting_area",
    expression = "1000"
}}

data:extend {{
    type = "noise-expression",
    name = "distance_from_0_0",
    expression = "sqrt(x * x + y * y)"
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_elevation_bonus",
    expression = [[
        (1 - distance_from_0_0 / maraxsis_starting_area)
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_moisture",
    expression = [[
        abs(multioctave_noise{
            x = maraxsis_wx(x, y),
            y = maraxsis_wy(x, y),
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
    type = "noise-function",
    name = "maraxsis_wx",
    expression = [[
        xx + multioctave_noise{
            x = xx,
            y = yy,
            persistence = 0.7,
            seed0 = map_seed,
            seed1 = 'maraxsis_wobble_x',
            octaves = 4,
            input_scale = 5 / fulgora_grid,
            output_scale = fulgora_grid * 0.07
        } * maraxsis_wobble_mask(xx, yy) + fulgora_grid / 2
    ]],
    parameters = {"xx", "yy"}
}}
data:extend {{ -- distorted y. Also offset grid so that the starting area is in the middle of a cell
    type = "noise-function",
    name = "maraxsis_wy",
    expression = [[
        yy + multioctave_noise{
            x = xx,
            y = yy,
            persistence = 0.7,
            seed0 = map_seed,
            seed1 = 'maraxsis_wobble_y',
            octaves = 4,
            input_scale = 5 / fulgora_grid,
            output_scale = fulgora_grid * 0.07
        } * maraxsis_wobble_mask(xx, yy) + fulgora_grid / 2
    ]],
    parameters = {"xx", "yy"}
}}

data:extend {{ -- We usually want a lot of wobble or none at all, so wobble_influence has a high output scale and then we clamp it.
    type = "noise-function",
    name = "maraxsis_wobble_mask",
    expression = "clamp(wobble_influence + 0.6, 0, 1)",
    parameters = {"xx", "yy"},
    local_expressions = {
        wobble_influence = [[
            multioctave_noise{
                x = xx,
                y = yy,
                persistence = 0.5,
                seed0 = map_seed,
                seed1 = 1,
                octaves = 3,
                input_scale = 128 / fulgora_grid / 20 ,
                output_scale = 3
            }
        ]]
    }
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_elevation",
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
    type = "noise-expression",
    name = "maraxsis_trench_entrance",
    expression = "maraxsis_elevation < 0.03"
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_coral_reef",
    expression = "(maraxsis_elevation > 0.8) * (maraxsis_elevation < 1.1) * (coral_zones > 0.5) * (coral_beds > 0.8)",
    local_expressions = {
        coral_beds = [[
            multioctave_noise{
                x = x,
                y = y,
                persistence = 0.5,
                seed0 = map_seed,
                seed1 = 1542,
                octaves = 2,
                input_scale = 0.03,
                output_scale = 1
            }
        ]],
        coral_zones = [[
            multioctave_noise{
                x = x,
                y = y,
                persistence = 0.5,
                seed0 = map_seed,
                seed1 = 15442,
                octaves = 2,
                input_scale = 0.01,
                output_scale = 1
            }
        ]],
    }
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_coral_ore",
    expression = "(maraxsis_coral_reef * coral_spots) > 0.8",
    local_expressions = {
        coral_spots = [[
            multioctave_noise{
                x = x,
                y = y,
                persistence = 0.5,
                seed0 = map_seed,
                seed1 = 154,
                octaves = 6,
                input_scale = 128 / 20,
                output_scale = 3
            }
        ]]
    }
}}

for i = 1, table_size(maraxsis.tropical_fish_names) do
    data:extend {{
        type = "noise-expression",
        name = "maraxsis_tropical_fish_" .. i,
        expression = "rand > 0.99999",
        local_expressions = {
            wx = "maraxsis_wx(x, y) + " .. i * 97,
            wy = "maraxsis_wy(x, y) + " .. i * 61,
            seed = "map_seed + " .. i * 100,
            rand = "1 - random_penalty{x = wx, y = wy, seed = seed, source = 1, amplitude = 1}"
        }
    }}
end

data.raw.tile["sand-3-underwater"].autoplace = {
    probability_expression = [[
        maraxsis_elevation > 0.703
    ]],
    order = "a[sand]-a[maraxsis]"
}

data.raw.tile["sand-2-underwater"].autoplace = {
    probability_expression = [[
        maraxsis_elevation > 0.503
    ]],
    order = "a[sand]-b[maraxsis]"
}

data.raw.tile["sand-1-underwater"].autoplace = {
    probability_expression = [[
        maraxsis_elevation > 0.303
    ]],
    order = "a[sand]-c[maraxsis]"
}

data.raw.tile["dirt-5-underwater"].autoplace = {
    probability_expression = [[
        1
    ]],
    order = "a[sand]-d[maraxsis]"
}
