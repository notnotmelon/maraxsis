data:extend {{
    name = "maraxsis-lava-lamp",
    type = "simple-entity",
    localised_name = {"", {"tile-name.lava"}, " (lamp)"},
    hidden = true,
    icon = data.raw.lamp["small-lamp"].icon,
    collision_mask = {layers = {}},
    icon_size = data.raw.lamp["small-lamp"].icon_size,
    picture = {
        filename = "__core__/graphics/light-medium.png",
        scale = 1.4,
        width = 300,
        height = 300,
        tint = {1, 0.3, 0},
        intensity = 0.5,
        draw_as_light = true,
    }
}}
