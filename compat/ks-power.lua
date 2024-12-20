-- https://github.com/notnotmelon/maraxsis/issues/100

if not mods["KS_Power"] then return end

data.raw["electric-energy-interface"]["wind-turbine-2"].collision_mask.layers[maraxsis_dome_collision_mask] = true
