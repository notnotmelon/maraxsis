-- _G.maraxsis_dome_collision_mask = "maraxsis_dome_collision_mask"
-- _G.maraxsis_underwater_collision_mask = "maraxsis_underwater_collision_mask"
-- _G.maraxsis_lava_collision_mask = "maraxsis_lava_collision_mask"
-- _G.maraxsis_coral_collision_mask = "maraxsis_coral_collision_mask"
-- _G.maraxsis_trench_entrance_collision_mask = "maraxsis_trench_entrance_collision_mask"

local TRENCH_MOVEMENT_FACTOR = 1
local TRENCH_ENTRANCE_ELEVATION = 0.08

local SUBMARINES = {
    ["maraxsis-diesel-submarine"] = true,
    ["maraxsis-nuclear-submarine"] = true,
}

local TRENCH_SURFACE_NAME = "maraxsis-trench"
local MARAXSIS_SURFACE_NAME = "maraxsis"

local MARAXSIS_SURFACES = { -- all surfaces with water mechanics
    [TRENCH_SURFACE_NAME] = true,
    [MARAXSIS_SURFACE_NAME] = true,
    ["maraxsis-factory-floor"] = true,
    ["maraxsis-trench-factory-floor"] = true,
}

local MARAXSIS_SAND_EXTRACTORS = {
    ["electric-mining-drill"] = true,
    ["big-mining-drill"] = true,
}

local SUBMARINE_FUEL_SOURCES = {
    ["maraxsis-diesel-submarine"] = {"maraxsis-diesel", "rocket-fuel"},
    ["maraxsis-nuclear-submarine"] = {"nuclear", "nuclear-fuel", "maraxsis-salt-reactor"},
}

local DOME_DISABLEABLE_TYPES = {
    ["assembling-machine"] = true,
    ["furnace"] = true,
    ["lab"] = true,
    ["beacon"] = true,
    ["mining-drill"] = true,
    ["rocket-silo"] = true,
    ["generator"] = true,
    ["fusion-generator"] = true,
    ["fusion-reactor"] = true,
    ["reactor"] = true,
    ["boiler"] = true,
}

local DOME_EXCLUDED_FROM_DISABLE = {
    ["chemical-plant"] = true,
    ["maraxsis-hydro-plant"] = true,
    ["maraxsis-hydro-plant-extra-module-slots"] = true,
    ["maraxsis-conduit"] = true,
    ["maraxsis-a-breath-of-fresh-air"] = true,
}

local TROPICAL_FISH_NAMES = {}
for i = 1, 15 do
    local name = "maraxsis-tropical-fish-" .. i
    TROPICAL_FISH_NAMES[i] = name
end

data:extend{ 
    {
    type = "mod-data",
    name = "maraxsis-constants", --Data that was previously defined in a control-level script, now defined in data, allowing other mods to configure these constants.
    data_type = "table",
    data = --This data is called in scripts.constants.
        { 
        TRENCH_MOVEMENT_FACTOR = TRENCH_MOVEMENT_FACTOR,
        SUBMARINES = SUBMARINES,
        TRENCH_SURFACE_NAME = TRENCH_SURFACE_NAME,
        MARAXSIS_SURFACE_NAME = MARAXSIS_SURFACE_NAME,
        MARAXSIS_SURFACES = MARAXSIS_SURFACES,
        MARAXSIS_SAND_EXTRACTORS = MARAXSIS_SAND_EXTRACTORS,
        SUBMARINE_FUEL_SOURCES = SUBMARINE_FUEL_SOURCES,
        DOME_DISABLEABLE_TYPES = DOME_DISABLEABLE_TYPES,
        DOME_EXCLUDED_FROM_DISABLE = DOME_EXCLUDED_FROM_DISABLE,
        TRENCH_ENTRANCE_ELEVATION = TRENCH_ENTRANCE_ELEVATION,
        TROPICAL_FISH_NAMES = TROPICAL_FISH_NAMES,
        }
    }
}
