data:extend {{
    name = "lava-lamp",
    type = "lamp",
    localised_name = {"", {"tile-name.lava"}, " (lamp)"},
    energy_usage_per_tick = "1W",
    energy_source = {type = "void"},
    light = {
        type = "basic",
        intensity = 0.5,
        size = 14,
        color = {1, 0.3, 0},
        always_on = true
    },
    collision_mask = {layers = {}},
    hidden = true,
}}

local maraxsis_lava = table.deepcopy(data.raw.tile["lava-hot"])

maraxsis_lava.name = "maraxsis-lava"
maraxsis_lava.collision_mask = {
    layers = {
        decal = true,
        doodad = true,
        water_tile = true,
        object = true,
        player = true,
    }
}

data:extend {maraxsis_lava}