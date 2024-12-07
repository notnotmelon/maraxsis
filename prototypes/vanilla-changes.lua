for _, lab in pairs(data.raw.lab) do
    for _, input in pairs(lab.inputs or {}) do
        if input == "cryogenic-science-pack" then
            lab.inputs = lab.inputs or {}
            table.insert(lab.inputs, "hydraulic-science-pack")
            table.sort(lab.inputs, function(a, b)
                local order_1 = data.raw.tool[a].order or a
                local order_2 = data.raw.tool[b].order or b
                return order_1 < order_2
            end)
            break
        end
    end
end

local function add_hydraulic_pack(tech_name, direct_prereq)
    local tech = data.raw.technology[tech_name]
    if not tech then return end

    if tech.unit and tech.unit.ingredients then table.insert(tech.unit.ingredients, {"hydraulic-science-pack", 1}) end
    if direct_prereq and tech.prerequisites then table.insert(tech.prerequisites, "maraxsis-project-seadragon") end
end

add_hydraulic_pack("promethium-science-pack", false)
table.insert(data.raw["technology"]["promethium-science-pack"].prerequisites, "maraxsis-deepsea-research")
add_hydraulic_pack("research-productivity", false)

for _, machine_type in pairs {"assembling-machine", "rocket-silo", "furnace", "character"} do
    for _, machine in pairs(data.raw[machine_type] or {}) do
        if machine.crafting_categories then
            for _, category in pairs(machine.crafting_categories) do
                if category == "crafting" then
                    table.insert(machine.crafting_categories, "maraxsis-hydro-plant-or-assembling")
                    break
                end
            end
        end
    end
end

data.raw.recipe["thruster"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["pumpjack"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["chemical-plant"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["offshore-pump"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["pump"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["pipe"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["pipe-to-ground"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["storage-tank"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["fluid-wagon"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["recycler"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["heating-tower"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["boiler"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["heat-exchanger"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["nuclear-reactor"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["steam-turbine"].category = "maraxsis-hydro-plant-or-assembling"

for _, silo in pairs(data.raw["rocket-silo"]) do
    if silo.fixed_recipe == "rocket-part" then
        silo.fixed_recipe = nil
        silo.disabled_when_recipe_not_researched = true
    end
end

-- ban certain recipes in space
for _, recipe in pairs {
    "rocket-part",
    "empty-heavy-oil-barrel", -- I know it doesn't make sense. But oil processing in space is cool :)
} do
    recipe = data.raw.recipe[recipe]
    recipe.surface_conditions = recipe.surface_conditions or {}
    table.insert(recipe.surface_conditions, {
        property = "gravity",
        min = 0.5,
    })
end

table.insert(data.raw.recipe["rocket-part"].surface_conditions, {
    property = "pressure",
    max = 50000,
})

table.insert(data.raw.furnace["electric-furnace"].crafting_categories, "maraxsis-smelting-or-biochamber")
table.insert(data.raw["assembling-machine"]["biochamber"].crafting_categories, "maraxsis-smelting-or-biochamber")
table.insert(data.raw["assembling-machine"]["biochamber"].crafting_categories, "maraxsis-hydro-plant-or-biochamber")
table.insert(data.raw["assembling-machine"]["chemical-plant"].crafting_categories, "maraxsis-hydro-plant-or-chemistry")
table.insert(data.raw["assembling-machine"]["foundry"].crafting_categories, "maraxsis-hydro-plant-or-foundry")

if data.raw.technology["rocket-part-productivity"] then
    table.insert(data.raw.technology["rocket-part-productivity"].effects, {
        type = "change-recipe-productivity",
        recipe = "maraxsis-rocket-part",
        change = 0.1,
        hidden = true
    })
end

if data.raw.technology["rocket-fuel-productivity"] then
    table.insert(data.raw.technology["rocket-fuel-productivity"].effects, {
        type = "change-recipe-productivity",
        recipe = "maraxsis-hydrolox-rocket-fuel",
        change = 0.1,
    })
end

if data.raw.technology["plastic-bar-productivity"] then
    table.insert(data.raw.technology["plastic-bar-productivity"].effects, 2, {
        type = "change-recipe-productivity",
        recipe = "maraxsis-smelt-microplastics",
        change = 0.1,
    })
end

local new_spidertron_effects = {}
for _, effect in pairs(data.raw.technology["spidertron"].effects) do
    if effect.recipe ~= "service_station" and effect.recipe ~= "constructron" then
        table.insert(new_spidertron_effects, effect)
    end
end
data.raw.technology["spidertron"].effects = new_spidertron_effects

data.raw.recipe["ice-melting"].category = "maraxsis-hydro-plant-or-chemistry"
data.raw.recipe["advanced-thruster-fuel"].category = "maraxsis-hydro-plant-or-chemistry"
data.raw.recipe["advanced-thruster-oxidizer"].category = "maraxsis-hydro-plant-or-chemistry"

data.raw.lab["biolab"].surface_conditions = {{
    property = "pressure",
    max = 300000,
}}

-- https://github.com/notnotmelon/maraxsis/issues/23
for _, projectile in pairs(data.raw.projectile) do
    local _, target_effects = pcall(function() return projectile.action.action_delivery.target_effects end)
    if not target_effects or type(target_effects) ~= "table" then goto continue end
    for _, effect in pairs(target_effects) do
        if type(effect) == "table" and effect.type == "set-tile" then
            effect.tile_collision_mask = effect.tile_collision_mask or {layers = {}}
            effect.tile_collision_mask.layers[maraxsis_collision_mask] = true
            effect.tile_collision_mask.layers[maraxsis_fishing_tower_collision_mask] = true
            effect.tile_collision_mask.layers[maraxsis_lava_collision_mask] = true
            effect.tile_collision_mask.layers[maraxsis_dome_collision_mask] = true
        end
    end
    ::continue::
end

-- fix equipment grids for the abyssal diving gear
local tank = data.raw.car.tank
if tank.equipment_grid == "medium-equipment-grid" then
    local medium_grid = table.deepcopy(data.raw["equipment-grid"]["medium-equipment-grid"])
    medium_grid.name = "tank-equipment-grid"
    data:extend {medium_grid}
    tank.equipment_grid = "tank-equipment-grid"
end

for _, armor in pairs(data.raw.armor) do
    if type(armor) ~= "table" then goto continue end
    if not armor.equipment_grid then goto continue end
    local grid = data.raw["equipment-grid"][armor.equipment_grid]
    if not grid then goto continue end
    if not grid.equipment_categories then goto continue end
    if type(grid.equipment_categories) ~= "table" then goto continue end

    for _, category in pairs(grid.equipment_categories) do
        if category == "armor" then
            table.insert(grid.equipment_categories, "maraxsis-armor-category")
            break
        end
    end
    ::continue::
end

data.raw.recipe["engine-unit"].category = "maraxsis-hydro-plant-or-assembling"
data.raw.recipe["electric-engine-unit"].category = "maraxsis-hydro-plant-or-assembling"
