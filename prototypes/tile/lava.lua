data:extend {{
    name = "lava-lamp",
    type = "lamp",
    localised_name = {"", {"tile-name.lava"}, " (lamp)"},
    energy_usage_per_tick = "1W",
    energy_source = {type = "void"},
    picture_on = maraxsis.empty_image(),
    picture_off = maraxsis.empty_image(),
    light = {
        type = "basic",
        intensity = 0.5,
        size = 14,
        color = {1, 0.3, 0},
        always_on = true
    },
    collision_mask = {layers = {}}
}}
