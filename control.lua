require "scripts.constants"
_G.maraxsis = {}
_G.maraxsis_constants = prototypes.mod_data["maraxsis-constants"].data
require "lib.lib"

require "scripts.map-gen.maraxsis"
require "scripts.map-gen.maraxsis-trench"
require "scripts.submarine"
require "scripts.nightvision"
require "scripts.pressure-dome"
require "scripts.swimming"
require "scripts.trench-duct"
require "scripts.abyssal-diving-gear"
require "scripts.remote"
require "scripts.fishing-tower"
require "scripts.drowning"
require "scripts.sonar"
require "scripts.sand-extractor"
require "scripts.oversized-steam-turbine"

require "compat.call-plumber"

maraxsis.finalize_events()
