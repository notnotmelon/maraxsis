local collision_mask_util = require "__core__/lualib/collision-mask-util"

local tech_tree_screenshot_mode = false
if tech_tree_screenshot_mode then
    for _, t in pairs(data.raw.technology) do
        t.hidden = true
    end
end

_G.maraxsis = require "scripts.constants"
require "lib.lib"
require "prototypes.abyssal-diving-gear"
require "prototypes.circuit-connector-definitions"
require "prototypes.tile.water-and-cliffs"
require "prototypes.submarine"
require "prototypes.construction-submarine"
require "prototypes.technology"
require "prototypes.glass"
require "prototypes.wyrm"
require "prototypes.rocks"
require "prototypes.trench-duct"
require "prototypes.fish"
require "prototypes.tile.lava"
require "prototypes.hydro-plant"
require "prototypes.regulator"
require "prototypes.pressure-dome"
require "prototypes.sonar"
require "prototypes.fishing-tower"
require "prototypes.sand-extractor"
require "prototypes.bubbles"
require "prototypes.recipes"
require "prototypes.torpedoes"
require "prototypes.fat-man"
require "prototypes.water-treatment"
require "prototypes.big-cliff-explosive"
require "prototypes.atmosphere"
require "prototypes.hydraulic-science-pack"
require "prototypes.coral"
require "prototypes.project-seadragon"
require "prototypes.deepsea-research"
require "prototypes.preservatives"
require "prototypes.promethium-productivity"
require "prototypes.tips-and-tricks.tips-and-tricks"
require "prototypes.offshore-pump"
require "prototypes.planet.map-gen"

data:extend {{
    type = "custom-input",
    name = "open-gui",
    key_sequence = "",
    linked_game_control = "open-gui"
}}
