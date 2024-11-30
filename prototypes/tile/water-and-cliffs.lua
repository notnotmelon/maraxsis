local collision_mask_util = require "__core__/lualib/collision-mask-util"

local water = {
    type = "simple-entity",
    name = "maraxsis-water-shader",
    localised_name = "Maraxsis water shader", -- dont @ me
    count_as_rock_for_filtered_deconstruction = false,
    icon_size = 64,
    protected_from_tile_building = false,
    remove_decoratives = "false",
    selectable_in_game = false,
    subgroup = data.raw.tile["water"].subgroup,
    flags = {"not-on-map"},
    collision_box = {{-16, -16}, {16, 16}},
    secondary_draw_order = -1,
    collision_mask = {layers = {}},
    render_layer = "light-effect",
    icon = "__maraxsis__/graphics/tile/water/water-combined.png",
    icon_size = 32,
}

local frame_sequence = {}
for k = 1, 32 do
    table.insert(frame_sequence, k)
end
local visiblity = tonumber(settings.startup["maraxsis-water-opacity"].value) / 255
water.animations = {
    tint = {r = visiblity, g = visiblity, b = visiblity, a = 1 / 255},
    height = 256,
    width = 256,
    line_length = 32,
    variation_count = 1,
    filename = "__maraxsis__/graphics/tile/water/water-combined.png",
    frame_count = 32,
    animation_speed = 0.5,
    scale = 4,
    frame_sequence = frame_sequence,
    draw_as_glow = false,
    shift = nil,
    flags = {"no-scale"}
}
data:extend {water}

