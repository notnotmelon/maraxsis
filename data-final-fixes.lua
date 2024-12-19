local collision_mask_util = require("collision-mask-util")

require "prototypes.collision-mask"
require "prototypes.swimming"

require "compat.5-dim"
require "compat.alien-biomes"
require "compat.combat-mechanics-overhaul"
require "compat.visible-planets-in-space"
require "compat.rocket-silo-construction"
require "compat.quality-seeds"

for extractor in pairs(maraxsis.MARAXSIS_SAND_EXTRACTORS) do
    local mask = collision_mask_util.get_mask(data.raw["mining-drill"][extractor])
    data.raw["assembling-machine"][extractor .. "-sand-extractor"].collision_mask = mask
end

local promethium_quality = data.raw["technology"]["maraxsis-promethium-quality"]
if promethium_quality then
    promethium_quality.unit.ingredients = table.deepcopy(data.raw["technology"]["research-productivity"].unit.ingredients)
    for _, pack in pairs(promethium_quality.unit.ingredients) do
        if pack[1] == "cryogenic-science-pack" then
            pack[1] = "hydraulic-science-pack"
        end
    end
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

-- fix collision masks for the trench entrance
for _, entity in pairs(collision_mask_util.collect_prototypes_with_layer("object")) do
    if entity.type ~= "tile" and not ducts[entity.name] then
        entity.collision_mask = collision_mask_util.get_mask(entity)
        entity.collision_mask.layers[maraxsis_trench_entrance_collision_mask] = true
    end
end

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

-- promethium quality module categories
local cryogenic_crafting_categories = {}
for _, category in pairs(data.raw["assembling-machine"]["cryogenic-plant"].crafting_categories) do
    cryogenic_crafting_categories[category] = true
end
for _, recipe in pairs(data.raw.recipe) do
    if cryogenic_crafting_categories[recipe.category] and recipe.name ~= "promethium-science-pack" then
        local new_allowed_module_categories = {}
        if recipe.allowed_module_categories then
            for _, allowed_module_category in pairs(recipe.allowed_module_categories) do
                if allowed_module_category ~= "promethium-quality-hidden-module" then
                    table.insert(new_allowed_module_categories, allowed_module_category)
                end
            end
        else
            for _, module_category in pairs(data.raw["module-category"]) do
                if module_category.name ~= "promethium-quality-hidden-module" then
                    table.insert(new_allowed_module_categories, module_category.name)
                end
            end
        end
        recipe.allowed_module_categories = new_allowed_module_categories
    end
end
