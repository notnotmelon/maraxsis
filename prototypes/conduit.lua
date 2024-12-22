data:extend {{
    type = "item",
    name = "maraxsis-conduit",
    stack_size = data.raw.item.beacon.stack_size,
    icon = "__maraxsis__/graphics/icons/conduit.png",
    icon_size = 64,
    place_result = "maraxsis-conduit",
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-conduit",
    enabled = false,
    energy_required = 15,
    ingredients = {
        {type = "item", name = "beacon",                           amount = 1},
        {type = "item", name = "maraxsis-glass-panes",             amount = 25},
        {type = "item", name = "processing-unit",                  amount = 25},
        {type = "item", name = "maraxsis-super-sealant-substance", amount = 5},
    },
    results = {
        {type = "item", name = "maraxsis-conduit", amount = 1},
    },
    allow_productivity = false,
    category = "maraxsis-hydro-plant",
    auto_recycle = true,
    surface_conditions = maraxsis.surface_conditions(),
}}

data:extend {{
    type = "technology",
    name = "maraxsis-effect-transmission-2",
    icon = "__maraxsis__/graphics/technology/conduit.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-conduit",
        },
    },
    prerequisites = {"effect-transmission", "maraxsis-project-seadragon"},
    unit = {
        count = 5000,
        ingredients = {
            {"electromagnetic-science-pack", 1},
            {"hydraulic-science-pack",       1},
        },
        time = 60,
    },
    localised_description = {"entity-description.maraxsis-conduit"},
}}

local total = 0
local profile = {}
for i = 1, 5000 do
    total = total + (2 ^ (-i + 1))
    profile[i] = total / i
end

data:extend {maraxsis.merge(data.raw.beacon.beacon, {
    name = "maraxsis-conduit",
    minable = {mining_time = 0.3, result = "maraxsis-conduit"},
    graphics_set = {
        draw_animation_when_idle = false,
        draw_light_when_idle = false,
        reset_animation_when_frozen = true,
        apply_module_tint = "primary",
        animation_list = {
            {
                animation = {
                    layers = {
                        {
                            filename = "__maraxsis__/graphics/entity/conduit/conduit.png",
                            frame_count = 60,
                            line_length = 8,
                            width = 1600 / 8,
                            height = 2320 / 8,
                            scale = 0.5,
                            flags = {"no-scale"},
                            shift = {0, -0.5},
                        },
                        {
                            filename = "__maraxsis__/graphics/entity/conduit/sh.png",
                            repeat_count = 60,
                            width = 600,
                            height = 400,
                            scale = 0.5,
                            draw_as_shadow = true,
                            shift = {0, -0.5},
                        }
                    },
                },
                apply_tint = false,
            },
            {
                animation = {
                    filename = "__maraxsis__/graphics/entity/conduit/emission.png",
                    frame_count = 60,
                    line_length = 8,
                    width = 1600 / 8,
                    height = 2320 / 8,
                    draw_as_glow = true,
                    blend_mode = "additive-soft",
                    scale = 0.5,
                    shift = {0, -0.5},
                },
                apply_tint = true,
            }
        },
        module_tint_mode = "mix",

    },
    animation = "nil",
    base_picture = "nil",
    allowed_effects = {"consumption", "speed", "pollution", "quality"},
    beacon_counter = "same_type",
    energy_usage = "8MW",
    module_slots = 4,
    icons_positioning = {{inventory_index = defines.inventory.beacon_modules, max_icons_per_row = 2, shift = {0, 0.5}}},
    profile = profile,
    icon = "__maraxsis__/graphics/icons/conduit.png",
    icon_size = 64,
    supply_area_distance = 16,
    distribution_effectivity = 0.5,
    distribution_effectivity_bonus_per_quality_level = 0.05
})}
