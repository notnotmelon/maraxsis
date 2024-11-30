local regulator = data.raw.roboport["service_station"]

regulator.logistics_connection_distance = 128
regulator.radar_range = 2
regulator.logistics_radius = 20
regulator.construction_radius = 0
regulator.base = nil
regulator.base_patch = nil
regulator.frozen_patch = nil
regulator.door_animation_up = nil
regulator.door_animation_down = nil
regulator.hidden = false
regulator.drawing_box_vertical_extension = 0.5
regulator.base_animation = {
    layers = {
        {
            filename = "__maraxsis__/graphics/entity/regulator/regulator.png",
            priority = "high",
            width = 1680 / 8,
            height = 2320 / 8,
            shift = {0, -0.5},
            frame_count = 60,
            line_length = 8,
            animation_speed = 1,
            scale = 0.5 * 4 / 3,
            flags = {"no-scale"}
        },
        {
            filename = "__maraxsis__/graphics/entity/regulator/sh.png",
            priority = "high",
            width = 400,
            height = 350,
            shift = util.by_pixel(0, -16),
            frame_count = 1,
            line_length = 1,
            repeat_count = 60,
            animation_speed = 1,
            scale = 0.5 * 4 / 3,
            draw_as_shadow = true,
        }
    }
}
regulator.placeable_by = {item = "maraxsis-pressure-dome", count = 1}
regulator.minable = nil
regulator.icon = "__maraxsis__/graphics/icons/regulator.png"
regulator.icon_size = 64

data.raw.recipe["service_station"].hidden = true
data.raw.item["service_station"].hidden = true
data.raw.item["service_station"].place_result = nil