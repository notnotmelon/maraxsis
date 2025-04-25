_G.maraxsis = require "scripts.constants"
require "lib.lib"

require "scripts.map-gen.maraxsis"
require "scripts.map-gen.maraxsis-trench"
require "scripts.submarine"
if not script.active_mods.pystellarexpedition then require "scripts.drowning" end
require "scripts.nightvision"
require "scripts.pressure-dome"
if not script.active_mods.pystellarexpedition then require "scripts.sonar" end
if not script.active_mods.pystellarexpedition then require "scripts.sand-extractor" end
if not script.active_mods.pystellarexpedition then require "scripts.hydro-plant" end
require "scripts.project-seadragon"
require "scripts.swimming"
if not script.active_mods.pystellarexpedition then require "scripts.salt-reactor" end
require "scripts.trench-duct"
require "scripts.abyssal-diving-gear"
require "scripts.remote"
require "scripts.fishing-tower"
require "compat.call-plumber"

maraxsis.finalize_events()
