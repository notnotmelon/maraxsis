local item_sounds = require("__base__.prototypes.item_sounds")

local MAX_PROMETHIUM_QUALITY_RESEARCH_LEVEL = 300

data:extend {{
    type = "technology",
    name = "maraxsis-promethium-quality",
    icons = util.technology_icon_constant_recipe_productivity("__maraxsis__/graphics/technology/promethium-productivity.png"),
    icon_size = 256,
    effects = {
        {
            type = "nothing",
            use_icon_overlay_constant = false,
            effect_description = {"modifier-description.maraxsis-promethium-quality"},
            icons = {
                {
                    icon = "__space-age__/graphics/icons/promethium-science-pack.png",
                    icon_size = 64,
                },
                {
                    icon = "__core__/graphics/icons/technology/effect-constant/effect-constant-recipe-productivity.png",
                    icon_size = 64,
                    scale = 0.5,
                    shift = {0, 0},
                }
            }
        },
    },
    prerequisites = {"promethium-science-pack"},
    unit = {
        count_formula = "1.06^(L-1)*1000 + (L-1)*1000",
        ingredients = {},
        -- note: ingredients are set in data-final-fixes.lua
        time = 120
    },
    max_level = "infinite",
    upgrade = true
}}

data:extend {{
    type = "beacon",
    name = "promethium-quality-hidden-beacon",
    beacon_counter = "same_type",
    allowed_effects = {"quality"},
    module_slots = MAX_PROMETHIUM_QUALITY_RESEARCH_LEVEL,
    hidden = true,
    hidden_in_factoriopedia = true,
    supply_area_distance = 1,
    energy_usage = "1W",
    energy_source = {
        type = "void",
    },
    distribution_effectivity = 1,
    distribution_effectivity_bonus_per_quality_level = 0,
    is_military_target = false,
    quality_indicator_scale = 0,
    max_health = 1,
    alert_when_damaged = false,
    hide_resistances = true,
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{0, 0}, {0, 0}},
    collision_mask = {layers = {}},
    flags = {
        "not-blueprintable",
        "not-deconstructable",
        "not-flammable",
        "no-copy-paste",
        "not-selectable-in-game",
        "not-upgradable",
        "not-repairable",
        "not-on-map",
        "placeable-off-grid",
    },
}}

data:extend {{
    type = "module",
    name = "promethium-quality-hidden-module",
    icon = data.raw.module["quality-module-3"].icon,
    icon_size = data.raw.module["quality-module-3"].icon_size,
    inventory_move_sound = item_sounds.module_inventory_move,
    pick_sound = item_sounds.module_inventory_pickup,
    drop_sound = item_sounds.module_inventory_move,
    stack_size = 50,
    weight = 20 * kg,
    effect = {quality = 1},
    category = "maraxsis-promethium-quality-hidden-module",
    tier = 1,
    hidden = true,
    hidden_in_factoriopedia = true,
}}

data:extend {{
    type = "module-category",
    name = "maraxsis-promethium-quality-hidden-module",
}}

local cryo_plant = data.raw["assembling-machine"]["cryogenic-plant"]
assert(not cryo_plant.created_effect, "cryo_plant.created_effect is defined")
cryo_plant.created_effect = {
    type = "direct",
    action_delivery = {
        type = "instant",
        source_effects = {
            type = "script",
            effect_id = "maraxsis_on_built_cryo_plant"
        }
    }
}
