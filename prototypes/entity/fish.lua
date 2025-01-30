local fish = require "graphics.entity.fish.fish"

local map_colors = table.deepcopy {
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

local color_budget = 150
for _, color in pairs(map_colors) do
    local sum = color.r + color.g + color.b
    color.r = color.r / sum * color_budget
    color.g = color.g / sum * color_budget
    color.b = color.b / sum * color_budget
    color.a = 255
end

for i, v in pairs(fish) do
    local name = "maraxsis-tropical-fish-" .. i

    v.filename = "__maraxsis__/graphics/entity/fish/" .. i .. ".png"
    v.direction_count = 32
    v.frame_count = 10
    v.animation_speed = 0.4
    v.scale = 1.25
    v.apply_projection = true
    v.flags = {"no-scale"}
    v = {
        layers = {
            v,
            table.deepcopy(v),
        }
    }
    v.layers[2].draw_as_shadow = true
    v.layers[2].shift.x = v.layers[2].shift.x + 3
    v.layers[2].shift.y = v.layers[2].shift.y + 3.5
    data:extend {{
        localised_name = {"entity-name.fish"},
        type = "unit",
        name = name,
        render_layer = "air-entity-info-icon",
        icon = "__maraxsis__/graphics/entity/fish/icons/" .. i .. ".png",
        icon_size = 64,
        subgroup = "creatures",
        order = "c-" .. i,
        flags = {"placeable-neutral", "placeable-off-grid", "not-repairable", "breaths-air"},
        max_health = 200,
        map_color = map_colors[tonumber(i)],
        healing_per_tick = data.raw.fish["fish"].healing_per_tick,
        collision_box = {{0, 0}, {0, 0}},
        selection_box = {{-0.5, -1}, {0.5, 1}},
        collision_mask = {layers = {}},
        autoplace = {
            probability_expression = "maraxsis_tropical_fish_" .. i,
            default_enabled = false
        },
        vision_distance = 0,
        movement_speed = data.raw.unit["small-biter"].movement_speed * 2,
        distance_per_frame = data.raw.unit["small-biter"].distance_per_frame,
        run_animation = v,
        attack_parameters = {
            type = "projectile",
            ammo_category = "melee",
            cooldown = 60,
            range = 0,
            ammo_type = {
                category = "melee",
                action = {
                    type = "direct",
                    action_delivery = {
                        type = "instant",
                        target_effects = {
                            {
                                type = "damage",
                                damage = {amount = 0, type = "physical"}
                            }
                        }
                    }
                }
            },
            animation = v,
        },
        water_reflection = data.raw.fish["fish"].water_reflection,
        absorbtions_to_join_attack = {},
        distraction_cooldown = 300,
        rotation_speed = 0.1,
        dying_sound = data.raw.fish["fish"].mining_sound,
        has_belt_immunity = true,
        ai_settings = {
            destroy_when_commands_fail = false,
            allow_try_return_to_spawner = false,
            path_resolution_modifier = -2,
            do_separation = false,
        },
        affected_by_tiles = false,
        minable = {
            mining_time = data.raw.fish["fish"].minable.mining_time,
            results = {
                {type = "item", name = "maraxsis-tropical-fish", amount = 5},
            }
        }
    }}
end

data:extend {{
    type = "technology",
    name = "maraxsis-piscary",
    icon = "__maraxsis__/graphics/technology/piscary.png",
    icon_size = 256,
    effects = {},
    prerequisites = {"maraxsis-glassworking"},
    research_trigger = {
        type = "craft-item",
        item = "maraxsis-pressure-dome"
    },
    order = "ed[piscary]",
}}

local function add_to_tech(recipe)
    table.insert(data.raw.technology["maraxsis-piscary"].effects, {type = "unlock-recipe", recipe = recipe})
end

add_to_tech("maraxsis-fishing-tower")
add_to_tech("maraxsis-fish-food")

data:extend {{
    type = "recipe",
    name = "maraxsis-carbon",
    enabled = false,
    energy_required = 16,
    ingredients = {
        {type = "item", name = "maraxsis-tropical-fish", amount = 1},
    },
    results = {
        {type = "item", name = "carbon", amount = 32},
    },
    category = "maraxsis-smelting-or-biochamber",
    allow_productivity = true,
    main_product = "carbon",
    icon = "__maraxsis__/graphics/icons/burnt-fish.png",
    icon_size = 64,
    show_amount_in_title = false,
    auto_recycle = false,
    surface_conditions = maraxsis.surface_conditions(),
}}
add_to_tech("maraxsis-carbon")

local tropical_fish_variants = {}
for i, v in pairs(fish) do
    tropical_fish_variants[tonumber(i)] = {
        filename = "__maraxsis__/graphics/entity/fish/icons/" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 2 / 3,
        flags = {"icon"},
    }
end
data:extend {{
    type = "capsule",
    name = "maraxsis-tropical-fish",
    icon = "__maraxsis__/graphics/icons/tropical-fish.png",
    icon_size = 64,
    pictures = tropical_fish_variants,
    stack_size = data.raw.capsule["raw-fish"].stack_size,
    capsule_action = table.deepcopy(data.raw.capsule["raw-fish"].capsule_action),
    spoil_result = "spoilage",
    spoil_ticks = data.raw.capsule["raw-fish"].spoil_ticks,
}}
local dmg = data.raw.capsule["maraxsis-tropical-fish"].capsule_action.attack_parameters.ammo_type.action.action_delivery.target_effects[1].damage
dmg.amount = dmg.amount * 1.5

data:extend {{
    type = "recipe",
    name = "maraxsis-nutrients-from-tropical-fish",
    icon = "__maraxsis__/graphics/icons/nutrients-from-tropical-fish.png",
    icon_size = 64,
    enabled = false,
    energy_required = 2,
    ingredients = {
        {type = "item", name = "maraxsis-tropical-fish", amount = 1},
    },
    results = {
        {type = "item", name = "nutrients", amount = 10},
    },
    auto_recycle = false,
    allow_decomposition = false,
    allow_productivity = true,
    category = "organic",
    subgroup = "nauvis-agriculture",
    order = "g[maraxsis]"
}}

add_to_tech("maraxsis-nutrients-from-tropical-fish")

-- MICROPLASTICS --

local microplastics_variants = {}
for i = 1, 3 do
    microplastics_variants[i] = {
        filename = "__maraxsis__/graphics/icons/microplastics-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 2,
        flags = {"icon"},
    }
end

data:extend {{
    type = "item",
    name = "maraxsis-microplastics",
    icon = "__maraxsis__/graphics/icons/microplastics-1.png",
    icon_size = 64,
    pictures = microplastics_variants,
    stack_size = data.raw.item["plastic-bar"].stack_size / 2,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-microplastics",
    icon = "__maraxsis__/graphics/icons/fish-rendering.png",
    icon_size = 64,
    enabled = false,
    energy_required = 2,
    ingredients = {
        {type = "item", name = "maraxsis-tropical-fish",   amount = 1},
        {type = "item", name = "piercing-rounds-magazine", amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-microplastics", amount = 10},
        {type = "item", name = "jelly",                  amount = 10},
    },
    category = "organic-or-assembling",
    localised_name = {"recipe-name.maraxsis-microplastics"},
    main_product = "maraxsis-microplastics",
    allow_productivity = true,
    auto_recycle = false,
    surface_conditions = maraxsis.surface_conditions(),
}}
add_to_tech("maraxsis-microplastics")

data:extend {{
    type = "recipe-category",
    name = "maraxsis-smelting-or-biochamber",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-smelt-microplastics",
    icon = "__maraxsis__/graphics/icons/microplastics-to-plastic.png",
    icon_size = 64,
    enabled = false,
    energy_required = data.raw.recipe["iron-plate"].energy_required,
    ingredients = {
        {type = "item", name = "maraxsis-microplastics", amount = 3},
    },
    results = {
        {type = "item", name = "plastic-bar", amount = 1},
    },
    category = "smelting",
    allow_productivity = true,
    main_product = "plastic-bar",
    emissions_multiplier = 3,
    auto_recycle = false,
}}
add_to_tech("maraxsis-smelt-microplastics")
