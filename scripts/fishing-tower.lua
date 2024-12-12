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
