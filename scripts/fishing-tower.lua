maraxsis.on_event(maraxsis.events.on_init(), function()
    storage.fishing_tower_spawners = storage.fishing_tower_spawners or {}
end)

maraxsis.on_event(defines.events.on_script_trigger_effect, function(event)
    local effect_id = event.effect_id
    if effect_id ~= "maraxsis-fishing-plant-created" then return end
    local entity = event.target_entity

    rendering.draw_animation {
        animation = "maraxsis-fishing-plant-animation",
        target = entity,
        surface = entity.surface_index,
        render_layer = "lower-object",
        animation_speed = 0.5,
    }
end)

maraxsis.on_event(maraxsis.events.on_built(), function(event)
    local entity = event.entity
    if not entity.valid or entity.name ~= "maraxsis-fishing-tower" then return end

    local fish_spawner = entity.surface.create_entity {
        name = "maraxsis-fish-spawner",
        position = entity.position,
        force = "neutral",
    }

    fish_spawner.destructible = false
    fish_spawner.active = true
    fish_spawner.operable = false
    fish_spawner.minable_flag = false

    local registration_number = script.register_on_object_destroyed(entity)
    storage.fishing_tower_spawners[registration_number] = fish_spawner
end)

maraxsis.on_event(defines.events.on_object_destroyed, function(event)
    local spawner = storage.fishing_tower_spawners[event.registration_number]
    if spawner then spawner.destroy() end
end)
