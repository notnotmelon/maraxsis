local collision_mask_util = require("collision-mask-util")

require "prototypes.collision-mask"
require "prototypes.swimming"

require "compat.5-dim"
require "compat.alien-biomes"
require "compat.visible-planets-in-space"
require "compat.rocket-silo-construction"
require "compat.combat-mechanics-overhaul"
require "compat.castra"

if not mods.pystellarexpedition then
    for extractor in pairs(maraxsis_constants.MARAXSIS_SAND_EXTRACTORS) do
        local mask = collision_mask_util.get_mask(data.raw["mining-drill"][extractor])
        mask.layers[maraxsis_dome_collision_mask] = true
        data.raw["assembling-machine"][extractor .. "-sand-extractor"].collision_mask = mask
    end
end

if data.raw["technology"]["maraxsis-promethium-productivity"] then
    data.raw["technology"]["maraxsis-promethium-productivity"].unit.ingredients = table.deepcopy(data.raw["technology"]["research-productivity"].unit.ingredients)
end

for _, recipe in pairs(data.raw.recipe) do
    if recipe.category == "maraxsis-hydro-plant-or-assembling" then
        recipe.always_show_made_in = true
    end
end

data.raw["equipment-grid"]["maraxsis-diesel-submarine-equipment-grid"].equipment_categories = table.deepcopy(data.raw["equipment-grid"]["spidertron-equipment-grid"].equipment_categories)
data.raw["equipment-grid"]["maraxsis-nuclear-submarine-equipment-grid"].equipment_categories = table.deepcopy(data.raw["equipment-grid"]["spidertron-equipment-grid"].equipment_categories)

local ducts = table.invert {
    "duct-small",
    "duct",
    "duct-long",
    "duct-t-junction",
    "duct-curve",
    "duct-cross",
    "maraxsis-trench-duct-lower",
}

for name in pairs(ducts) do
    local entity = data.raw["storage-tank"][name] or data.raw["pump"][name] or data.raw["pipe-to-ground"][name]
    entity.collision_mask = {layers = {object = true, train = true, is_object = true, is_lower_object = true}}
end

ducts["maraxsis-trench-duct"] = true

-- allow rocket fuel and nuclear fuel to be used in submarines
local fuel_category = table.deepcopy(data.raw["fuel-category"]["chemical"])
fuel_category.name = "rocket-fuel"
fuel_category.localised_name = {"fuel-category-name.chemical"}
data:extend {fuel_category}
local fuel_category = table.deepcopy(data.raw["fuel-category"]["chemical"])
fuel_category.name = "nuclear-fuel"
fuel_category.localised_name = {"fuel-category-name.chemical"}
data:extend {fuel_category}

data.raw.item["rocket-fuel"].fuel_category = "rocket-fuel"
data.raw.item["nuclear-fuel"].fuel_category = "nuclear-fuel"

for entity_type in pairs(defines.prototypes.entity) do
    for _, entity in pairs(data.raw[entity_type] or {}) do
        local burner = entity.burner or entity.energy_source
        if not burner then goto continue end
        if burner.type ~= "burner" then goto continue end

        burner.fuel_categories = burner.fuel_categories or {"chemical"}
        if table.find(burner.fuel_categories, "chemical") then
            table.insert(burner.fuel_categories, "rocket-fuel")
            table.insert(burner.fuel_categories, "nuclear-fuel")
        end

        ::continue::
    end
end

-- add maraxsis crafting categories to existing crafting machines
local function add_crafting_category_if_other_category_exists(category_to_find, category_to_add)
    if mods.pystellarexpedition then return end

    for _, assembling_machine_type in pairs {
        "assembling-machine",
        "rocket-silo",
        "furnace",
        "character",
    } do
        for _, assembling_machine in pairs(data.raw[assembling_machine_type] or {}) do
            for _, category in pairs(assembling_machine.crafting_categories or {}) do
                if category == category_to_find then
                    table.insert(assembling_machine.crafting_categories, category_to_add)
                    break
                end
            end
        end
    end
end

add_crafting_category_if_other_category_exists("chemistry", "maraxsis-hydro-plant-or-chemistry")
add_crafting_category_if_other_category_exists("smelting", "maraxsis-smelting-or-biochamber")
add_crafting_category_if_other_category_exists("metallurgy", "maraxsis-hydro-plant-or-foundry")
add_crafting_category_if_other_category_exists("organic", "maraxsis-smelting-or-biochamber")
add_crafting_category_if_other_category_exists("organic", "maraxsis-hydro-plant-or-biochamber")
add_crafting_category_if_other_category_exists("crafting", "maraxsis-hydro-plant-or-assembling")
add_crafting_category_if_other_category_exists("advanced-crafting", "maraxsis-hydro-plant-or-advanced-crafting")

if not mods.pystellarexpedition then
    local sand_mask = collision_mask_util.get_mask(data.raw.tile["sand-1-underwater"])
    local hydro_plant_mask = collision_mask_util.get_mask(data.raw["assembling-machine"]["maraxsis-hydro-plant"])
    if collision_mask_util.masks_collide(sand_mask, hydro_plant_mask) then
        error(
            "Hydro plant cannot be built on maraxsis. Is there a mod conflict? Sand mask: "
            .. serpent.line(sand_mask)
            .. " Hydro plant mask: "
            .. serpent.line(hydro_plant_mask)
        )
    end
end
