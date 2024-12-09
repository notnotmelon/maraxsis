_G.maraxsis_dome_collision_mask = "maraxsis_maraxsis_dome_collision_mask"
_G.maraxsis_collision_mask = "maraxsis_collision_mask"
_G.maraxsis_lava_collision_mask = "maraxsis_lava_collision_mask"
_G.maraxsis_fishing_tower_collision_mask = "maraxsis_fishing_tower_collision_mask"
_G.maraxsis_trench_entrance_collision_mask = "maraxsis_trench_entrance_collision_mask"

local TRENCH_MOVEMENT_FACTOR = 1

local SUBMARINES = {
    ["maraxsis-diesel-submarine"] = {r = 0.8, g = 0.6, b = 0, a = 0.5},
    ["constructron"] = {r = 0.8, g = 0.6, b = 0, a = 0.5},
    ["maraxsis-nuclear-submarine"] = {r = 0.2, g = 0.7, b = 0.2, a = 0.5},
}

local TRENCH_SURFACE_NAME = "maraxsis-trench"
local MARAXSIS_SURFACE_NAME = "maraxsis"

local MARAXSIS_SURFACES = { -- all surfaces with water mechanics
    [TRENCH_SURFACE_NAME] = true,
    [MARAXSIS_SURFACE_NAME] = true,
}

local MARAXSIS_GET_OPPOSITE_SURFACE = {
    [TRENCH_SURFACE_NAME] = MARAXSIS_SURFACE_NAME,
    [MARAXSIS_SURFACE_NAME] = TRENCH_SURFACE_NAME,
}

local MARAXSIS_SAND_EXTRACTORS = {
    ["electric-mining-drill"] = true,
    ["big-mining-drill"] = true,
}

local SUBMARINE_FUEL_SOURCES = {
    ["maraxsis-diesel-submarine"] = {"maraxsis-diesel"},
    ["constructron"] = {"maraxsis-diesel"},
    ["maraxsis-nuclear-submarine"] = {"nuclear"},
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
    ["maraxsis-salt-reactor"] = true,
}

return {
    TRENCH_MOVEMENT_FACTOR = TRENCH_MOVEMENT_FACTOR,
    SUBMARINES = SUBMARINES,
    TRENCH_SURFACE_NAME = TRENCH_SURFACE_NAME,
    MARAXSIS_SURFACE_NAME = MARAXSIS_SURFACE_NAME,
    MARAXSIS_SURFACES = MARAXSIS_SURFACES,
    MARAXSIS_GET_OPPOSITE_SURFACE = MARAXSIS_GET_OPPOSITE_SURFACE,
    MARAXSIS_SAND_EXTRACTORS = MARAXSIS_SAND_EXTRACTORS,
    SUBMARINE_FUEL_SOURCES = SUBMARINE_FUEL_SOURCES,
    DOME_DISABLEABLE_TYPES = DOME_DISABLEABLE_TYPES,
    DOME_EXCLUDED_FROM_DISABLE = DOME_EXCLUDED_FROM_DISABLE,
}
