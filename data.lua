require "prototypes.mod-data.control-constants"
require "scripts.constants"
_G.maraxsis = {}
_G.maraxsis_constants = data.raw["mod-data"]["maraxsis-constants"].data
require "lib.lib"

require "prototypes.spidertron-patrols"
require "prototypes.entity.water-shader"
require "prototypes.entity.submarine"
require "prototypes.entity.rocks"
require "prototypes.entity.trench-duct"
require "prototypes.entity.fish"
require "prototypes.entity.cliffs"
require "prototypes.entity.regulator"
require "prototypes.entity.pressure-dome"
require "prototypes.entity.fishing-tower"
require "prototypes.entity.bubbles"
require "prototypes.entity.coral"
require "prototypes.entity.offshore-pump"
require "prototypes.entity.goozma.goozma"
if not mods.pystellarexpedition then require "prototypes.entity.salt-reactor" end
if not mods.pystellarexpedition then require "prototypes.entity.hydro-plant" end
if not mods.pystellarexpedition then require "prototypes.entity.sonar" end
if not mods.pystellarexpedition then require "prototypes.entity.sand-extractor" end
if not mods.pystellarexpedition then require "prototypes.entity.conduit" end
if not mods.pystellarexpedition then require "prototypes.entity.oversized-steam-turbine" end

require "prototypes.technology.abyssal-diving-gear"
require "prototypes.technology.technology"
require "prototypes.technology.fat-man"
require "prototypes.technology.depth-charges"
require "prototypes.technology.atmosphere"
require "prototypes.technology.project-seadragon"
if not mods.pystellarexpedition then require "prototypes.technology.glass" end
if not mods.pystellarexpedition then require "prototypes.technology.goozma" end
if not mods.pystellarexpedition then require "prototypes.technology.recipes" end
if not mods.pystellarexpedition then require "prototypes.technology.water-treatment" end
if not mods.pystellarexpedition then require "prototypes.technology.hydraulic-science-pack" end
if not mods.pystellarexpedition then require "prototypes.technology.promethium-productivity" end
if not mods.pystellarexpedition then require "prototypes.technology.stone-centrifuging" end
if not mods.pystellarexpedition then require "prototypes.technology.research-vessel" end
if not mods.pystellarexpedition then require "prototypes.technology.deepsea-research" end

if not mods.pystellarexpedition and mods.space_age_galore then
    require "prototypes.recipe.deepsea-research"
end

require "prototypes.circuit-connector-definitions"
require "prototypes.tiles"
require "prototypes.planet.space-location"
require "prototypes.achievements"
require "prototypes.custom-input"
require "prototypes.music"
if not mods.pystellarexpedition then require "prototypes.tips-and-tricks" end

require "compat.krastorio-2"

data.raw["mining-drill"]["burner-mining-drill"].maraxsis_buildability_rules = {water = false, dome = false, coral = false, trench = false, trench_entrance = false, trench_lava = false}
data.raw["assembling-machine"]["chemical-plant"].maraxsis_buildability_rules = {water = true, dome = true, coral = true, trench = true, trench_entrance = false, trench_lava = false}
data.raw["electric-energy-interface"]["electric-energy-interface"].maraxsis_buildability_rules = {water = true, dome = true, coral = true, trench = true, trench_entrance = false, trench_lava = false}
