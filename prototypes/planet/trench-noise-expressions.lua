local TRENCH_MOVEMENT_FACTOR = maraxsis.TRENCH_MOVEMENT_FACTOR

data:extend {{
    type = "noise-expression",
    name = "maraxsis_trench_elevation",
    expression = [[
        maraxsis_elevation(x /]] .. TRENCH_MOVEMENT_FACTOR .. [[, y /]] .. TRENCH_MOVEMENT_FACTOR .. [[)
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_trench_wall",
    expression = [[
        maraxsis_trench_elevation < 0.03
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_lava_master",
    expression = [[
        multioctave_noise{
            x = x,
            y = y,
            persistence = 0.5,
            seed0 = map_seed,
            seed1 = 1344,
            octaves = 1,
            input_scale = 1/250,
            output_scale = 1
        }
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_lava_master_master",
    expression = [[
        multioctave_noise{
            x = x,
            y = y,
            persistence = 0.5,
            seed0 = map_seed,
            seed1 = 1344,
            octaves = 1,
            input_scale = 1/500,
            output_scale = 1
        }
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_lava_river_1",
    expression = [[
        multioctave_noise{
            x = x,
            y = y,
            persistence = 0.5,
            seed0 = map_seed,
            seed1 = 13442,
            octaves = 2,
            input_scale = 1/40,
            output_scale = 1
        }
    ]]
}}

data:extend {{
    type = "noise-expression",
    name = "maraxsis_lava_river_2",
    expression = [[
        multioctave_noise{
            x = x,
            y = y,
            persistence = 0.5,
            seed0 = map_seed,
            seed1 = 56443,
            octaves = 2,
            input_scale = 1/40,
            output_scale = 1
        }
    ]]
}}

data:extend{{
    type = "noise-expression",
    name = "maraxsis_lava_thickness",
    expression = [[
        min(if (
            maraxsis_lava_master_master < 0,
            lava_thickness * (0.3 + maraxsis_lava_master_master) / 0.3,
            lava_thickness
        ), 0.5)
    ]],
    local_expressions = {
        -- ensure there is always a land bridge through the center
        lava_thickness = [[
            abs(maraxsis_lava_master) * (abs(maraxsis_trench_elevation) ^ 0.3) * 1.2
        ]],
        normalized_elevation = [[
            abs(maraxsis_trench_elevation) / 0.03
        ]]
    }
}}

data:extend{{
    type = "noise-expression",
    name = "maraxsis_lava_tile",
    expression = [[
        maraxsis_trench_wall *
        (maraxsis_lava_master_master > -0.3) *
        (maraxsis_lava_thickness > 0.15) *
        min(
            ((-maraxsis_lava_thickness < maraxsis_lava_river_1) * (maraxsis_lava_river_1 < maraxsis_lava_thickness)) +
            ((-maraxsis_lava_thickness < maraxsis_lava_river_2) * (maraxsis_lava_river_2 < maraxsis_lava_thickness))
        , 1)
    ]]
}}

data.raw.tile["lava-hot-underwater"].autoplace = {
    probability_expression = "maraxsis_lava_tile",
    order = "a[lava]-a[maraxsis]"
}

data.raw["simple-entity"]["maraxsis-trench-wall-collisionless"].autoplace = {
    probability_expression = [[
        ((y %% 3) == 0) * ((x %% 3) == 0) * (maraxsis_trench_elevation < 0.04) * (maraxsis_trench_elevation >= 0.028)
    ]],
    order = "a[lava]-a[maraxsis]"
}

data.raw.tile["out-of-map"].autoplace = {
    probability_expression = [[
        maraxsis_trench_elevation > 0.03
    ]],
    order = "aa[out-of-map]-a[maraxsis]"
}
