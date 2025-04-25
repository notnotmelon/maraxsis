_G.maraxsis = require "scripts.constants"
require "lib.lib"

require "prototypes.entity.water-shader"
require "prototypes.entity.submarine"
if not mods.pystellarexpedition then require "prototypes.entity.salt-reactor" end
require "prototypes.entity.rocks"
require "prototypes.entity.trench-duct"
require "prototypes.entity.fish"
require "prototypes.entity.cliffs"
if not mods.pystellarexpedition then require "prototypes.entity.hydro-plant" end
require "prototypes.entity.regulator"
require "prototypes.entity.pressure-dome"
if not mods.pystellarexpedition then require "prototypes.entity.sonar" end
require "prototypes.entity.fishing-tower"
if not mods.pystellarexpedition then require "prototypes.entity.sand-extractor" end
require "prototypes.entity.bubbles"
require "prototypes.entity.coral"
require "prototypes.entity.offshore-pump"
if not mods.pystellarexpedition then require "prototypes.entity.conduit" end
if not mods.pystellarexpedition then require "prototypes.entity.oversized-steam-turbine" end

require "prototypes.technology.abyssal-diving-gear"
require "prototypes.technology.technology"
if not mods.pystellarexpedition then require "prototypes.technology.glass" end
if not mods.pystellarexpedition then require "prototypes.technology.wyrm" end
if not mods.pystellarexpedition then require "prototypes.technology.recipes" end
require "prototypes.technology.fat-man"
if not mods.pystellarexpedition then require "prototypes.technology.water-treatment" end
require "prototypes.technology.depth-charges"
require "prototypes.technology.atmosphere"
if not mods.pystellarexpedition then require "prototypes.technology.hydraulic-science-pack" end
require "prototypes.technology.project-seadragon"
if not mods.pystellarexpedition then require "prototypes.technology.deepsea-research" end
if not mods.pystellarexpedition then require "prototypes.technology.promethium-productivity" end
if not mods.pystellarexpedition then require "prototypes.technology.stone-centrifuging" end
if not mods.pystellarexpedition then require "prototypes.technology.research-vessel" end

require "prototypes.circuit-connector-definitions"
require "prototypes.tiles"
if not mods.pystellarexpedition then require "prototypes.tips-and-tricks" end
require "prototypes.planet.space-location"
require "prototypes.achievements"

data.raw["mining-drill"]["burner-mining-drill"].maraxsis_buildability_rules = {water = false, dome = false, coral = false, trench = false, trench_entrance = false, trench_lava = false}
data.raw["assembling-machine"]["chemical-plant"].maraxsis_buildability_rules = {water = true, dome = true, coral = true, trench = true, trench_entrance = false, trench_lava = false}
data.raw["electric-energy-interface"]["electric-energy-interface"].maraxsis_buildability_rules = {water = true, dome = true, coral = true, trench = true, trench_entrance = false, trench_lava = false}

--- custom event for submarine submerged
--- also triggers on character submerged with abyssal diving gear
--- event table: {entity, old_surface_index, old_position}
data:extend {{
    type = "custom-event",
    name = "maraxsis-on-submerged",
}}

data:extend {{
    type = "custom-input",
    key_sequence = "",
    linked_game_control = "mine",
    name = "mine"
}}

data:extend {{
    type = "custom-input",
    name = "build",
    key_sequence = "",
    linked_game_control = "build"
}}

data:extend {{
    type = "custom-input",
    name = "build-ghost",
    key_sequence = "",
    linked_game_control = "build-ghost"
}}

data:extend {{
    type = "custom-input",
    name = "super-forced-build",
    key_sequence = "",
    linked_game_control = "super-forced-build"
}}

-- https://github.com/notnotmelon/maraxsis/issues/255
data:extend {{
    type = "custom-input",
    name = "factory-open-outside-surface-to-remote-view",
    key_sequence = "SHIFT + mouse-button-2",
    controller_key_sequence = "controller-leftstick"
}}