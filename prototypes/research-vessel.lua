local item_sounds = require("__base__.prototypes.item_sounds")

local function add_to_tech(recipe)
    table.insert(data.raw.technology["maraxsis-research-vessel"].effects, {type = "unlock-recipe", recipe = recipe})
end

local science_pack_colors = {
    ["automation-science-pack"] = {212, 94, 94},
    ["logistic-science-pack"] = {105, 222, 109},
    ["military-science-pack"] = {100, 100, 100},
    ["chemical-science-pack"] = {112, 208, 237},
    ["production-science-pack"] = {190, 105, 238},
    ["utility-science-pack"] = {255, 202, 96},
    ["space-science-pack"] = {1, 1, 1},
    ["metallurgic-science-pack"] = {255, 172, 50},
    ["electromagnetic-science-pack"] = {242, 88, 182},
    ["agricultural-science-pack"] = {205, 246, 43},
    ["cryogenic-science-pack"] = {80, 105, 213},
    ["hydraulic-science-pack"] = {2, 147, 255},
    ["promethium-science-pack"] = {20, 20, 20},
    ["spoilage"] = {86, 110, 4}
}

local function science_pack_color(science_pack)
    if science_pack_colors[science_pack.name] then
        return science_pack_colors[science_pack.name]
    end
    science_pack_colors[science_pack.name] = {
        math.random(),
        math.random(),
        math.random(),
    }
    return science_pack_color(science_pack)
end

local function generate_recipe_icons(icons, science_pack, icon_shift)
    if science_pack.icon then
        table.insert(icons,
            {
                icon = science_pack.icon,
                icon_size = (science_pack.icon_size or defines.default_icon_size),
                scale = 16.0 / (science_pack.icon_size or defines.default_icon_size), -- scale = 0.5 * 32 / icon_size simplified
                shift = icon_shift
            }
        )
    elseif science_pack.icons then
        icons = util.combine_icons(
            icons,
            science_pack.icons,
            {scale = 0.5, shift = icon_shift},
            science_pack.icon_size or defines.default_icon_size
        )
    end

    return icons
end

local function pressurize(science_pack_name)
    local science_pack = data.raw.tool[science_pack_name] or data.raw.item[science_pack_name]
    if not science_pack then return end

    if science_pack.spoil_result and science_pack.spoil_result ~= "spoilage" then
        return
    end

    local fill_name = "maraxsis-" .. science_pack_name .. "-research-vessel"
    local empty_name = "maraxsis-" .. science_pack_name .. "-empty-research-vessel"

    local spoil_result
    if science_pack.spoil_result then
        spoil_result = "maraxsis-" .. science_pack.spoil_result .. "-research-vessel"
    end

    data:extend {{
        type = "item",
        name = fill_name,
        icons = {
            {
                icon = "__maraxsis__/graphics/icons/research-vessel.png",
                icon_size = 64,
            },
            {
                icon = "__maraxsis__/graphics/icons/research-vessel-mask.png",
                tint = science_pack_color(science_pack),
                icon_size = 64,
            }
        },
        stack_size = 20,
        localised_name = {"item-name.maraxsis-full-research-vessel", science_pack.localised_name or {"item-name." .. science_pack_name}},
        spoil_result = spoil_result,
        spoil_ticks = science_pack.spoil_ticks,
        spoil_to_trigger_result = science_pack.spoil_to_trigger_result,
        spoil_level = science_pack.spoil_level,
        hidden_in_factoriopedia = true,
        default_import_location = science_pack.default_import_location,
        weight = 1000000 / 100,
        order = science_pack.order,
        inventory_move_sound = item_sounds.metal_large_inventory_move,
        pick_sound = item_sounds.metal_large_inventory_pickup,
        drop_sound = item_sounds.metal_large_inventory_move,
        subgroup = "maraxsis-fill-research-vessel",
    }}

    data:extend {{
        type = "recipe",
        name = fill_name,
        enabled = false,
        energy_required = 15,
        ingredients = {
            {type = "item", name = "maraxsis-empty-research-vessel", amount = 1},
            {type = "item", name = science_pack_name,                amount = 100},
        },
        results = {
            {type = "item", name = fill_name, amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1},
        },
        allow_productivity = false,
        allow_quality = false,
        category = "chemistry",
        auto_recycle = false,
        hide_from_signal_gui = false,
        allow_decomposition = false,
        hide_from_player_crafting = true,
        factoriopedia_alternative = "maraxsis-empty-research-vessel",
        icons = generate_recipe_icons({
            {
                icon = "__maraxsis__/graphics/icons/research-vessel.png",
                icon_size = 64,
            },
            {
                icon = "__maraxsis__/graphics/icons/research-vessel-mask.png",
                tint = science_pack_color(science_pack),
                icon_size = 64,
            }
        }, science_pack, {-8, -8}),
        subgroup = "maraxsis-fill-research-vessel",
    }}
    add_to_tech(fill_name)

    data:extend {{
        type = "recipe",
        name = empty_name,
        enabled = false,
        energy_required = 15,
        ingredients = {
            {type = "item", name = fill_name, amount = 1},
        },
        results = {
            {type = "item", name = science_pack_name,                amount = 100, ignored_by_stats = 100, ignored_by_productivity = 100},
            {type = "item", name = "maraxsis-empty-research-vessel", amount = 1,   ignored_by_stats = 1,   ignored_by_productivity = 1,  probability = 0.99},
        },
        allow_productivity = false,
        allow_quality = false,
        category = "chemistry",
        auto_recycle = false,
        unlock_results = false,
        icons = generate_recipe_icons({
            {
                icon = "__maraxsis__/graphics/icons/research-vessel-tipped.png",
                icon_size = 64,
            },
            {
                icon = "__maraxsis__/graphics/icons/research-vessel-tipped-mask.png",
                tint = science_pack_color(science_pack),
                icon_size = 64,
            }
        }, science_pack, {8, 8}),
        localised_name = {"recipe-name.maraxsis-empty-research-vessel", science_pack.localised_name or {"item-name." .. science_pack_name}},
        hide_from_signal_gui = false,
        allow_decomposition = false,
        hide_from_player_crafting = true,
        factoriopedia_alternative = "maraxsis-empty-research-vessel",
        subgroup = "maraxsis-empty-research-vessel",
    }}
    add_to_tech(empty_name)

    if science_pack.spoil_result == "spoilage" then
        pressurize("spoilage")
    end
end

for _, science_pack_name in pairs(data.raw.lab.biolab.inputs) do
    pressurize(science_pack_name)
end

if data.raw.item["maraxsis-spoilage-research-vessel"] and data.raw.item["maraxsis-agricultural-science-pack-research-vessel"] then
    data.raw.item["maraxsis-spoilage-research-vessel"].order = data.raw.item["maraxsis-agricultural-science-pack-research-vessel"].order .. "z"
end
