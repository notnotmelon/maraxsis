require "prototypes.vanilla-changes"
require "prototypes.spidertron-patrols"
require "prototypes.item-weight"
require "prototypes.default-import-location"
require "compat.aai-industry"
require "compat.transport-ring-teleporter"

local function add_fuel_value(fluid, value)
    fluid = data.raw.fluid[fluid]
    if not fluid then return end
    fluid.fuel_value = fluid.fuel_value or value
end

add_fuel_value("crude-oil", "150kJ")
add_fuel_value("petroleum-gas", "200kJ")
add_fuel_value("maraxsis-hydrogen", "225kJ")
add_fuel_value("heavy-oil", "250kJ")
add_fuel_value("light-oil", "300kJ")

for _, fluid in pairs(data.raw.fluid) do -- todo: check fluid fuel category
    local fuel_value = fluid.fuel_value
    if not fuel_value or type(fuel_value) ~= "string" then goto continue end
    local barrel = data.raw.item[fluid.name .. "-barrel"]
    if not barrel then goto continue end

    local number_part, unit = fuel_value:match("^(%d+)(.*)")
    number_part = tonumber(number_part)
    if not number_part then goto continue end
    barrel.fuel_value = tostring(number_part * 50) .. unit -- 50 fluid per barrel
    barrel.fuel_category = barrel.fuel_category or "maraxsis-diesel"
    maraxsis.SUBMARINE_FUEL_SOURCES["maraxsis-diesel-submarine"][1] = barrel.fuel_category
    barrel.burnt_result = "barrel"
    ::continue::
end

local nightvision_to_extend = {}
for _, nightvision in pairs(data.raw["night-vision-equipment"]) do
    if nightvision.name == "ee-super-night-vision-equipment" then goto continue end

    local disabled = table.deepcopy(nightvision)
    disabled.take_result = nightvision.take_result or nightvision.name
    disabled.name = nightvision.name .. "-disabled"
    disabled.darkness_to_turn_on = 1
    disabled.localised_name = nightvision.localised_name or {"equipment-name." .. nightvision.name}

    disabled.localised_description = {"",
        nightvision.localised_description or {"?", {"", {"equipment-description." .. nightvision.name}, "\n"}, {"", {"item-description." .. nightvision.name}, "\n"}, ""},
        {"equipment-description.nightvision-disabled-underwater"}
    }

    nightvision_to_extend[#nightvision_to_extend + 1] = disabled

    ::continue::
end
data:extend(nightvision_to_extend)

-- add torpedoes to stronger explosives tech
for _, tech in pairs(data.raw.technology) do
    if tech.name:find("stronger%-explosives%-%d") then
        local level = tonumber(tech.name:match("%d$"))
        if level >= 4 then
            table.insert(tech.effects, {type = "ammo-damage", infer_icon = true, use_icon_overlay_constant = true, ammo_category = "maraxsis-torpedoes", modifier = 0.2 + (level / 10)})
        end
    end
end

data:extend {{
    type = "item-subgroup",
    name = "maraxsis-atmosphere-barreling",
    order = "ff",
    group = "intermediate-products",
}}

for recipe, category in pairs {
    ["empty-maraxsis-atmosphere-barrel"] = "chemistry",
    ["maraxsis-atmosphere-barrel"] = "chemistry",
    ["empty-maraxsis-liquid-atmosphere-barrel"] = "cryogenics",
    ["maraxsis-liquid-atmosphere-barrel"] = "cryogenics",
} do
    local recipe = data.raw.recipe[recipe]
    recipe.hidden_in_factoriopedia = false
    recipe.category = category
    recipe.subgroup = "maraxsis-atmosphere-barreling"
end
data.raw.recipe["empty-maraxsis-atmosphere-barrel"].results[1].temperature = 25

require "prototypes.item-subgroups"

if mods["assembler-pipe-passthrough"] then
    appmod.blacklist["maraxsis-hydro-plant"] = true
    appmod.blacklist["maraxsis-hydro-plant-extra-module-slots"] = true
    appmod.blacklist["maraxsis-regulator-fluidbox"] = true
end

-- salt reactor localised description
local electricity_description = {""}

for _, quality in pairs(data.raw.quality) do
    if quality.hidden then goto continue end
    local quality_name = quality.localised_name or {"quality-name." .. quality.name}

    local color = maraxsis.color_combine(quality.color, {1, 1, 1}, 0.7)
    local r, g, b = color.r or color[1], color.g or color[2], color.b or color[3]
    local r, g, b = tostring(r), tostring(g), tostring(b)

    local quality_level = quality.level
    if quality_level >= 5 then quality_level = quality_level - 1 end
    local mj = 10 * (2 ^ quality_level)

    table.insert(electricity_description, {"recipe-description.maraxsis-electricity-quality-description", quality_name, tostring(mj), r, g, b})
    table.insert(electricity_description, "\n")
    ::continue::
end
electricity_description[#electricity_description] = nil

electricity_description = maraxsis.shorten_localised_string(electricity_description)

data.raw.recipe["maraxsis-electricity"].localised_description = {
    "recipe-description.maraxsis-electricity",
    electricity_description
}

data.raw.furnace["maraxsis-salt-reactor"].localised_description = {
    "entity-description.maraxsis-salt-reactor",
    electricity_description
}

data.raw["electric-energy-interface"]["maraxsis-salt-reactor-energy-interface"].localised_description = {
    "entity-description.maraxsis-salt-reactor",
    electricity_description
}
