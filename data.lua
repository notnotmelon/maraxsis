require "prototypes.mod-data.constants"
_G.maraxsis = {}
_G.maraxsis_constants = data.raw["mod-data"]["maraxsis-constants"].data
require "lib.lib"

require "prototypes.entity.water-shader"
require "prototypes.entity.submarine"
require "prototypes.entity.rocks"
require "prototypes.entity.trench-duct"
require "prototypes.entity.tropical-fish"
require "prototypes.entity.cliffs"
require "prototypes.entity.regulator"
require "prototypes.entity.pressure-dome"
require "prototypes.entity.fishing-tower"
require "prototypes.entity.bubbles"
require "prototypes.entity.coral"
require "prototypes.entity.offshore-pump"
require "prototypes.entity.hydro-plant"
require "prototypes.entity.sonar"
require "prototypes.entity.conduit"
require "prototypes.entity.oversized-steam-turbine"
require "prototypes.entity.geothermal-generator"
require "prototypes.entity.ooozma.ooozma"

require "prototypes.equipment.abyssal-diving-gear"
require "prototypes.equipment.sentience-storage-receptacle"


require "prototypes.technology.piscary"
require "prototypes.technology.project-seadragon"

require "prototypes.item.fat-man"
require "prototypes.item.depth-charges"
require "prototypes.item.microplastics"
require "prototypes.item.fish-food"
require "prototypes.item.super-sealant-substance"
require "prototypes.item.salt-filter"
require "prototypes.item.salt"
require "prototypes.item.sand"
require "prototypes.item.hydraulic-science-pack"
require "prototypes.item.reinforced-glass"
require "prototypes.item.sand"
require "prototypes.item.limestone"
require "prototypes.item.ooozma-confinement-cell"

require "prototypes.fluid.supercritical-steam"
require "prototypes.fluid.omega-3"
require "prototypes.fluid.atmosphere"
require "prototypes.fluid.saline-brackish-water"
require "prototypes.fluid.hydrogen-oxygen"

require "prototypes.recipe.geothermal-sulfur"
require "prototypes.recipe.deepsea-research"

require "prototypes.circuit-connector-definitions"
require "prototypes.tile.tiles"
require "prototypes.planet.maraxsis"
require "prototypes.achievements"
require "prototypes.custom-input"
require "prototypes.music"
require "prototypes.tips-and-tricks"

require "compat.krastorio-2"
require "compat.unloading-bay-range-tech"
require "compat.spidertron-patrols"

data.raw["mining-drill"]["burner-mining-drill"].maraxsis_buildability_rules = {water = false, dome = false, coral = false, trench = false, trench_entrance = false, trench_lava = false}
data.raw["assembling-machine"]["chemical-plant"].maraxsis_buildability_rules = {water = true, dome = true, coral = true, trench = true, trench_entrance = false, trench_lava = false}
data.raw["electric-energy-interface"]["electric-energy-interface"].maraxsis_buildability_rules = {water = true, dome = true, coral = true, trench = true, trench_entrance = false, trench_lava = false}
