_G.maraxsis = require "scripts.constants"
require "lib.lib"

maraxsis.prototypes = {
    [maraxsis.MARAXSIS_SURFACE_NAME] = require "scripts.map-gen.surfaces.maraxsis",
    [maraxsis.TRENCH_SURFACE_NAME] = require "scripts.map-gen.surfaces.maraxsis-trench",
}

require "scripts.submarine"
require "scripts.drowning"
require "scripts.nightvision"
require "scripts.pressure-dome"
require "scripts.composite-entity"
require "scripts.sand-extractor"
require "scripts.hydro-plant"
require "scripts.project-seadragon"
require "scripts.swimming"
require "scripts.salt-reactor"
require "scripts.trench-duct"
require "scripts.abyssal-diving-gear"

maraxsis.finalize_events()
