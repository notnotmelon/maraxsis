local collision_mask = {'ground-tile', 'rail-layer', 'colliding-with-tiles-only'}

local colors = { -- default sub colors before they are tinted at runtime
    {195, 136, 24},
    {144, 31,  15},
    {14,  94,  146},
    {64,  12,  146},
}

local movement_energy_consumption = {
    1300,
    3000,
    6500,
    12000,
}

data:extend {{
    type = 'item-subgroup',
    name = 'h2o-maraxsis',
    group = 'production',
    order = 'ee',
}}

do
    local i = 1
    local name = 'h2o-submarine'
    local icon = '__dihydrogen-monoxide__/graphics/icons/submarine.png'

    local item = {
        type = 'item',
        name = name,
        icon = icon,
        icon_size = 64,
        icon_mipmaps = nil,
        subgroup = 'h2o-maraxsis',
        order = 'vga',
        place_result = name,
        stack_size = 1,
        flags = {'not-stackable'},
    }

    local item_tagged = {
        type = 'item-with-tags',
        name = name .. '-tagged',
        localised_description = {
            '?',
            {'', '[font=default-bold]', {'item-description.tagged-submarine-warning'}, '[/font]', {'entity-description.' .. name}},
            {'', '[font=default-bold]', {'item-description.tagged-submarine-warning'}, '[/font]'},
        },
        icon = icon,
        icon_size = 64,
        icon_mipmaps = nil,
        subgroup = 'h2o-maraxsis',
        order = 'vgb',
        place_result = name,
        stack_size = 1,
        flags = {'not-stackable'},
    }

    local recipe = {
        type = 'recipe',
        name = name,
        ingredients = {
            {'iron-plate', 100},
        },
        result = name,
        enabled = false,
        energy_required = 10,
        category = 'crafting',
    }

    local lamp_layer = {
        direction_count = 64,
        frame_count = 1,
        repeat_count = 2,
        draw_as_glow = true,
        shift = {x = 0 / 32, y = 45.5 / 32},
        scale = 1,
        stripes = {},
        height = 101,
        width = 248,
    }

    local mask_layer = {
        direction_count = 64,
        frame_count = 1,
        repeat_count = 2,
        ['line_length'] = 11,
        ['lines_per_file'] = 36,
        shift = {x = 8 / 32, y = 15.5 / 32},
        scale = 1,
        filename = '__dihydrogen-monoxide__/graphics/entity/submarine/mask.png',
        height = 225,
        width = 240,
        apply_runtime_tint = true,
        tint = {0.6, 0.6, 0.6},
    }

    local full_body_layer = {
        direction_count = 64,
        ['line_length'] = 11,
        ['lines_per_file'] = 38,
        frame_count = 2,
        shift = {x = 0 / 32, y = 0 / 32},
        scale = 1,
        filename = '__dihydrogen-monoxide__/graphics/entity/submarine/full-body.png',
        height = 212,
        width = 250,
    }

    local shadow_layer = {
        direction_count = 64,
        frame_count = 1,
        ['line_length'] = 8,
        ['lines_per_file'] = 32,
        repeat_count = 2,
        draw_as_shadow = true,
        shift = {6, 6},
        scale = 1,
        filename = '__dihydrogen-monoxide__/graphics/entity/submarine/shadow.png',
        height = 256,
        width = 256,
        shift = {x = 0 / 32, y = 45.5 / 32},
    }

    local lamp_x = 0
    local lamp_y = 0

    for direction = 1, 64 do
        direction = (direction - 17) % 64 + 1
        if direction >= 34 and direction <= 64 then
            table.insert(lamp_layer.stripes, {
                filename = '__dihydrogen-monoxide__/graphics/empty.png',
                width_in_frames = 1,
                height_in_frames = 1,
            })
        else
            table.insert(lamp_layer.stripes, {
                filename = '__dihydrogen-monoxide__/graphics/entity/submarine/light.png',
                width_in_frames = 1,
                height_in_frames = 1,
                x = lamp_x * 248,
                y = lamp_y * 101,
            })
            lamp_x = lamp_x + 1
            if lamp_x == 6 then
                lamp_x = 0
                lamp_y = lamp_y + 1
            end
        end
    end

    local translucent_mask_layer = table.deepcopy(mask_layer)
    translucent_mask_layer.tint = {0.6, 0.6, 0.6, 0.6}

    local translucent_body_layer = table.deepcopy(full_body_layer)
    translucent_body_layer.tint = {1, 1, 1, 0.6}

    local mask_body_layer = table.deepcopy(mask_layer)
    mask_body_layer.tint = colors[i]
    mask_body_layer.apply_runtime_tint = false

    for _, layer in pairs {lamp_layer, mask_layer, shadow_layer, full_body_layer, translucent_body_layer, translucent_mask_layer, mask_body_layer} do
        layer.animation_speed = 1 / 4
        layer.max_advance = 1
    end

    local entity = table.deepcopy(data.raw['spider-vehicle']['spidertron'])
    entity.name = name
    entity.icon = icon
    entity.icon_size = 64
    entity.icon_mipmaps = nil
    entity.torso_bob_speed = 0.4
    entity.minable.result = name .. '-tagged'
    entity.placeable_by = {item = name, count = 1}
    entity.max_health = 3000 * 2 ^ (i - 1)
    entity.collision_box = {{-1.4, -1.4}, {1.4, 1.4}}
    entity.selection_box = {{-1.4, -1.4}, {1.4, 1.4}}
    entity.drawing_box = {{-2.8, -2.8}, {2.8, 2.8}}
    entity.light_animation = nil
    entity.tank_driving = true
    entity.collision_mask = collision_mask
    entity.minimap_representation = {
        filename = '__dihydrogen-monoxide__/graphics/entity/submarine/submarine-map-tag.png',
        flags = {'icon'},
        tint = h2o.tints[i],
        size = {64, 64}
    }
    entity.working_sound = table.deepcopy(data.raw.car.car.working_sound)
    entity.open_sound = nil
    entity.movement_energy_consumption = movement_energy_consumption[i] .. 'kW'
    entity.weight = entity.weight / (i + 1) * 4 * movement_energy_consumption[i] / 800
    entity.burner = {
        type = 'burner',
        fuel_category = 'nuclear',
        effectivity = 1,
        fuel_inventory_size = 2,
        burnt_inventory_size = 2,
    }
    entity.guns = table.deepcopy(data.raw['spider-vehicle']['spidertron'].guns)
    entity.close_sound = nil
    entity.resistances = {
        {type = 'fire',   percent = 100},
        {type = 'impact', percent = 100},
    }
    entity.has_belt_immunity = true
    if i > 1 then entity.immune_to_tree_impacts = true end
    if i > 2 then entity.immune_to_rock_impacts = true end
    entity.immune_to_cliff_impacts = true
    entity.inventory_size = i * 30
    entity.trash_inventory_size = 10
    entity.turret_animation = nil
    entity.friction = 0.005
    entity.rotation_speed = 0.015 * 0.2 * (i / 2 + 0.5)
    entity.spider_engine.legs = {leg = 'h2o-submarine-leg', mount_position = {0, 0.5}, ground_position = {0, -1}, blocking_legs = {}}
    entity.graphics_set.light = {
        {
            color = {
                b = 1,
                g = 1,
                r = 1
            },
            intensity = 0.4,
            minimum_darkness = 0.3,
            size = 25
        },
        {
            color = {
                b = 1,
                g = 1,
                r = 1
            },
            minimum_darkness = 0.3,
            picture = {
                filename = '__core__/graphics/light-cone.png',
                flags = {
                    'light'
                },
                height = 200,
                priority = 'extra-high',
                scale = 2,
                width = 200
            },
            shift = {0, -15.4 * 1.5},
            size = 3,
            intensity = 0.8,
            type = 'oriented'
        }
    }
    entity.graphics_set.animation = {
        direction_count = 64,
        layers = {
            lamp_layer,
            full_body_layer,
            mask_body_layer,
            translucent_mask_layer,
            mask_layer,
            shadow_layer,
        }
    }
    entity.graphics_set.base_animation = nil
    entity.graphics_set.shadow_base_animation = nil
    entity.graphics_set.shadow_animation = nil
    entity.graphics_set.eye_light = nil
    entity.graphics_set.light_positions = nil

    local tech = {
        type = 'technology',
        name = name,
        icon = '__dihydrogen-monoxide__/graphics/technology/maraxsis.png',
        icon_size = 256,
        icon_mipmaps = nil,
        effects = {
            {
                type = 'unlock-recipe',
                recipe = name,
            },
        },
        prerequisites = {},
        unit = {
            count = 100,
            ingredients = {
                {'automation-science-pack', 1},
                {'logistic-science-pack',   1},
                {'chemical-science-pack',   1},
            },
            time = 30,
        },
        order = 'a',
    }

    data:extend {item, item_tagged, recipe, entity, tech}
end

data:extend {{
    type = 'custom-input',
    key_sequence = '',
    linked_game_control = 'toggle-driving',
    name = 'toggle-driving',
}}

local vehicle_leg = table.deepcopy(data.raw['spider-leg']['spidertron-leg-1'])
vehicle_leg.name = 'h2o-submarine-leg'
vehicle_leg.graphics_set = {}
vehicle_leg.collision_mask = collision_mask
vehicle_leg.target_position_randomisation_distance = 0
vehicle_leg.working_sound = nil
vehicle_leg.minimal_step_size = 0
vehicle_leg.part_length = 2
vehicle_leg.movement_based_position_selection_distance = 1.5 -- I have no idea what this does.
vehicle_leg.initial_movement_speed = 1
vehicle_leg.movement_acceleration = 0
vehicle_leg.walking_sound_volume_modifier = 0
vehicle_leg.part_length = 0.1
data:extend {vehicle_leg}
