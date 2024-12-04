--trench indestructible wall
local trench_wall = maraxsis.merge(data.raw["simple-entity"]["huge-rock"], {
    name = "maraxsis-trench-wall",
    minable = "nil",
    selectable_in_game = false,
    map_color = {0, 0, 0},
    autoplace = {
        probability_expression = "maraxsis_trench_wall",
    },
    flags = {"placeable-neutral"},
    collision_box = {{-3, -3}, {3, 3}},
    selection_box = {{-3, -3}, {3, 3}},
})

for _, picture in pairs(trench_wall.pictures) do
    picture.tint = {r = 0.2, g = 0.2, b = 0.3}
    picture.scale = 1.2
end

trench_wall.icons = {
    {
        icon = trench_wall.icon,
        tint = {r = 0.2, g = 0.2, b = 0.3},
        icon_size = trench_wall.icon_size,
    }
}
trench_wall.icon = nil
trench_wall.icon_size = nil
trench_wall.collision_mask = {layers = {[maraxsis_trench_entrance_collision_mask] = true, item = true, player = true}}

data:extend {trench_wall}

local trench_wall_collisionless = table.deepcopy(trench_wall)
trench_wall_collisionless.name = "maraxsis-trench-wall-collisionless"
trench_wall_collisionless.collision_mask = {layers = {}}
trench_wall_collisionless.hidden = true
trench_wall_collisionless.localised_name = {"entity-name.maraxsis-trench-wall"}
trench_wall_collisionless.created_effect = {
    type = "direct",
    action_delivery = {
        type = "instant",
        source_effects = {
            {
                type = "script",
                effect_id = "maraxsis-trench-wall-created",
            },
        }
    }
}
data:extend {trench_wall_collisionless}

-- sulfur vent thingy

local maraxsis_chimney = table.deepcopy(data.raw["simple-entity"]["vulcanus-chimney"])
maraxsis_chimney.name = "maraxsis-chimney"
maraxsis_chimney.hidden = true
maraxsis_chimney.localised_name = {"entity-name.vulcanus-chimney"}
data:extend {maraxsis_chimney}

