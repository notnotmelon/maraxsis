local spline = require "spline"

maraxsis.on_event(maraxsis.events.on_init(), function()
    storage.ai_state_cache = storage.ai_state_cache or {}
    storage.spawn_locations = storage.spawn_locations or {}
end)

local WANDER_DISTANCE = 20

local BIOLUMINESCENCE_PARAMETERS = {
    [defines.segmented_unit_ai_state.patrolling] = {
        color = {0.5, 0.5, 0.5},
        delay = 240,
        intensity = 1,
        size = 0.3
    },
    [defines.segmented_unit_ai_state.investigating] = {
        color = {0.5, 0.5, 0.5},
        delay = 240,
        intensity = 1,
        size = 0.3
    },
    [defines.segmented_unit_ai_state.attacking] = {
        color = {1, 0, 0},
        delay = 20,
        intensity = 3,
        size = 0.5
    },
    [defines.segmented_unit_ai_state.enraged_at_target] = {
        color = {1, 0, 0},
        delay = 20,
        intensity = 3,
        size = 0.5
    },
    [defines.segmented_unit_ai_state.enraged_at_nothing] = {
        color = {1, 0, 0},
        delay = 20,
        intensity = 3,
        size = 0.5
    }
}

local function save_spawn_location(segmented_unit)
    local head = segmented_unit.segments[1]
    storage.spawn_locations[segmented_unit.unit_number] = head.position
end


maraxsis.register_delayed_function("save_spawn_location", function(segment)
    if not segment.valid then return end
    if not storage.spawn_locations[segment.segmented_unit.unit_number] then
        save_spawn_location(segment.segmented_unit)
    end
end)

local function go_investigate_spawn_location(segmented_unit)
    local spawn_location = storage.spawn_locations[segmented_unit.unit_number]
    if not spawn_location then
        save_spawn_location(segmented_unit)
        spawn_location = storage.spawn_locations[segmented_unit.unit_number]
    end

    local offset_x = math.random(-WANDER_DISTANCE, WANDER_DISTANCE)
    local offset_y = math.random(-WANDER_DISTANCE, WANDER_DISTANCE)


    segmented_unit.set_ai_state {
        type = defines.segmented_unit_ai_state.investigating,
        destination = {
            offset_x + spawn_location.x,
            offset_y + spawn_location.y,
        }
    }
end

local function get_ai_state(segment)
    local unit_number = segment.segmented_unit.unit_number
    local state = storage.ai_state_cache[unit_number]
    if not state then
        local segmented_unit = segment.segmented_unit
        state = segmented_unit.get_ai_state().type
        if state == defines.segmented_unit_ai_state.patrolling then
            go_investigate_spawn_location(segmented_unit)
        end
        storage.ai_state_cache[unit_number] = state
    end
    return state
end

local function get_flash_parameters(segment)
    return BIOLUMINESCENCE_PARAMETERS[get_ai_state(segment)]
end

local function ensnare(segmented_unit)
    if not segmented_unit then return end
    local nodes = segmented_unit.get_body_nodes()
    local head = nodes[1]
    local tail = nodes[#nodes]
    head.x = head.x + math.random(-0.01, 0.01)
    head.y = head.y + math.random(-0.01, 0.01)
    tail.x = tail.x + math.random(-0.01, 0.01)
    tail.y = tail.y + math.random(-0.01, 0.01)
    storage.v = storage.v or nodes[math.floor(#nodes * 0.33)]
    storage.x = storage.x or nodes[math.floor(#nodes * 0.66)]
    local control_points = {head, storage.v, storage.x, tail}
    local spline = spline.CubicSpline2D.new(control_points)
    segmented_unit.set_body_nodes(spline:convert_to_points(#nodes))
    segmented_unit.speed = 0
    --segmented_unit.activity_mode = defines.segmented_unit_activity_mode.asleep
end

maraxsis.on_nth_tick(1, function()
    storage.ai_state_cache = {}
    ensnare(game.get_surface("maraxsis-trench").get_segmented_units()[1])
end)

local function get_segment_index(segment)
    for i, s in pairs(segment.segmented_unit.segments) do
        if s.entity == segment then return i end
    end
    return 0
end

local function get_segment_glow_delay(segment, flash_parameters)
    return flash_parameters.delay - ((game.tick - get_segment_index(segment)) % flash_parameters.delay)
end

local function draw_bioluminescese(segment)
    if not segment.valid then return end
    local flash_parameters = get_flash_parameters(segment)
    rendering.draw_light {
        sprite = "utility/light_medium",
        scale = segment.prototype.collision_box.left_top.x * flash_parameters.size,
        intensity = flash_parameters.intensity,
        oriented = true,
        target = segment,
        surface = segment.surface_index,
        time_to_live = 5,
        color = flash_parameters.color
    }
    local delay = get_segment_glow_delay(segment, flash_parameters)
    maraxsis.execute_later("draw_bioluminescese", delay, segment)
end
maraxsis.register_delayed_function("draw_bioluminescese", draw_bioluminescese)

maraxsis.on_event(defines.events.on_script_trigger_effect, function(event)
    if event.effect_id ~= "maraxsis-goozma-segment-created" then
        return
    end

    local segment = event.target_entity
    maraxsis.execute_later("save_spawn_location", 1, segment)
    maraxsis.execute_later("draw_bioluminescese", 1, segment)
end)
