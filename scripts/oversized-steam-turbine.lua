maraxsis.on_event(maraxsis.events.on_init(),  function()
    storage.oversized_steam_turbines = storage.oversized_steam_turbines or {}
    storage.duct_exhausts = storage.duct_exhausts or {}
end)

local SUPERCRITICAL_STEAM_ALLOW_LIST = table.invert {
    "duct-small",
    "duct",
    "duct-long",
    "duct-t-junction",
    "duct-curve",
    "duct-cross",
    "duct-intake",
    "duct-exhaust",
    "duct-underground",
    "maraxsis-trench-duct",
    "maraxsis-trench-duct-lower",
    "maraxsis-oversized-steam-turbine",
    "maraxsis-geothermal-generator",
}

maraxsis.on_nth_tick(597, function()
    for unit_number, duct_exhaust in pairs(storage.duct_exhausts) do
        if not duct_exhaust.valid then
            storage.duct_exhausts[unit_number] = nil
            goto continue
        end

        local fluid = duct_exhaust.get_fluid(1)
        if not fluid or fluid.name ~= "maraxsis-supercritical-steam" then
            goto continue
        end

        for _, neighbours in pairs(duct_exhaust.fluidbox_neighbours) do
            for _, neighbour in pairs(neighbours) do
                if neighbour.type ~= "assembling-machine" and not SUPERCRITICAL_STEAM_ALLOW_LIST[neighbour.name] then
                    for i = 1, neighbour.fluids_count do
                        if neighbour.get_fluid(i).name == "maraxsis-supercritical-steam" then
                            neighbour.clear_fluid(i)
                        end
                    end

                    local position = neighbour.position
                    local force = neighbour.force_index
                    local name = neighbour.name
                    local type = neighbour.type
                    neighbour.die()
                    for _, ghost in pairs(
                        duct_exhaust.surface.find_entities_filtered {
                            position = position,
                            ghost_type = type,
                            ghost_name = name,
                            force = force
                        }
                    ) do
                        ghost.destroy()
                    end
                end
            end
        end

        ::continue::
    end
end)

maraxsis.on_event(maraxsis.events.on_built(), function(event)
    local entity = event.entity
    if not entity.valid then
        return
    end

    if entity.name == "duct-exhaust" then
        storage.duct_exhausts[entity.unit_number] = entity
        return
    end

    if entity.name ~= "maraxsis-oversized-steam-turbine" then
        return
    end

    local assembler = entity.surface.create_entity {
        name = "maraxsis-oversized-steam-turbine-hidden-assembling-machine",
        position = entity.position,
        force = entity.force_index,
        direction = entity.direction,
        quality = entity.quality,
        create_build_effect_smoke = false
    }
    assembler.destructible = false
    assembler.operable = false
    assembler.minable_flag = false

    entity.add_fluid_box_linked_connection(0, assembler, 0)
    entity.add_fluid_box_linked_connection(1, assembler, 1)

    storage.oversized_steam_turbines[entity.unit_number] = assembler
end)

maraxsis.on_event(defines.events.on_player_rotated_entity, function(event)
    local entity = event.entity
    if not entity.valid or entity.name ~= "maraxsis-oversized-steam-turbine" then
        return
    end

    local assembler = storage.oversized_steam_turbines[entity.unit_number]
    if assembler and assembler.valid then
        assembler.direction = entity.direction
    end
end)

maraxsis.on_event(maraxsis.events.on_destroyed(), function(event)
    local entity = event.entity
    if not entity.valid or entity.name ~= "maraxsis-oversized-steam-turbine" then
        return
    end

    local assembler = storage.oversized_steam_turbines[entity.unit_number]
    if assembler and assembler.valid then
        assembler.destroy()
    end
end)
