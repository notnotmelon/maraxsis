_G.h2o = {}

require 'table'
require 'string'
require 'defines'
require 'color'
require 'world-generation'

if data and data.raw and not data.raw.item['iron-plate'] then
    h2o.stage = 'settings'
elseif data and data.raw then
    h2o.stage = 'data'
    require 'data-stage'
elseif script then
    h2o.stage = 'control'
    require 'control-stage'
else
    error('Could not determine load order stage.')
end