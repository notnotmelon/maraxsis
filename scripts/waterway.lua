--[[local SUBMARINES = h2o.SUBMARINES
local DIVE_STATION = 'h2o-dive-station'

h2o.on_event('on_init', function()
    global.dive_stations = global.dive_stations or {}
end)

h2o.on_event('on_built', function(event)
    local entity = event.entity or event.created_entity
    if not entity or not entity.valid then return end
    if entity.name ~= DIVE_STATION then return end
end)

h2o.on_event(defines.events.on_train_changed_state, function(event)
    local train = event.train
    if not train.valid then return end
    local state = train.state
    if state ~= defines.train_state.wait_station then return end
    local station = train.station
    if not station or station.name ~= 'h2o-dive-station' then return end
    local locomotives = train.locomotives
    local submarine = locomotives.front_movers[1]
    if not submarine or not SUBMARINES[submarine.name] then return end
    local surface = submarine.surface
    local surface_name = surface.name
    if not h2o.MARAXSIS_SURFACES[surface_name] then return end
    -- if we got to this point, we have a maraxsis submarine at a dive station
end)--]]