local layer = 4
local waterifiy = {
    ---creates a copy of a tile prototype that can be used underneath py fancy water
    ---@param tile string
    ---@param include_submarine_exclusion_zone boolean
    ---@return table
    tile = function(tile, include_submarine_exclusion_zone)
        tile = table.deepcopy(data.raw.tile[tile])
        tile.name = tile.name .. "-underwater"
        tile.collision_mask = {layers = {[maraxsis_collision_mask] = true}}
        tile.layer = layer
        tile.fluid = "saline-water"
        ---@diagnostic disable-next-line: param-type-mismatch
        tile.map_color = maraxsis.color_combine(tile.map_color or data.raw.tile["water"].map_color, data.raw.tile["deepwater"].map_color, 0.25)
        tile.absorptions_per_second = table.deepcopy(data.raw.tile["water"].absorptions_per_second)
        tile.draw_in_water_layer = true
        --tile.walking_sound = nil -- TODO: add a swimming sound
        tile.walking_speed_modifier = 0.2
        water_tile_type_names[#water_tile_type_names + 1] = tile.name

        if not include_submarine_exclusion_zone then return {tile} end

        local submarine_exclusion_zone = table.deepcopy(tile)
        submarine_exclusion_zone.layer = layer
        submarine_exclusion_zone.name = tile.name .. "-submarine-exclusion-zone"
        submarine_exclusion_zone.localised_name = {"tile-name." .. tile.name}
        submarine_exclusion_zone.collision_mask = {
            layers = {[maraxsis_collision_mask] = true, ["rail"] = true}
        }
        water_tile_type_names[#water_tile_type_names + 1] = submarine_exclusion_zone.name

        layer = layer + 1
        return {tile, submarine_exclusion_zone}
    end,
    ---@param entity string
    ---@return table
    entity = function(entity)
        local underwater
        for entity_prototype in pairs(defines.prototypes.entity) do
            for _, prototype in pairs(data.raw[entity_prototype] or {}) do
                if prototype.name == entity then
                    underwater = prototype
                    break
                end
            end
        end
        if not underwater then error("entity not found " .. entity) end
        underwater = table.deepcopy(underwater)
        underwater.localised_name = underwater.localised_name or {"entity-name." .. underwater.name}
        underwater.name = underwater.name .. "-underwater"

        underwater.localised_name = underwater.localised_name or {"entity-name." .. underwater.name}
        collision_mask_util.get_mask(underwater)[maraxsis_collision_mask] = nil
        ---@diagnostic disable-next-line: param-type-mismatch
        underwater.map_color = maraxsis.color_combine(underwater.map_color or data.raw.tile["water"].map_color, data.raw.tile["deepwater"].map_color, 0.3)

        return {underwater}
    end,
}

data:extend(waterifiy.tile("sand-1", true))
data:extend(waterifiy.tile("sand-2", true))
data:extend(waterifiy.tile("sand-3", true))
data:extend(waterifiy.tile("dirt-5", true))
data:extend(waterifiy.tile("lowland-cream-red", false))
data.raw.tile["lowland-cream-red-underwater"].map_color = defines.color.orange
data:extend(waterifiy.entity("big-sand-rock"))

local simulations = require("__space-age__.prototypes.factoriopedia-simulations")
local cliff = scaled_cliff {
    mod_name = "__maraxsis__",
    name = "cliff-maraxsis",
    map_color = {144, 119, 87},
    suffix = "maraxsis",
    subfolder = "maraxsis",
    scale = 1.0,
    has_lower_layer = true,
    sprite_size_multiplier = 2,
    factoriopedia_simulation = {
        hide_factoriopedia_gradient = true,
        init = "    game.simulation.camera_position = {0, 2.5}\n    for x = -8, 8, 1 do\n      for y = -3, 4 do\n        game.surfaces[1].set_tiles{{position = {x, y}, name = \"sand-3-underwater\"}}\n      end\n    end\n    for x = -8, 8, 4 do\n      game.surfaces[1].create_entity{name = \"cliff-maraxsis\", position = {x, 0}, cliff_orientation = \"west-to-east\"}\n    end\n  ",
        planet = "maraxsis"
    },
}
local function recursively_replace_cliff_shadows_to_vulcanus(cliff_orientations)
    if type(cliff_orientations) ~= "table" then return end

    if cliff_orientations.draw_as_shadow then
        local filename = cliff_orientations.filename
        if filename:match("%-shadow.png") then
            cliff_orientations.filename = filename:gsub("__maraxsis__/graphics/terrain/cliffs/maraxsis/cliff%-maraxsis", "__space-age__/graphics/terrain/cliffs/vulcanus/cliff-vulcanus")
        end
        return
    end

    for k, v in pairs(cliff_orientations) do
        if type(v) == "table" then
            recursively_replace_cliff_shadows_to_vulcanus(v)
        end
    end
end
recursively_replace_cliff_shadows_to_vulcanus(cliff.orientations)
cliff.map_color = maraxsis.color_combine(cliff.map_color, data.raw.tile["deepwater"].map_color, 0.3)
data:extend {cliff}
collision_mask_util.get_mask(cliff)[maraxsis_collision_mask] = nil

local collisionless_cliff = table.deepcopy(cliff)
collisionless_cliff.name = cliff.name .. "-collisionless"
collisionless_cliff.collision_mask = {layers = {}}
collisionless_cliff.created_effect = {
    type = "direct",
    action_delivery = {
        type = "instant",
        source_effects = {
            {
                type = "script",
                effect_id = "maraxsis-cliff-created",
            },
        }
    }
}
collisionless_cliff.hidden = true
data:extend {collisionless_cliff}

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

data:extend {{
    type = "collision-layer",
    name = "decal",
}}

-- add decal layer to decals
for _, decorative in pairs {
    "crater-large",
    "light-mud-decal",
    "vulcanus-dune-decal",
    "pink-lichen-decal",
} do
    decorative = data.raw["optimized-decorative"][decorative]
    if not decorative then error("decorative not found " .. decorative) end
    decorative.collision_mask.layers["decal"] = true
end

-- add doodad layer to doodads
for _, decorative in pairs {
    "crater-small",
    "urchin-cactus",
} do
    decorative = data.raw["optimized-decorative"][decorative]
    if not decorative then error("decorative not found " .. decorative) end
    decorative.collision_mask.layers["decal"] = true
end

data:extend {maraxsis.merge(data.raw.tile["out-of-map"], {
    name = "maraxsis-trench-entrance",
    layer = 0,
    layer_group = "zero",
    effect = "maraxsis-trench",
    effect_color = {1, 0, 0},
    effect_color_secondary = {0, 68, 25},
    map_color = {0, 0, 0.1, 1},
    destroys_dropped_items = true,
    allows_being_covered = false,
    walking_speed_modifier = 0.2,
    collision_mask = {layers = {["item"] = true, ["object"] = true, ["doodad"] = true, ["decal"] = true, [maraxsis_collision_mask] = true}},
    autoplace = {
        probability_expression = "maraxsis_trench_entrance"
    },
})}
table.insert(out_of_map_tile_type_names, "maraxsis-trench-entrance")
