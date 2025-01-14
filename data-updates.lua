require "prototypes.vanilla-changes"
require "prototypes.spidertron-patrols"
require "prototypes.item-weight"
require "prototypes.default-import-location"
require "prototypes.fluid-void"
require "prototypes.item-sounds"
require "prototypes.regulator-fluidbox"
require "compat.aai-industry"
require "compat.transport-ring-teleporter"
require "compat.quality-seeds"

local function add_fuel_value(fluid, value)
    fluid = data.raw.fluid[fluid]
    if not fluid then return end
    fluid.fuel_value = fluid.fuel_value or value
end

add_fuel_value("crude-oil", "1500kJ")
add_fuel_value("petroleum-gas", "2000kJ")
add_fuel_value("maraxsis-hydrogen", "2250kJ")
add_fuel_value("heavy-oil", "2500kJ")
add_fuel_value("light-oil", "3000kJ")

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

    barrel.fuel_acceleration_multiplier = data.raw.item["rocket-fuel"].fuel_acceleration_multiplier
    barrel.fuel_top_speed_multiplier = data.raw.item["rocket-fuel"].fuel_top_speed_multiplier
    barrel.fuel_emissions_multiplier = data.raw.item["rocket-fuel"].fuel_emissions_multiplier
    barrel.fuel_glow_color = data.raw.item["rocket-fuel"].fuel_glow_color
    barrel.fuel_glow_color = data.raw.item["rocket-fuel"].fuel_acceleration_multiplier_quality_bonus
    barrel.fuel_glow_color = data.raw.item["rocket-fuel"].fuel_top_speed_multiplier_quality_bonus

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
end

data.raw.recipe["maraxsis-glass-panes-recycling"].results = {
    {type = "item", name = "sand",      amount = 1, probability = 0.75},
    {type = "item", name = "maraxsis-salt",      amount = 1, probability = 0.25},
    {type = "item", name = "maraxsis-limestone", amount = 1, probability = 0.25},
}

-- salt reactor localised description
local electricity_description = {""}

for _, quality in pairs(data.raw.quality) do
    if quality.hidden then goto continue end
    local quality_name = quality.localised_name or {"quality-name." .. quality.name}

    local quality_level = quality.level
    if quality_level >= 5 and not mods["infinite-quality-tiers"] then quality_level = quality_level - 1 end
    local mj = 10 * (2 ^ quality_level)

    table.insert(electricity_description, {"recipe-description.maraxsis-electricity-quality-description", quality.name, quality_name, tostring(mj)})
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

-- regulator factoriopedia description

local function add_quality_factoriopedia_info(entity, factoriopedia_info)
    local factoriopedia_description

    for _, factoriopedia_info in pairs(factoriopedia_info or {}) do
        local header, factoriopedia_function = unpack(factoriopedia_info)
        local localised_string = {"", "[font=default-semibold]", header, "[/font]"}

        for _, quality in pairs(data.raw.quality) do
            if quality.hidden then goto continue end

            local quality_buff = factoriopedia_function(entity, quality)
            if type(quality_buff) ~= "table" then quality_buff = tostring(quality_buff) end
            table.insert(localised_string, {"", "\n[img=quality." .. quality.name .. "] ", {"quality-name." .. quality.name}, ": [font=default-semibold]", quality_buff, "[/font]"})
            ::continue::
        end

        if factoriopedia_description then
            factoriopedia_description[#factoriopedia_description + 1] = "\n\n"
            factoriopedia_description[#factoriopedia_description + 1] = maraxsis.shorten_localised_string(localised_string)
        else
            factoriopedia_description = localised_string
        end
    end

    entity.factoriopedia_description = maraxsis.shorten_localised_string(factoriopedia_description)
end

add_quality_factoriopedia_info(data.raw["roboport"]["maraxsis-regulator"], {
    {{"quality-tooltip.atmosphere-consumption"}, function(entity, quality_level)
        local consumption_per_second = maraxsis.atmosphere_consumption(quality_level)
        return tostring(consumption_per_second) .. "/s"
    end}
})

-- steal gleba music
local function copy_music(source_planet, target_planet)
    assert(source_planet)
    assert(target_planet)
    for _, music in pairs(data.raw["ambient-sound"]) do
        if music.planet == source_planet.name or (music.track_type == "hero-track" and music.name:find(source_planet.name)) then
            local new_music = table.deepcopy(music)
            new_music.name = music.name .. "-" .. target_planet.name
            new_music.planet = target_planet.name
            if new_music.track_type == "hero-track" then
                new_music.track_type = "main-track"
                new_music.weight = 10
            end
            data:extend {new_music}
        end
    end
end

copy_music(data.raw["planet"]["gleba"], data.raw["planet"]["maraxsis"])
copy_music(data.raw["planet"]["vulcanus"], data.raw["planet"]["maraxsis-trench"])
