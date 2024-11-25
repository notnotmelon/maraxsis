--trench indestructible wall
local trench_wall = h2o.merge(data.raw["simple-entity"]["huge-rock"], {
    name = "maraxsis-trench-wall",
    minable = "nil",
    selectable_in_game = false,
    map_color = {0, 0, 0},
    render_layer = "higher-object-under",
    autoplace = {
        probability_expression = "maraxsis_trench_wall",
    }
})

for _, picture in pairs(trench_wall.pictures) do
    picture.tint = {r = 0.2, g = 0.2, b = 0.3}
    picture.scale = 1.5
end

data:extend {trench_wall}
