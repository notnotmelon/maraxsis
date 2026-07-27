require "table"
require "string"
require "defines"
require "color"

if data and data.raw and not data.raw.item["iron-plate"] then
    maraxsis.stage = "settings"
elseif data and data.raw then
    maraxsis.stage = "data"
    require "data-stage"
elseif script then
    maraxsis.stage = "control"
    require "control-stage"
else
    error("Could not determine load order stage.")
end

_G.maraxsis_dome_collision_mask = "maraxsis_dome_collision_mask"
_G.maraxsis_underwater_collision_mask = "maraxsis_underwater_collision_mask"
_G.maraxsis_lava_collision_mask = "maraxsis_lava_collision_mask"
_G.maraxsis_coral_collision_mask = "maraxsis_coral_collision_mask"
_G.maraxsis_trench_entrance_collision_mask = "maraxsis_trench_entrance_collision_mask"
