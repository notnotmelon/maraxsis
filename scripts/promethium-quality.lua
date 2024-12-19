maraxsis.on_event(maraxsis.events.on_init(), function()
    -- [cryogenic plant unit number] = {entity = cyro plant entity, beacon = beacon entity}
    storage.promethium_quality_beacons = storage.promethium_quality_beacons or {}
end)

local function update_cryo_plant_beacon(beacon)
    local force = beacon.force
    local technology = force.technologies["maraxsis-promethium-quality"]
    if not technology then return end
    local research_level = technology.level - 1
    local module_inventory = beacon.get_module_inventory()
    module_inventory.clear()
    if research_level == 0 then return end
    module_inventory.insert {name = "promethium-quality-hidden-module", count = research_level}
end

local function on_built_cryo_plant(cryo_plant)
    assert(cryo_plant.name == "cryogenic-plant")
    local beacon = cryo_plant.surface.create_entity {
        name = "promethium-quality-hidden-beacon",
        position = cryo_plant.position,
        force = cryo_plant.force_index
    }
    beacon.destructible = false
    beacon.minable = false
    beacon.operable = false
    beacon.rotatable = false
    update_cryo_plant_beacon(beacon)
    storage.promethium_quality_beacons[cryo_plant.unit_number] = {entity = cryo_plant, beacon = beacon}
end

maraxsis.on_event(defines.events.on_script_trigger_effect, function(event)
    if event.effect_id ~= 'maraxsis_on_built_cryo_plant' then return end
    local entity = event.source_entity
    if not entity or not entity.valid then return end
    on_built_cryo_plant(entity)
end)

maraxsis.on_event({defines.events.on_research_finished, defines.events.on_research_reversed}, function(event)
    local research = event.research
    if research.name ~= "maraxsis-promethium-quality" then return end

    local new_beacon_data = {}
    local beacons = storage.promethium_quality_beacons
    for k, beacon_data in pairs(beacons) do
        local cryo_plant, beacon = beacon_data.entity, beacon_data.beacon

        if not cryo_plant or not cryo_plant.valid then
            goto continue
        end

        if not beacon then
            on_built_cryo_plant(cryo_plant)
        else
            update_cryo_plant_beacon(beacon)
        end
        new_beacon_data[cryo_plant.unit_number] = beacon_data

        ::continue::
    end
end)
