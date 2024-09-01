local size = 16.5 -- of the octagon

local check_size = size + 0.01
local dome_polygon = {
    7, check_size,
    -7, check_size,
    -check_size, 7,
    -check_size, -7,
    -7, -check_size,
    7, -check_size,
    check_size, -7,
    check_size, 7,
}

h2o.on_event('on_init', function()
    global.pressure_domes = global.pressure_domes or {}
end)

-- By Pedro Gimeno, donated to the public domain
function is_point_in_polygon(x, y)
    if x > size or x < -size or y > size or y < -size then
        return false
    end

    local x1, y1, x2, y2
    local len = #dome_polygon
    x2, y2 = dome_polygon[len - 1], dome_polygon[len]
    local wn = 0
    for idx = 1, len, 2 do
        x1, y1 = x2, y2
        x2, y2 = dome_polygon[idx], dome_polygon[idx + 1]

        if y1 > y then
            if (y2 <= y) and (x1 - x) * (y2 - y) < (x2 - x) * (y1 - y) then
                wn = wn + 1
            end
        else
            if (y2 > y) and (x1 - x) * (y2 - y) > (x2 - x) * (y1 - y) then
                wn = wn - 1
            end
        end
    end
    return wn % 2 ~= 0 -- even/odd rule
end

local function find_entities_inside_octagon(pressure_dome_data)
    local dome_position = pressure_dome_data.position
    local x, y = dome_position.x, dome_position.y

    local entities_inside_square = entity.surface.find_entities_filtered {
        area = {
            {x - size, y - size},
            {x + size, y + size},
        },
        --collision_mask = {'object-layer'},
    }

    local entities_inside_octagon = {}
    for _, e in pairs(entities_inside_square) do
        local e_x, e_y = e.position.x, e.position.y
        if is_point_in_polygon(e_x - x, e_y - y) then
            table.insert(entities_inside_octagon, e)
        end
    end

    return entities_inside_octagon
end

local function get_four_corners(collision_box, x, y)
    local left_top = collision_box.left_top
    local right_bottom = collision_box.right_bottom

    return {
        {x = x + left_top.x , y = y + left_top.y},
        {x = x + right_bottom.x, y = y + left_top.y},
        {x = x + right_bottom.x, y = y + right_bottom.y},
        {x = x + left_top.x, y = y + right_bottom.y},
    }
end

local function count_points_in_dome(pressure_dome_data, entity)
    local dome_position = pressure_dome_data.position

    local entity_position = entity.position
    local entity_collision_box = entity.prototype.collision_box
    local entity_corners = get_four_corners(entity_collision_box, entity_position.x - dome_position.x, entity_position.y - dome_position.y)

    local count = 0

    for _, entity_corner in pairs(entity_corners) do
        if is_point_in_polygon(entity_corner.x, entity_corner.y) then
            count = count + 1
        end
    end

    return count
end

h2o.on_event('on_built', function(event)
    local entity = event.entity or event.created_entity
    local surface = entity.surface

    for _, pressure_dome_data in pairs(global.pressure_domes) do
        local dome = pressure_dome_data.entity
        if not dome.valid or dome.surface ~= surface then goto continue end

        local points_in_dome = count_points_in_dome(pressure_dome_data, entity)
        if points_in_dome == 0 then
            goto continue
        elseif points_in_dome == 4 then
            dome.minable = false
        else
            h2o.cancel_creation(entity, event.player_index, {'cant-build-reason.entity-in-the-way', dome.localised_name})
        end

        do return end
        ::continue::
    end
end)

h2o.on_event('on_built', function(event)
    local entity = event.entity or event.created_entity
    if not entity.valid or entity.name ~= 'h2o-pressure-dome' then return end

    global.pressure_domes[entity.unit_number] = {
        entity = entity,
        unit_number = entity.unit_number,
        position = entity.position,
        contained_entities = {},
    }

    --[[for x = -size - 5, size + 5, 1 do
        for y = -size - 5, size + 5, 1 do
            if is_point_in_polygon(x, y) then
                rendering.draw_circle {
                    color = {r = 0, g = 1, b = 0},
                    radius = 0.2,
                    filled = true,
                    target = {x = x + position.x, y = y + position.y},
                    surface = surface,
                    force = force,
                }
            else
                rendering.draw_circle {
                    color = {r = 1, g = 0, b = 0},
                    radius = 0.2,
                    filled = true,
                    target = {x = x + position.x, y = y + position.y},
                    surface = surface,
                    force = force,
                }
            end
        end
    end--]]
end)

h2o.on_event('on_destroyed', function(event)
    local entity = event.entity
    if not entity.valid or entity.name ~= 'h2o-pressure-dome' then return end
    local unit_number = entity.unit_number

    local dome = global.pressure_domes[unit_number]
    if not dome then return end
    global.pressure_domes[unit_number] = nil
end)
