local function draw_bioluminescese(segment)
    if not segment.valid then return end
    rendering.draw_light {
        sprite = "utility/light_medium",
        scale = segment.prototype.collision_box.left_top.x * 0.3,
        intensity = 1,
        oriented = true,
        target = segment,
        surface = segment.surface_index,
        time_to_live = 5,
        color = {0.5, 0.5, 0.5}
    }
    maraxsis.execute_later("draw_bioluminescese", 60, segment)
end
maraxsis.register_delayed_function("draw_bioluminescese", draw_bioluminescese)

local function get_segment_index(segment)
    for i, s in pairs(segment.segmented_unit.segments) do
        if s.entity == segment then return i end
    end
    return 0
end

local function schedule_bioluminescese(segment)
    if not segment.valid then return end
    maraxsis.execute_later("draw_bioluminescese", get_segment_index(segment) + 1, segment)
end
maraxsis.register_delayed_function("schedule_bioluminescese", schedule_bioluminescese)

maraxsis.on_event(defines.events.on_script_trigger_effect, function(event)
	local effect_id = event.effect_id
	if effect_id == "maraxsis-goozma-segment-created" then
	    local segment = event.target_entity
        maraxsis.execute_later("schedule_bioluminescese", 1, segment)
	end
end)
