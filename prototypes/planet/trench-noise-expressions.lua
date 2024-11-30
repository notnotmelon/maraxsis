local TRENCH_MOVEMENT_FACTOR = maraxsis.TRENCH_MOVEMENT_FACTOR

data:extend {{
    type = "noise-expression",
    name = "maraxsis_trench_wall",
    expression = [[
        maraxsis_trench_entrance
    ]]
}}

data.raw.tile["maraxsis-lava"].autoplace = {
    probability_expression = [[
        maraxsis_elevation > 0.93
    ]],
    order = "a[lava]-a[maraxsis]"
}
