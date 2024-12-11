local collision_mask_util = require("collision-mask-util")

require "prototypes.collision-mask"
require "prototypes.swimming"
require "compat.5-dim"
require "compat.alien-biomes"
require "compat.combat-mechanics-overhaul"

for extractor in pairs(maraxsis.MARAXSIS_SAND_EXTRACTORS) do
    local mask = collision_mask_util.get_mask(data.raw["mining-drill"][extractor])
    data.raw["assembling-machine"][extractor .. "-sand-extractor"].collision_mask = mask
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

-- fix collision masks for the trench entrance
for _, entity in pairs(collision_mask_util.collect_prototypes_with_layer("object")) do
    if entity.type ~= "tile" and not ducts[entity.name] then
        entity.collision_mask = collision_mask_util.get_mask(entity)
        entity.collision_mask.layers[maraxsis_trench_entrance_collision_mask] = true
    end
end
