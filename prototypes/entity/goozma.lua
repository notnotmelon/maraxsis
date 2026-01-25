-- BLENDER POST PROCESSING STEPS IN
-- 1. ./spritter spritesheet -m 16 -w 8 -a 10 -l --lossy . .
-- 2. Inner glow. Blending mode normal.
-- 3. Saturation 2

local space_age_sounds = require("__space-age__.prototypes.entity.sounds")

local function goozma_spritesheet(file_name, is_shadow, is_glow, scale, alpha)
    scale = scale * 2
    is_shadow = is_shadow or false
    is_glow = is_glow or false
    local sprite = util.sprite_load(
        "__maraxsis__/graphics/entity/goozma/" .. file_name,
        {
            direction_count = 128,
            dice = 0, -- dicing is incompatible with sprite alpha masking, do not attempt
            draw_as_shadow = is_shadow,
            draw_as_glow = is_glow,
            scale = scale,
            usage = "enemy",
            blend_mode = "normal",
            allow_forced_downscale = true,
            tint = {alpha, alpha, alpha, alpha},
            middle_orientation = 1,
        }
    )
    if file_name == "goozma-body-glow" then
        sprite.filename = "__maraxsis__/graphics/entity/goozma/goozma-body-glow.png"
    elseif file_name == "goozma-head-glow" then
        sprite.filename = "__maraxsis__/graphics/entity/goozma/goozma-body-glow.png"
    elseif file_name == "goozma-head" or file_name == "goozma-head-shadow" then
        sprite.filename = "__maraxsis__/graphics/entity/goozma/goozma-head.png"
    elseif file_name == "goozma-body"or file_name == "goozma-body-shadow" then
        sprite.filename = "__maraxsis__/graphics/entity/goozma/goozma-body.png"
    end
    return sprite
end

local segment_scales = {
    1.09,
    1.27,
    1.36,
    1.36,
    1.36,
    1.36,
    1.33,
    1.30,
    1.37,
    1.52,
    1.52,
    1.40,
    1.41,
    1.28,
    1.28,
    1.17,
    1.10,
    1.08,
    1.08,
    1.09,
    1.20,
    1.20,
    1.10,
    1.10,
    0.99,
    0.99,
    0.99,
    0.87,
    0.87,
    0.97,
    0.87,
    0.97,
    0.99,
    0.87,
    0.87,
    0.87,
    0.87,
    0.77,
    0.77,
    0.65,
    0.64
}

local function make_segment_name(base_name, scale)
    return "maraxsis-" .. base_name .. "-x" .. string.gsub(tostring(scale), "%.", "_")
end

local resistances = {
    {
        type = "explosion",
        percent = 60
    },
    {
        type = "physical",
        percent = 50
    },
    {
        type = "fire",
        percent = 100
    },
    {
        type = "laser",
        percent = 100
    },
    {
        type = "impact",
        percent = 100
    },
    {
        type = "poison",
        percent = 10
    },
    {
        type = "electric",
        decrease = 20,
        percent = 20
    }
}

local function make_goozma_segment_specifications(base_name, segment_scales, scale)
    local specifications = {}
    local num_segments = #segment_scales
    for i = 1,num_segments do
        local segment_scale = segment_scales[i] * scale
        specifications[i] = { segment = make_segment_name(base_name.."-segment", segment_scale) }
    end
    return specifications
end

local created_effect = {
    type = "direct",
    action_delivery = {
        type = "instant",
        source_effects = {
            {
                type = "script",
                effect_id = "maraxsis-goozma-segment-created",
            },
        }
    }
}

local function make_goozma_head(
    base_name,
    order,
    scale,
    damage_multiplier,
    health,
    regen,
    speed_multiplier,
    factoriopedia_simulation,
    sounds,
    render_layer)
    return {
        name = "maraxsis-" .. base_name,
        type = "segmented-unit",
        icon = "__maraxsis__/graphics/icons/" .. base_name .. ".png",
        flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air", "not-repairable"},
        max_health = health,
        factoriopedia_simulation = factoriopedia_simulation,
        order = order,
        subgroup = "enemies",
        resistances = resistances,
        impact_category = "organic",
        healing_per_tick = regen,
        collision_box = {{-3 * scale, -3 * scale}, {3 * scale, 3 * scale}},
        selection_box = {{-3 * scale, -3 * scale}, {3 * scale, 3 * scale}},
        drawing_box_vertical_extension = 4.0 * scale,
        is_military_target = true,
        vision_distance = 64 * scale,
        territory_radius = 4,
        enraged_duration = 30 * 60, -- 30 seconds
        patrolling_speed = 2.0 * speed_multiplier / 60, -- 1.5 tiles per second
        investigating_speed = 4.0 * speed_multiplier / 60, -- 2.25 tiles per second
        attacking_speed = 7.0 * speed_multiplier / 60, -- 3.0 tiles per second
        enraged_speed = 10.0 * speed_multiplier / 60, -- 4.0 tiles per second
        acceleration_rate = 1 * speed_multiplier / 60 / 60, -- 1 tile per second per second
        turn_radius = 26 * scale, -- tiles
        patrolling_turn_radius = 26 * scale, -- tiles
        turn_smoothing = 0.75, -- fraction of the total turning range (based on turning radius)
        roar = sounds.roar,
        roar_probability = sounds.roar_probability,
        hurt_roar = sounds.hurt_roar,
        hurt_thresholds = sounds.hurt_thresholds,
        working_sound = {
            sound = {
                filename = "__space-age__/sound/world/semi-persistent/distant-rumble-2.ogg",
                volume = 1,
                audible_distance_modifier = 0.8
            },
            max_sounds_per_prototype = 1,
            match_volume_to_activity = true
        },
        animation = {
            layers = {
                goozma_spritesheet("goozma-head", false, false, 0.5 * scale * 0.7, 0.7),
                goozma_spritesheet("goozma-head", false, true, 0.5 * scale * 0.7, 1),
                goozma_spritesheet("goozma-head-shadow", true, false, 0.5 * scale * 0.7, 1.0),
                --goozma_spritesheet("goozma-head-glow", false, true, 0.5 * scale * 0.7, 1.0),
            },
        },
        render_layer = "elevated-rail-metal",
        segment_engine = {
            segments = make_goozma_segment_specifications(base_name, segment_scales, scale)
        },
        created_effect = created_effect,
    }
