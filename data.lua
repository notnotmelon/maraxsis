_G.maraxsis = require "scripts.constants"
require "lib.lib"

require "prototypes.entity.water-shader"
require "prototypes.entity.submarine"
require "prototypes.entity.salt-reactor"
require "prototypes.entity.rocks"
require "prototypes.entity.trench-duct"
require "prototypes.entity.fish"
require "prototypes.entity.cliffs"
require "prototypes.entity.hydro-plant"
require "prototypes.entity.regulator"
require "prototypes.entity.pressure-dome"
require "prototypes.entity.sonar"
require "prototypes.entity.fishing-tower"
require "prototypes.entity.sand-extractor"
require "prototypes.entity.bubbles"
require "prototypes.entity.coral"
require "prototypes.entity.offshore-pump"
require "prototypes.entity.conduit"

require "prototypes.technology.abyssal-diving-gear"
require "prototypes.technology.technology"
require "prototypes.technology.glass"
require "prototypes.technology.wyrm"
require "prototypes.technology.recipes"
require "prototypes.technology.fat-man"
require "prototypes.technology.water-treatment"
require "prototypes.technology.big-cliff-explosive"
require "prototypes.technology.atmosphere"
require "prototypes.technology.hydraulic-science-pack"
require "prototypes.technology.project-seadragon"
require "prototypes.technology.deepsea-research"
require "prototypes.technology.promethium-productivity"
require "prototypes.technology.stone-centrifuging"

require "prototypes.circuit-connector-definitions"
require "prototypes.tiles"
require "prototypes.tips-and-tricks"
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