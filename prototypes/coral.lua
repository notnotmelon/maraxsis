local resource_autoplace = require "resource-autoplace"
local sounds = require "__base__.prototypes.entity.sounds"

data:extend {{
    type = "autoplace-control",
    category = "resource",
    name = "maraxsis-coral",
    order = "e-0",
    richness = true
}}

local coral_variants = {}
for i = 1, 3 do
    coral_variants[i] = {
        filename = "__maraxsis__/graphics/icons/coral-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 0.65,
        flags = {"icon"},
    }
end

data:extend {{
    type = "item",
    name = "maraxsis-coral",
    icon = "__maraxsis__/graphics/icons/coral-1.png",
    icon_size = 64,
    pictures = coral_variants,
    stack_size = 50,
    spoil_result = "maraxsis-limestone",
    spoil_ticks = 60 * 60 * 5,
}}


data:extend {{
    type = "resource",
    name = "maraxsis-coral",
    hidden_in_factoriopedia = true,
    icon = "__maraxsis__/graphics/icons/coral-1.png",
    flags = {"placeable-neutral"},
    order = "a-b-x[maraxsis-coral]",
    tree_removal_probability = 0.8,
    tree_removal_max_distance = 32 * 32,
    minable = {
        mining_particle = "copper-ore-particle",
        mining_time = 5,
        results = {
            {type = "item", name = "maraxsis-coral",     amount = 1},
        }
    },
    walking_sound = sounds.ore,
    driving_sound = stone_driving_sound, -- todo
    collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    autoplace = {
        control = "maraxsis-coral",
        default_enabled = false,
        force = "neutral",
        order = "z",
        placement_density = 1,
        probability_expression = "maraxsis_coral_ore",
        richness_expression = "random_penalty(x, y, 9232 + (sqrt(x*x + y*y) / 10), 99, 1000)",
    },
    stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
    stages = {
        sheet = {
            filename = "__base__/graphics/entity/copper-ore/copper-ore.png",
            priority = "extra-high",
            size = 128,
            frame_count = 8,
            variation_count = 8,
            scale = 0.5
        },
    },
    map_color = {255, 20, 147},
    mining_visualisation_tint = {255, 20, 147},
    factoriopedia_simulation = {init = make_resource("maraxsis-coral")}
}}
