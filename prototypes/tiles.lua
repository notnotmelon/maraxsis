local function default_destroyed_dropped_item_trigger()
    return {
        type = "direct",
        action_delivery = {
            type = "instant",
            source_effects = {
                type = "create-trivial-smoke",
                smoke_name = "maraxsis-swimming-bubbles",
                offset_deviation = {{-0.1, -0.1}, {0.1, 0.1}},
            }
        }
    }
end

local layer = 4
local function waterifiy(tile, collision_layers)
    assert(data.raw.tile[tile], "tile not found " .. tile)
    tile = table.deepcopy(data.raw.tile[tile])
    tile.name = tile.name .. "-underwater"
    if collision_layers then tile.collision_mask = {layers = collision_layers} end
    tile.layer = math.min(layer, 255)
    layer = layer + 1
    tile.fluid = tile.fluid or "maraxsis-saline-water"
    tile.map_color = maraxsis.color_combine(tile.map_color or data.raw.tile["water"].map_color, data.raw.tile["deepwater"].map_color, 0.25)
    tile.absorptions_per_second = table.deepcopy(data.raw.tile["water"].absorptions_per_second)
    tile.draw_in_water_layer = true
    tile.walking_speed_modifier = 0.2
    water_tile_type_names[#water_tile_type_names + 1] = tile.name
    data:extend {tile}
    return tile
end

waterifiy("lava-hot", {
    [maraxsis_lava_collision_mask] = true,
    player = true,
    lava_tile = true,
    decal = true,
    doodad = true,
    ground_tile = true,
    item = true,
})
data.raw.tile["lava-hot-underwater"].map_color = maraxsis.color_combine(data.raw.tile["lava-hot"].map_color, data.raw.tile["deepwater"].map_color, 0.6)

-- orange glow on the trench lava is created by lamp entities on a 4x4 tile grid.
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

waterifiy("volcanic-cracks-hot")
waterifiy("volcanic-cracks-warm")
waterifiy("volcanic-folds")
waterifiy("dirt-5")
waterifiy("sand-3")
waterifiy("sand-2")
waterifiy("sand-1")
waterifiy("lowland-cream-red")
waterifiy("lowland-red-vein-2")

data.raw.tile["lowland-cream-red-underwater"].map_color = defines.color.orange
data.raw.tile["lowland-cream-red-underwater"].searchable = true
data.raw.tile["lowland-cream-red-underwater"].collision_mask.layers[maraxsis_coral_collision_mask] = true

data.raw.tile["lowland-red-vein-2-underwater"].map_color = defines.color.firebrick
data.raw.tile["lowland-red-vein-2-underwater"].collision_mask.layers[maraxsis_coral_collision_mask] = true
data.raw.tile["lowland-red-vein-2-underwater"].localised_name = {"tile-name.lowland-cream-red-underwater"}

data:extend {maraxsis.merge(data.raw.tile["out-of-map"], {
    name = "maraxsis-trench-entrance",
    layer = 0,
    layer_group = "zero",
    effect = "maraxsis-trench",
    effect_color = {1, 0, 0},
    effect_color_secondary = {0, 68, 25},
    map_color = {0, 0, 0.1, 1},
    destroys_dropped_items = true,
    default_destroyed_dropped_item_trigger = default_destroyed_dropped_item_trigger(),
    allows_being_covered = false,
    walking_speed_modifier = 0.2,
    collision_mask = {layers = {object = true, item = true, doodad = true, decal = true, [maraxsis_trench_entrance_collision_mask] = true}},
    autoplace = {
        probability_expression = "maraxsis_trench_entrance"
    },
})}
table.insert(out_of_map_tile_type_names, "maraxsis-trench-entrance")

data:extend {maraxsis.merge(data.raw.tile["out-of-map"], {
    name = "maraxsis-trench-out-of-map",
    localised_name = {"tile-name.out-of-map"},
    hidden = true,
    factoriopedia_alternative = "out-of-map",
    effect = "nil",
})}
table.insert(out_of_map_tile_type_names, "maraxsis-trench-out-of-map")

-- https://github.com/notnotmelon/maraxsis/issues/167
data.raw.tile["maraxsis-trench-out-of-map"].collision_mask.layers.trigger_target = true

data:extend {{
    type = "tile-effect",
    name = "maraxsis-trench",
    shader = "space",
    space = {
        star_density = 0,
        nebula_scale = 10,
        nebula_brightness = 0.5
    }
}}
