local TRENCH_MOVEMENT_FACTOR = h2o.TRENCH_MOVEMENT_FACTOR

data:extend {{
    type = 'noise-expression',
    name = 'maraxsis_trench_wall',
    expression = [[
        maraxsis_trench_entrance
    ]]
}}