local tech_tree_screenshot_mode = false
if tech_tree_screenshot_mode then
    for _, t in pairs(data.raw.technology) do
        t.enabled = false
        if t.normal then t.normal.enabled = false end
        if t.expensive then t.expensive.enabled = false end
    end
end

require 'lib.lib'
require 'prototypes.submarine'
require 'prototypes.technology'
require 'prototypes.glass'
require 'prototypes.quarkals'
require 'prototypes.wyrm'
require 'prototypes.rocks'
require 'prototypes.fish'
require 'prototypes.hydro-plant'
require 'prototypes.quantum-computer'
require 'prototypes.torpedo'
require 'prototypes.water-treatment'
require 'prototypes.big-cliff-explosive'
require 'prototypes.hydraulic-science-pack'
require 'prototypes.autoplace'
require 'prototypes.tile.lava'
require 'prototypes.tile.water'
require 'prototypes.tips-and-tricks.tips-and-tricks'
