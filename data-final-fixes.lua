function table_contains(tbl, x)
    if not tbl then
        return false
    end
    for _, v in pairs(tbl) do
        if v == x then
            return true
        end
    end
    return false
end

local collision_mask_util = require("collision-mask-util")

require "prototypes.collision-mask"
require "prototypes.swimming"

require "compat.5-dim"
require "compat.alien-biomes"
require "compat.visible-planets-in-space"
require "compat.rocket-silo-construction"
require "compat.combat-mechanics-overhaul"
require "compat.castra"
require "compat.krastorio-2-final-fixes"
require "compat.water-refining"
require "compat.science-tab"

if not data.raw["mining-drill"]["electric-mining-drill"].next_upgrade then
    if mods["SchallAlienTech"] and data.raw["mining-drill"]["Schall-uranium-mining-drill"] then
        data.raw["mining-drill"]["electric-mining-drill"].next_upgrade = "Schall-uranium-mining-drill"
    end
end

for extractor in pairs(maraxsis_constants.MARAXSIS_SAND_EXTRACTORS) do
    local mask = collision_mask_util.get_mask(data.raw["mining-drill"][extractor])
    mask.layers[maraxsis_dome_collision_mask] = true

    -- https://github.com/notnotmelon/maraxsis/issues/342
    -- https://github.com/notnotmelon/maraxsis/issues/368
    local seen = {extractor}
    local function update_collision_masks(mining_drill)
        if type(mining_drill) ~= "string" then return end
        for _, v in pairs(seen) do
            if v == mining_drill then return end
        end
        seen[#seen+1] = mining_drill
        mining_drill = data.raw["mining-drill"][mining_drill]
        if not mining_drill then return end
        mining_drill.collision_mask = mask
        update_collision_masks(mining_drill.next_upgrade)
        for _, drill in pairs(data.raw.mining_drill) do
            if drill.next_upgrade == mining_drill then
                update_collision_masks(drill.name)
            end
        end
    end

    update_collision_masks(extractor)
    update_collision_masks(extractor .. "-sand-extractor")
end

local i = 1
while true do
    local t = data.raw["technology"]["maraxsis-promethium-quality-" .. i]
    if t then
        t.unit.ingredients = table.deepcopy(data.raw["technology"]["research-productivity"].unit.ingredients)
    else
        break
    end
    i = i + 1
end

for _, recipe in pairs(data.raw.recipe) do
    if table_contains(recipe.categories,"maraxsis-hydro-plant") then
        recipe.always_show_made_in = true
    end
end

data.raw["equipment-grid"]["maraxsis-diesel-submarine-equipment-grid"].equipment_categories = table.deepcopy(data.raw["equipment-grid"]["spidertron-equipment-grid"].equipment_categories)
data.raw["equipment-grid"]["maraxsis-nuclear-submarine-equipment-grid"].equipment_categories = table.deepcopy(data.raw["equipment-grid"]["spidertron-equipment-grid"].equipment_categories)

if data.raw.technology["legendary-quality"] and data.raw.technology["legendary-quality"].unit and data.raw.technology["legendary-quality"].unit.ingredients then
    data:extend {maraxsis.merge(data.raw.technology["legendary-quality"], {
        name = "maraxsis-legendary-quality",
        localised_description = {"technology-description.legendary-quality"},
        prerequisites = {
            "hydraulic-science-pack",
            "epic-quality"
        }
    })}

    for _, ingredient in pairs(data.raw.technology["maraxsis-legendary-quality"].unit.ingredients) do
        assert(type(ingredient) == "table")
        if ingredient[1] == "cryogenic-science-pack" then
            ingredient[1] = "hydraulic-science-pack"
        end
    end

    for _, technology in pairs(data.raw.technology) do
        if type(technology.prerequisites) == "table" then
            for _, prerequisite in pairs(technology.prerequisites) do
                if prerequisite == "legendary-quality" then
                    table.insert(technology.prerequisites, "maraxsis-legendary-quality")
                    break
                end
            end
        end
    end
end

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

do
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
end

for estrogen_equipment, strength in pairs(maraxsis_constants.ESTROGEN_EQUIPMENT) do
    for prototype in pairs(defines.prototypes.equipment) do
        local equipment_prototype = data.raw[prototype][estrogen_equipment]
        if equipment_prototype then
            equipment_prototype.custom_tooltip_fields = equipment_prototype.custom_tooltip_fields or {}
            table.insert(equipment_prototype.custom_tooltip_fields, {
                name = {"tooltip.estrogen-duration-reduction"},
                value = {"quality-tooltip.percent-duration-decrease", tostring(strength * 100)},
                quality_header = "quality-tooltip.estrogen-duration-reduction",
                quality_values = table.map(data.raw.quality, function(q)
                    local quality_strength = (q.level * 0.3 + 1)
                    local value = tostring(quality_strength * strength * 100)
                    return {"quality-tooltip.percent-duration-decrease", value}
                end)
            })
        end
    end
end

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
