require 'lib.lib'

h2o.TRENCH_SURFACE_NAME = 'h2o-trench'
h2o.MARAXIS_SURFACE_NAME = 'h2o-maraxsis'

require 'scripts.submarine'
require 'scripts.map-gen.map-gen'

h2o.finalize_events()