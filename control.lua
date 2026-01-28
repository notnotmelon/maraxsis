require "scripts.constants"
_G.maraxsis = {}
_G.maraxsis_constants = prototypes.mod_data["maraxsis-constants"].data
require "lib.lib"

require "scripts.map-gen.maraxsis"
require "scripts.map-gen.maraxsis-trench"
require "scripts.submarine"
require "scripts.nightvision"
require "scripts.pressure-dome"
require "scripts.project-seadragon"
require "scripts.swimming"
require "scripts.trench-duct"
require "scripts.abyssal-diving-gear"
require "scripts.remote"
require "scripts.fishing-tower"
require "scripts.goozma.goozma"

if not script.active_mods.pystellarexpedition then require "scripts.drowning" end
if not script.active_mods.pystellarexpedition then require "scripts.sonar" end
if not script.active_mods.pystellarexpedition then require "scripts.sand-extractor" end
if not script.active_mods.pystellarexpedition then require "scripts.hydro-plant" end
if not script.active_mods.pystellarexpedition then require "scripts.salt-reactor" end

require "compat.call-plumber"

maraxsis.finalize_events()
