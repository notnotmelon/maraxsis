local collision_mask_util = require '__core__/lualib/collision-mask-util'

local tech_tree_screenshot_mode = false
if tech_tree_screenshot_mode then
    for _, t in pairs(data.raw.technology) do
        t.enabled = false
        if t.normal then t.normal.enabled = false end
        if t.expensive then t.expensive.enabled = false end
    end
end

require 'lib.lib'
require 'prototypes.tile.water'
_G.dome_collision_mask = collision_mask_util.get_first_unused_layer()
assert(dome_collision_mask ~= maraxsis_collision_mask, 'dome_collision_mask is the same as maraxsis_collision_mask')
require 'prototypes.submarine'
require 'prototypes.technology'
require 'prototypes.glass'
require 'prototypes.quarkals'
require 'prototypes.wyrm'
require 'prototypes.rocks'
require 'prototypes.fish'
require 'prototypes.hydro-plant'
require 'prototypes.pressure-dome'
require 'prototypes.sonar'
require 'prototypes.quantum-computer'
require 'prototypes.torpedoes'
require 'prototypes.water-treatment'
require 'prototypes.big-cliff-explosive'
require 'prototypes.hydraulic-science-pack'
require 'prototypes.autoplace'
require 'prototypes.tile.lava'
require 'prototypes.tips-and-tricks.tips-and-tricks'

data:extend{{
    type = 'custom-input',
    name = 'open-gui',
    key_sequence = '',
    linked_game_control = 'open-gui'
}}