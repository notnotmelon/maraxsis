--[[local SUBMARINES = maraxsis.SUBMARINES
local DIVE_STATION = 'maraxsis-dive-station'

maraxsis.on_event('on_init', function()
    storage.dive_stations = storage.dive_stations or {}
end)

maraxsis.on_event('on_built', function(event)
    local entity = event.entity or event.created_entity
    if not entity or not entity.valid then return end
    if entity.name ~= DIVE_STATION then return end
end)

maraxsis.on_event(defines.events.on_train_changed_state, function(event)
    local train = event.train
    if not train.valid then return end
    local state = train.state
    if state ~= defines.train_state.wait_station then return end
    local station = train.station
    if not station or station.name ~= 'maraxsis-dive-station' then return end
    local locomotives = train.locomotives
    local submarine = locomotives.front_movers[1]
    if not submarine or not SUBMARINES[submarine.name] then return end
    local surface = submarine.surface
    local surface_name = surface.name
    if not maraxsis.MARAXSIS_SURFACES[surface_name] then return end
    -- if we got to this point, we have a maraxsis submarine at a dive station
end)--]]
