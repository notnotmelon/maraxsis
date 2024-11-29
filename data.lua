local collision_mask_util = require "__core__/lualib/collision-mask-util"

local tech_tree_screenshot_mode = false
if tech_tree_screenshot_mode then
    for _, t in pairs(data.raw.technology) do
        t.enabled = false
        if t.normal then t.normal.enabled = false end
        if t.expensive then t.expensive.enabled = false end
    end
end

_G.dome_collision_mask = "h2o_dome_collision_mask"
_G.maraxsis_collision_mask = "h2o_maraxsis_collision_mask"

_G.maraxsis = require "scripts.constants"
require "lib.lib"
require "prototypes.tile.water-and-cliffs"
require "prototypes.submarine"
require "prototypes.technology"
require "prototypes.glass"
require "prototypes.wyrm"
require "prototypes.rocks"
require "prototypes.fish"
require "prototypes.hydro-plant"
require "prototypes.pressure-dome"
require "prototypes.sonar"
require "prototypes.fish-farm"
require "prototypes.sand-extractor"
require "prototypes.bubbles"
require "prototypes.torpedoes"
require "prototypes.water-treatment"
require "prototypes.planet.maraxsis"
require "prototypes.big-cliff-explosive"
require "prototypes.atmosphere"
require "prototypes.hydraulic-science-pack"
require "prototypes.coral"
require "prototypes.project-seadragon"
require "prototypes.deepsea-research"
require "prototypes.preservatives"
require "prototypes.promethium-productivity"
require "prototypes.tile.lava"
require "prototypes.tips-and-tricks.tips-and-tricks"

data:extend {{
    type = "custom-input",
    name = "open-gui",
    key_sequence = "",
    linked_game_control = "open-gui"
}}
