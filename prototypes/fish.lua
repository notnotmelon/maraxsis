local fish = require 'graphics.entity.fish.fish'

local map_colors = table.deepcopy{
    defines.color.goldenrod,
    defines.color.azure,
    defines.color.yellowgreen,
    defines.color.pink,
    defines.color.orangered,
    defines.color.darkblue,
    defines.color.cyan,
    defines.color.blanchedalmond,
    defines.color.yellow,
    defines.color.aqua,
    defines.color.beige,
    defines.color.orange,
    defines.color.rosybrown,
    defines.color.whitesmoke,
    defines.color.darkcyan
}

local color_budget = 200
for _, color in pairs(map_colors) do
    local sum = color.r + color.g + color.b
    color.r = color.r / sum * color_budget
    color.g = color.g / sum * color_budget
    color.b = color.b / sum * color_budget
    color.a = 255
end

for i, v in pairs(fish) do
    v.filename = '__dihydrogen-monoxide__/graphics/entity/fish/' .. i .. '.png'
    v.direction_count = 32
    v.frame_count = 10
    v.animation_speed = 0.6
    v.scale = 1.25
    v.apply_projection = true
    v = {
        layers = {
            v,
            table.deepcopy(v),
        }
    }
    v.layers[2].draw_as_shadow = true
    v.layers[2].shift.x = v.layers[2].shift.x + 3
    v.layers[2].shift.y = v.layers[2].shift.y + 3.5
    data:extend{{
        localised_name = {'entity-name.fish'},
        type = 'unit',
        name = 'h2o-fish-' .. i,
        render_layer = 'higher-object-under',
        icon = '__dihydrogen-monoxide__/graphics/entity/fish/icons/' .. i .. '.png',
        icon_size = 64,
        icon_mipmaps = nil,
        flags = {'placeable-neutral', 'placeable-off-grid', 'not-repairable', 'breaths-air'},
        max_health = data.raw.fish['fish'].max_health,
        map_color = h2o.color_combine(map_colors[tonumber(i)], data.raw.tile['deepwater'].map_color, 0.25),
        order = 'b-b-a',
        subgroup = 'creatures',
        healing_per_tick = data.raw.fish['fish'].healing_per_tick,
        collision_box = data.raw.fish['fish'].collision_box,
        selection_box = data.raw.fish['fish'].selection_box,
        collision_mask = {},
        vision_distance = 0,
        movement_speed = data.raw.unit['small-biter'].movement_speed * 2,
        distance_per_frame = data.raw.unit['small-biter'].distance_per_frame,
        run_animation = v,
        attack_parameters = {
            type = 'projectile',
            ammo_category = 'melee',
            cooldown = 35,
            range = 0,
            ammo_type = {
                category = 'melee',
                action = {
                    type = 'direct',
                    action_delivery = {
                        type = 'instant',
                        target_effects = {
                            {
                                type = 'damage',
                                damage = {amount = 0, type = 'physical'}
                            }
                        }
                    }
                }
            },
            animation = v,
        },
        water_reflection = data.raw.fish['fish'].water_reflection,
        pollution_to_join_attack = 0,
        distraction_cooldown = 300,
        rotation_speed = 0.1,
        dying_sound = data.raw.fish['fish'].mining_sound,
        has_belt_immunity = true,
        ai_settings = {
            destroy_when_commands_fail = false,
            allow_try_return_to_spawner = false,
            path_resolution_modifier = -2,
            do_separation = false,
        },
        affected_by_tiles = false,
        minable = table.deepcopy(data.raw.fish['fish'].minable),
    }}
end