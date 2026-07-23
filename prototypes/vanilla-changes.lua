for _, lab in pairs(data.raw.lab) do
    for _, input in pairs(lab.inputs or {}) do
        if input == "cryogenic-science-pack" then
            lab.inputs = lab.inputs or {}
            if not table.find(lab.inputs, "hydraulic-science-pack") then
                table.insert(lab.inputs, "hydraulic-science-pack")
            end
            table.sort(lab.inputs, function(a, b)
                local order_1 = (data.raw.item[a] and data.raw.item[a].order) or a
                local order_2 = (data.raw.item[b] and data.raw.item[b].order) or b
                return order_1 < order_2
            end)
            break
        end
    end
end

if settings.startup["maraxsis-add-hydraulic-science"].value then
    local function add_hydraulic_pack(tech_name)
        local tech = data.raw.technology[tech_name]
        if not tech then return end

        if tech.unit and tech.unit.ingredients then table.insert(tech.unit.ingredients, {"hydraulic-science-pack", 1}) end
    end

    add_hydraulic_pack("stellar-discovery-solar-system-edge")
    add_hydraulic_pack("promethium-science-pack")
    add_hydraulic_pack("research-productivity")

    if mods["Krastorio2-spaced-out"] then
        table.insert(data.raw["technology"]["stellar-discovery-solar-system-edge"].prerequisites, "kr-quantum-computer")
    else
        table.insert(data.raw["technology"]["stellar-discovery-solar-system-edge"].prerequisites, "maraxsis-deepsea-research")
    end
end

local function insert_hydro_plant(recipe)
    if not recipe then
        return
    end
    local categories = recipe.categories or {"crafting"}
    table.insert(categories,"maraxsis-hydro-plant")
    recipe.categories = categories
end

insert_hydro_plant(data.raw.recipe["pump"])
insert_hydro_plant(data.raw.recipe["pipe"])
insert_hydro_plant(data.raw.recipe["pipe-to-ground"])
insert_hydro_plant(data.raw.recipe["storage-tank"])
insert_hydro_plant(data.raw.recipe["coal-synthesis"])
insert_hydro_plant(data.raw.recipe["engine-unit"])
insert_hydro_plant(data.raw.recipe["electric-engine-unit"])

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
    if effect.recipe ~= "maraxsis-regulator" then
        table.insert(new_spidertron_effects, effect)
    end
end
data.raw.technology["spidertron"].effects = new_spidertron_effects

insert_hydro_plant(data.raw.recipe["ice-melting"])
insert_hydro_plant(data.raw.recipe["advanced-thruster-fuel"])
insert_hydro_plant(data.raw.recipe["advanced-thruster-oxidizer"])

-- https://github.com/notnotmelon/maraxsis/issues/23
for _, projectile in pairs(data.raw.projectile) do
    local _, target_effects = pcall(function() return projectile.action.action_delivery.target_effects end)
    if not target_effects or type(target_effects) ~= "table" then goto continue end
    for _, effect in pairs(target_effects) do
        if type(effect) == "table" and effect.type == "set-tile" then
            effect.tile_collision_mask = effect.tile_collision_mask or {layers = {}}
            effect.tile_collision_mask.layers[maraxsis_underwater_collision_mask] = true
            effect.tile_collision_mask.layers[maraxsis_coral_collision_mask] = true
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

for _, module in pairs(data.raw.module) do
    if module.name:find("quality%-module") and not module.beacon_tint then
        module.beacon_tint = {
            primary = {1, 0, 0},
            secondary = {1, 0.37, 0.37},
        }
    end
end

-- add vehicle acceleration to uranium fuel cells for nuclear submarine
local uranium_fuel_cell = data.raw.item["uranium-fuel-cell"]
local nuclear_fuel = data.raw.item["nuclear-fuel"]
uranium_fuel_cell.fuel_acceleration_multiplier = nuclear_fuel.fuel_acceleration_multiplier
uranium_fuel_cell.fuel_top_speed_multiplier = nuclear_fuel.fuel_top_speed_multiplier
uranium_fuel_cell.fuel_emissions_multiplier = nuclear_fuel.fuel_emissions_multiplier
uranium_fuel_cell.fuel_glow_color = nuclear_fuel.fuel_glow_color
uranium_fuel_cell.fuel_acceleration_multiplier_quality_bonus = nuclear_fuel.fuel_acceleration_multiplier_quality_bonus
uranium_fuel_cell.fuel_top_speed_multiplier_quality_bonus = nuclear_fuel.fuel_top_speed_multiplier_quality_bonus

data.raw["assembling-machine"]["crusher"].surface_conditions = nil

do
    for _, capsule in pairs{
        "yumako",
        "yumako-mash",
        "jellynut",
        "jelly",
        "bioflux",
    } do
        data.raw.capsule[capsule].capsule_action.attack_parameters.cooldown = data.raw.capsule["raw-fish"].capsule_action.attack_parameters.cooldown
    end
    for _, sticker in pairs{
        "yumako-regen-sticker",
        "bioflux-speed-regen-sticker",
    } do
        data.raw.sticker[sticker].damage_per_tick.amount = data.raw.sticker[sticker].damage_per_tick.amount * 20
    end
end