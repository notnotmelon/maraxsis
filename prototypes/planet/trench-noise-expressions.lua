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

data.raw.tile["lava-hot-underwater"].autoplace = {
    probability_expression = [[
        maraxsis_trench_wall
    ]],
    order = "a[lava]-a[maraxsis]"
}
