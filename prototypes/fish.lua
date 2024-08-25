local fish = require 'graphics.entity.fish.fish'

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
        flags = {'placeable-neutral', 'placeable-off-grid', 'not-repairable', 'not-on-map', 'breaths-air'},
        max_health = data.raw.fish['fish'].max_health,
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
                                damage = {amount = 1, type = 'physical'}
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