maraxsis.on_event(maraxsis.events.on_init(), function()
    storage.salt_reactors = storage.salt_reactors or {}
    storage.oversized_steam_turbines = storage.oversized_steam_turbines or {}
    storage.duct_exhausts = storage.duct_exhausts or {}
    storage.fully_active_reactors = storage.fully_active_reactors or {}
    storage.not_fully_active_reactors = storage.not_fully_active_reactors or {}
end)

local function is_salt_reactor_active(reactor)
    if not reactor.active or reactor.to_be_deconstructed() or reactor.energy == 0 then
        return false
    end

    if reactor.get_fuel_inventory().is_empty() and reactor.burner.heat == 0 then
        return false
    end

    local fluidbox = reactor.fluidbox[1]
    return fluidbox and fluidbox.name == "water" and fluidbox.amount > 1
end

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
    "maraxsis-salt-reactor",
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

        for _, neighbours in pairs(duct_exhaust.neighbours) do
            for _, neighbour in pairs(neighbours) do
                if not SUPERCRITICAL_STEAM_ALLOW_LIST[neighbour.name] then
                    local fluidbox = neighbour.fluidbox
                    if fluidbox then
                        for i = 1, #fluidbox do
                            fluidbox.flush(1, "maraxsis-supercritical-steam")
                        end
                    end

                    local position = neighbour.position
                    local force = neighbour.force_index
                    local name = neighbour.name
                    local type = neighbour.type
                    neighbour.die()
                    for _, ghost in pairs(duct_exhaust.surface.find_entities_filtered{
                        position = position,
                        ghost_type = type,
                        ghost_name = name,
                        force = force
                    }) do
                        ghost.destroy()
                    end
                end
            end
        end

        ::continue::
    end
end)

maraxsis.on_nth_tick(3, function()
    for k, data in pairs(storage.not_fully_active_reactors) do
        local entity = data[1]
        local animation = data[2]
        local glow = data[3]

        if not entity.valid then
            storage.not_fully_active_reactors[k] = nil
            goto continue
        end

        if not animation.valid then
            animation = rendering.draw_animation {
                animation = "maraxsis-salt-reactor-animation",
                render_layer = "object",
                target = entity,
                surface = entity.surface_index,
                animation_speed = 0.5
            }
            data[2] = animation
        end

        if not glow.valid then
            glow = rendering.draw_animation {
                animation = "maraxsis-salt-reactor-animation-glow",
                render_layer = "object",
                target = entity,
                surface = entity.surface_index,
                animation_speed = 0.5,
                color = {0, 0, 0, 0}
            }
            data[3] = glow
        end

        local opacity = glow.color.r
        if is_salt_reactor_active(entity) then
            opacity = math.min(1, opacity + 0.01)
        else
            opacity = math.max(0, opacity - 0.01)
        end

        local speed = (opacity == 0) and 0 or 0.5
        animation.animation_speed = speed
        glow.animation_speed = speed

        glow.color = {opacity, opacity, opacity, opacity}
        if opacity == 1 then
            storage.not_fully_active_reactors[k] = nil
            storage.fully_active_reactors[k] = data
        end

        ::continue::
    end
end)

maraxsis.on_nth_tick(181, function()
    for k, data in pairs(storage.fully_active_reactors) do
        local reactor = data[1]
        if not reactor.valid then
            storage.fully_active_reactors[k] = nil
            goto continue
        end

        if not is_salt_reactor_active(data[1]) then
            storage.not_fully_active_reactors[k] = data
            storage.fully_active_reactors[k] = nil
        end

        ::continue::
    end
end)

maraxsis.on_event(maraxsis.events.on_built(), function(event)
    local entity = event.entity
    if not entity.valid then return end

    if entity.name == "maraxsis-salt-reactor" then
        local animation = rendering.draw_animation {
            animation = "maraxsis-salt-reactor-animation",
            render_layer = "object",
            target = entity,
            surface = entity.surface_index,
            animation_speed = 0.5
        }
        local glow = rendering.draw_animation {
            animation = "maraxsis-salt-reactor-animation-glow",
            render_layer = "object",
            target = entity,
            surface = entity.surface_index,
            animation_speed = 0.5,
        }
        glow.color = {0, 0, 0, 0}
        storage.not_fully_active_reactors[entity.unit_number] = {
            entity,
            animation,
            glow,
        }
    elseif entity.name == "maraxsis-oversized-steam-turbine" then
        local assembler = entity.surface.create_entity {
            name = "maraxsis-oversized-steam-turbine-hidden-assembling-machine",
            position = entity.position,
            force = entity.force_index,
            direction = entity.direction,
            quality = entity.quality,
            create_build_effect_smoke = false,
        }
        assembler.destructible = false
        assembler.operable = false
        assembler.minable_flag = false
        assembler.fluidbox.add_linked_connection(0, entity, 0)
        assembler.fluidbox.add_linked_connection(1, entity, 1)
        storage.oversized_steam_turbines[entity.unit_number] = assembler
    elseif entity.name == "duct-exhaust" then
        storage.duct_exhausts[entity.unit_number] = entity
    end
end)

maraxsis.on_event(defines.events.on_player_rotated_entity, function(event)
    local entity = event.entity
    if not entity.valid then return end

    if entity.name == "maraxsis-oversized-steam-turbine" then
        local assembler = storage.oversized_steam_turbines[entity.unit_number]
        if not assembler or not assembler.valid then return end

        assembler.direction = entity.direction
    end
end)

maraxsis.on_event(maraxsis.events.on_destroyed(), function(event)
    local entity = event.entity
    if not entity.valid then return end

    if entity.name == "maraxsis-oversized-steam-turbine" then
        local assembler = storage.oversized_steam_turbines[entity.unit_number]
        if assembler then assembler.destroy() end
    elseif entity.name == "maraxsis-salt-reactor" then
        storage.not_fully_active_reactors[entity.unit_number] = nil
    end
end)