end

local function make_goozma_segment(base_name, scale, damage_multiplier, health, sounds, render_layer)
    return {
        name = make_segment_name(base_name .. "-segment", scale),
        type = "segment",
        localised_name = {"entity-name.maraxsis-goozma-segment", {"entity-name.maraxsis-" .. base_name}},
        hidden = true,
        flags = {"not-repairable", "breaths-air", "not-in-kill-statistics"},
        max_health = health,
        impact_category = "organic",
        resistances = resistances,
        collision_box = {{-3 * scale, -3 * scale}, {3 * scale, 3 * scale}},
        selection_box = {{-3 * scale, -3 * scale}, {3 * scale, 3 * scale}},
        drawing_box_vertical_extension = 4.0 * scale,
        is_military_target = true,
        animation = {
            layers = {
                goozma_spritesheet("goozma-body", false, false, 0.5 * scale, 0.7),
                goozma_spritesheet("goozma-body", false, true, 0.5 * scale, 1),
                goozma_spritesheet("goozma-body-shadow", true, false, 0.5 * scale, 1.0),
                goozma_spritesheet("goozma-body-glow", false, true, 0.5 * scale, 1.0),
            },
        },
        backward_overlap = 4,
        forward_padding = -1 * scale, -- tiles
        backward_padding = -4 * scale, -- tiles
        render_layer = render_layer,
        working_sound = sounds.segment_working_sound,
        created_effect = created_effect,
        --corpse = base_name .. "-corpse"
    }
end

local function make_goozma_segments(base_name, segment_scales, scale, damage_multiplier, health, sounds, render_layer)
    local existing = {}
    local prototypes = {}
    local num_segments = #segment_scales
    for i = 1, num_segments do
        local segment_scale = segment_scales[i] * scale
        if not existing[make_segment_name(base_name .. "-segment", segment_scale)] then
            existing[make_segment_name(base_name .. "-segment", segment_scale)] = true
            table.insert(prototypes, make_goozma_segment(base_name, segment_scale, damage_multiplier, health, sounds, render_layer))
        end
    end
    return prototypes
end

local function make_goozma(
    base_name,
    order,
    scale,
    damage_multiplier,
    health,
    regen,
    speed_multiplier,
    factoriopedia_simulation,
    sounds,
    render_layer)
    data:extend(
        {
            make_goozma_head(
                base_name,
                order,
                scale,
                damage_multiplier,
                health,
                regen,
                speed_multiplier,
                factoriopedia_simulation,
                sounds,
                render_layer
            )
        }
    )
    data:extend(make_goozma_segments(base_name, segment_scales, scale, damage_multiplier, health, sounds, render_layer))
    --data:extend(make_goozma_corpse(base_name, order, scale))
    --data:extend(make_goozma_effects(base_name, order, scale, damage_multiplier))
end

make_goozma(
    "small-goozma",
    "maraxsis-a",
    0.45,
    1,
    100000,
    10,
    1.65,
    nil,
    space_age_sounds.demolisher.small,
    "elevated-lower-object"
)

make_goozma(
    "medium-goozma",
    "maraxsis-b",
    0.66,
    1,
    200000,
    10,
    2.65,
    nil,
    space_age_sounds.demolisher.medium,
    "elevated-object"
)

make_goozma(
    "big-goozma",
    "maraxsis-c",
    1.0,
    1,
    300000,
    10,
    3.65,
    nil,
    space_age_sounds.demolisher.big,
    "elevated-higher-object"
)

make_goozma(
    "behemoth-goozma",
    "maraxsis-d",
    1.5,
    1,
    400000,
    10,
    4.65,
    nil,
    space_age_sounds.demolisher.big,
    "fluid-visualization"
)