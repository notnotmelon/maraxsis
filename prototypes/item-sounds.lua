local item_sounds = require("__base__.prototypes.item_sounds")
local space_age_item_sounds = require("__space-age__.prototypes.item_sounds")

local function add_sound_item(name, move_sound, pick_sound, drop_sound)
    if not move_sound then error("Missing move_sound") end
    if not pick_sound then error("Missing pick_sound") end
    if not drop_sound then error("Missing drop_sound") end
    for item_type in pairs(defines.prototypes.item) do
        local item = (data.raw[item_type] or {})[name]
        if item then
            item.inventory_move_sound = move_sound
            item.pick_sound = pick_sound
            item.drop_sound = drop_sound
            return
        end
    end
    if not mods.pystellarexpedition then error("Could not find item " .. name) end
end

add_sound_item("maraxsis-fishing-tower", item_sounds.fluid_inventory_move, item_sounds.fluid_inventory_pickup, item_sounds.fluid_inventory_move)
add_sound_item("maraxsis-big-cliff-explosives", item_sounds.atomic_bomb_inventory_move, item_sounds.atomic_bomb_inventory_pickup, item_sounds.atomic_bomb_inventory_move)
add_sound_item("maraxsis-diesel-submarine", item_sounds.mechanical_large_inventory_move, item_sounds.mechanical_large_inventory_pickup, item_sounds.mechanical_large_inventory_move)
add_sound_item("maraxsis-nuclear-submarine", item_sounds.mechanical_large_inventory_move, item_sounds.mechanical_large_inventory_pickup, item_sounds.mechanical_large_inventory_move)
add_sound_item("maraxsis-hydro-plant", item_sounds.fluid_inventory_move, item_sounds.fluid_inventory_pickup, item_sounds.fluid_inventory_move)
add_sound_item("maraxsis-sonar", item_sounds.metal_large_inventory_move, item_sounds.metal_large_inventory_pickup, item_sounds.metal_large_inventory_move)
add_sound_item("maraxsis-pressure-dome", item_sounds.metal_large_inventory_move, item_sounds.metal_large_inventory_pickup, item_sounds.metal_large_inventory_move)
add_sound_item("maraxsis-coral", space_age_item_sounds.agriculture_inventory_move, space_age_item_sounds.agriculture_inventory_pickup, space_age_item_sounds.agriculture_inventory_move)
add_sound_item("limestone", item_sounds.resource_inventory_move, item_sounds.resource_inventory_pickup, item_sounds.resource_inventory_move)
add_sound_item(maraxsis_constants.SAND_ITEM_NAME, item_sounds.resource_inventory_move, item_sounds.resource_inventory_pickup, item_sounds.resource_inventory_move)
add_sound_item("maraxsis-glass-panes", item_sounds.metal_small_inventory_move, item_sounds.metal_small_inventory_pickup, item_sounds.metal_small_inventory_move)
add_sound_item("maraxsis-fish-food", space_age_item_sounds.agriculture_inventory_move, space_age_item_sounds.agriculture_inventory_pickup, space_age_item_sounds.agriculture_inventory_move)
add_sound_item("maraxsis-tropical-fish", item_sounds.raw_fish_inventory_move, item_sounds.raw_fish_inventory_pickup, item_sounds.raw_fish_inventory_move)
add_sound_item("maraxsis-microplastics", item_sounds.plastic_inventory_move, item_sounds.plastic_inventory_pickup, item_sounds.plastic_inventory_move)
add_sound_item("maraxsis-wyrm-specimen", item_sounds.raw_fish_inventory_move, item_sounds.raw_fish_inventory_pickup, item_sounds.raw_fish_inventory_move)
add_sound_item("maraxsis-wyrm-confinement-cell", item_sounds.metal_small_inventory_move, item_sounds.metal_small_inventory_pickup, item_sounds.metal_small_inventory_move)
add_sound_item("maraxsis-super-sealant-substance", space_age_item_sounds.agriculture_inventory_move, space_age_item_sounds.agriculture_inventory_pickup, space_age_item_sounds.agriculture_inventory_move)
add_sound_item("salt", item_sounds.resource_inventory_move, item_sounds.resource_inventory_pickup, item_sounds.resource_inventory_move)
add_sound_item("maraxsis-salt-filter", item_sounds.steam_inventory_move, item_sounds.steam_inventory_pickup, item_sounds.steam_inventory_move)
add_sound_item("maraxsis-saturated-salt-filter", item_sounds.steam_inventory_move, item_sounds.steam_inventory_pickup, item_sounds.steam_inventory_move)
add_sound_item("maraxsis-abyssal-diving-gear", item_sounds.metal_large_inventory_move, item_sounds.metal_large_inventory_pickup, item_sounds.metal_large_inventory_move)
add_sound_item("maraxsis-trench-duct", item_sounds.metal_large_inventory_move, item_sounds.metal_large_inventory_pickup, item_sounds.metal_large_inventory_move)
add_sound_item("maraxsis-empty-research-vessel", item_sounds.metal_large_inventory_move, item_sounds.metal_large_inventory_pickup, item_sounds.metal_large_inventory_move)
add_sound_item("maraxsis-salt-reactor", item_sounds.reactor_inventory_move, item_sounds.reactor_inventory_pickup, item_sounds.reactor_inventory_move)
add_sound_item("hydraulic-science-pack", item_sounds.science_inventory_move, item_sounds.science_inventory_pickup, item_sounds.science_inventory_move)
add_sound_item("maraxsis-conduit", item_sounds.mechanical_inventory_move, item_sounds.mechanical_inventory_pickup, item_sounds.mechanical_inventory_move)
add_sound_item("maraxsis-fat-man", item_sounds.atomic_bomb_inventory_move, item_sounds.atomic_bomb_inventory_pickup, item_sounds.atomic_bomb_inventory_move)
