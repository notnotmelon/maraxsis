data:extend {{
    type = "item",
    name = "maraxsis-fish-food",
    icon = "__maraxsis__/graphics/icons/fish-food.png",
    icon_size = 64,
    stack_size = 100,
    plant_result = "maraxsis-fishing-plant",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-fish-food",
    enabled = false,
    energy_required = 3,
    ingredients = {
        {type = "item", name = "maraxsis-tropical-fish", amount = 1},
        {type = "item", name = "sand",          amount = 1},
        {type = "item", name = "maraxsis-coral",         amount = 3},
        {type = "item", name = "plastic-bar",            amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-fish-food", amount = 3}
    },
    allow_productivity = true,
    main_product = "maraxsis-fish-food",
    category = "maraxsis-hydro-plant-or-biochamber"
}}

data:extend {{
    type = "item",
    name = "maraxsis-fishing-tower",
    icon = "__maraxsis__/graphics/icons/fishing-tower.png",
    icon_size = 64,
    stack_size = data.raw.item["agricultural-tower"].stack_size,
    place_result = "maraxsis-fishing-tower"
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-fishing-tower",
    enabled = false,
    energy_required = 3,
    ingredients = {
        {type = "item", name = "agricultural-tower",   amount = 1},
        {type = "item", name = "maraxsis-coral",       amount = 10},
        {type = "item", name = "maraxsis-glass-panes", amount = 10},
    },
    results = {
        {type = "item", name = "maraxsis-fishing-tower", amount = 1}
    },
    allow_productivity = false,
    main_product = "maraxsis-fishing-tower",
    category = "maraxsis-hydro-plant"
}}

local function scale_sprite_recursive(graphics)
    if not graphics then return end
    if type(graphics) ~= "table" then return end
    if graphics.seen_by_scale_sprite_recursive then return end

    graphics.seen_by_scale_sprite_recursive = true

    for _, g in pairs(graphics) do
        scale_sprite_recursive(g)
    end

    if graphics.filename then
        graphics.scale = (graphics.scale or 1) * 4 / 3
        local shift = graphics.shift or {0, 0}
        local x, y = shift.x or shift[1] or 0, shift.y or shift[2] or 0
        graphics.shift = {x * 4 / 3, y * 4 / 3}
    end

    graphics.seen_by_scale_sprite_recursive = nil
end

local fishing_tower = table.deepcopy(data.raw["agricultural-tower"]["agricultural-tower"])

fishing_tower.name = "maraxsis-fishing-tower"
fishing_tower.minable = {mining_time = 0.5, result = "maraxsis-fishing-tower"}
fishing_tower.icon = "__maraxsis__/graphics/icons/fishing-tower.png"
fishing_tower.icon_size = 64
fishing_tower.max_health = 300
fishing_tower.surface_conditions = {{
    property = "pressure",
    min = 200000,
    max = 200000,
}}
fishing_tower.growth_grid_tile_size = 2
fishing_tower.radius = 4
fishing_tower.input_inventory_size = 2
fishing_tower.output_inventory_size = 1
scale_sprite_recursive(fishing_tower.graphics_set)
scale_sprite_recursive(fishing_tower.crane.parts)
fishing_tower.collision_box = {{-1.9, -1.9}, {1.9, 1.9}}
fishing_tower.selection_box = {{-2, -2}, {2, 2}}
fishing_tower.radius_visualisation_picture = {
    filename = "__maraxsis__/graphics/entity/fishing-tower/radius-visualization.png",
    width = 6,
    height = 6,
    priority = "extra-high-no-scale"
}
data:extend {fishing_tower}

data:extend {{
    name = "maraxsis-fishing-plant",
    type = "plant",
    localised_name = {"item-name.maraxsis-fish-food"},
    localised_description = {"item-description.maraxsis-fish-food"},
    growth_ticks = 12000,
    agricultural_tower_tint = {
        primary = defines.color.darkseagreen,
        secondary = defines.color.deepskyblue,
    },
    max_health = 200,
    icon = data.raw.capsule["maraxsis-tropical-fish"].icon,
    icon_size = data.raw.capsule["maraxsis-tropical-fish"].icon_size,
    collision_mask = {layers = {[maraxsis_fishing_tower_collision_mask] = true}},
    collision_box = {{-0.8, -0.8}, {0.8, 0.8}},
    selection_box = {{-1, -1}, {1, 1}},
    selection_priority = 51,
    minable = {
        mining_time = 0.5,
        results = {{type = "item", name = "maraxsis-tropical-fish", amount = 15}},
    },
    mining_sound = sound_variations("__space-age__/sound/mining/axe-mining-jellystem", 5, 0.4),
    mined_sound = sound_variations("__space-age__/sound/mining/mined-jellystem", 6, 0.35),
    impact_category = "tree",
    map_color = {1, 1, 1},
    pictures = {
        filename = "__core__/graphics/empty.png",
        height = 1,
        width = 1,
    },
    hidden = true,
    -- ambient_sounds todo
    created_effect = {
        type = "direct",
        action_delivery = {
            type = "instant",
            source_effects = {
                {
                    type = "script",
                    effect_id = "maraxsis-fishing-plant-created",
                },
            }
        }
    }
}}

local fishing_plant_animation = table.deepcopy(data.raw["sticker"]["jellynut-speed-sticker"].animation)
fishing_plant_animation.shift[2] = fishing_plant_animation.shift[2] - 0.5
fishing_plant_animation = {
    layers = {
        table.deepcopy(fishing_plant_animation),
        table.deepcopy(fishing_plant_animation),
    }
}
fishing_plant_animation.layers[2].draw_as_glow = true
fishing_plant_animation.type = "animation"
fishing_plant_animation.name = "maraxsis-fishing-plant-animation"
data:extend {fishing_plant_animation}

local result_units = {}
local probability = 1 / table_size(maraxsis.TROPICAL_FISH_NAMES)
for _, tropical_fish in pairs(maraxsis.TROPICAL_FISH_NAMES) do
    table.insert(result_units, {
        unit = tropical_fish,
        spawn_points = {{evolution_factor = 0, spawn_weight = probability}}
    })
end

data:extend {{
    name = "maraxsis-fish-spawner",
    type = "unit-spawner",
    max_count_of_owned_units = 5,
    max_friends_around_to_spawn = 8,
    spawning_cooldown = {60 * 10, 60 * 20},
    spawning_radius = 11,
    spawning_spacing = 3,
    max_richness_for_spawn_shift = 0,
    max_spawn_shift = 0,
    call_for_help_radius = 0,
    collision_box = {{-1.9, -1.9}, {1.9, 1.9}},
    selection_box = {{-2, -2}, {2, 2}},
    graphics_set = {},
    result_units = result_units,
    icon = "__maraxsis__/graphics/icons/fishing-tower.png",
    icon_size = 64,
    hidden = true,
    selectable_in_game = false,
    health = 1,
    localised_name = {"entity-name.maraxsis-fishing-tower"},
    localised_description = {"entity-description.maraxsis-fishing-tower"},
    factoriopedia_alternative = "maraxsis-fishing-tower",
    collision_mask = {layers = {}}
}}
