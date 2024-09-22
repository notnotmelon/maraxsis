_G.h2o = require 'scripts.constants'
require 'lib.lib'

h2o.prototypes = {
    [h2o.MARAXSIS_SURFACE_NAME] = require 'scripts.map-gen.surfaces.maraxsis',
    [h2o.TRENCH_SURFACE_NAME] = require 'scripts.map-gen.surfaces.maraxsis-trench',
}

require 'scripts.submarine'
require 'scripts.drowning'
require 'scripts.waterway'
require 'scripts.nightvision'
require 'scripts.pressure-dome'
require 'scripts.quantum-computer'
require 'scripts.composite-entity'

h2o.finalize_events()