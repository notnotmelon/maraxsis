local size = 16.5 -- of the octagon

local check_size = size - 0.01
local DOME_POLYGON = {
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
    if remote.interfaces['PickerDollies'] and remote.interfaces['PickerDollies']['add_blacklist_name'] then
        remote.call('PickerDollies', 'add_blacklist_name', 'h2o-pressure-dome')
    end

    global.pressure_domes = global.pressure_domes or {}
end)

-- By Pedro Gimeno, donated to the public domain
function is_point_in_polygon(x, y)
    if x > size or x < -size or y > size or y < -size then
        return false
    end

    local x1, y1, x2, y2
    local len = #DOME_POLYGON
    x2, y2 = DOME_POLYGON[len - 1], DOME_POLYGON[len]
    local wn = 0
    for idx = 1, len, 2 do
        x1, y1 = x2, y2
        x2, y2 = DOME_POLYGON[idx], DOME_POLYGON[idx + 1]

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
        collision_mask = {'object-layer'},
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
            table.insert(pressure_dome_data.contained_entities, entity)
        else
            h2o.cancel_creation(entity, event.player_index, {'cant-build-reason.entity-in-the-way', dome.localised_name})
        end

        do return end
        ::continue::
    end
end)

local function place_tiles(pressure_dome_data)
    local surface = pressure_dome_data.surface
    if not surface.valid then return end
    local position = pressure_dome_data.position
    local x, y = position.x, position.y

    local tiles = {}

    for xx = -math.floor(size), math.floor(size) do
        for yy = -math.floor(size), math.floor(size) do
            if is_point_in_polygon(xx, yy) then
                local x, y = x + xx, y + yy
                tiles[#tiles + 1] = {name = 'h2o-pressure-dome-tile', position = {x, y}}
            end
        end
    end

    game.print('num tiles: ' .. #tiles)

    surface.set_tiles(tiles, true, false, true, false)
end

local DEFAULT_MARAXSIS_TILE = 'dirt-5-underwater'
local function unplace_tiles(pressure_dome_data)
    local surface = pressure_dome_data.surface
    if not surface.valid then return end
    local position = pressure_dome_data.position
    local x, y = position.x, position.y

    local tiles_in_square = surface.find_tiles_filtered {
        area = {
            {x - size, y - size},
            {x + size, y + size},
        },
        name = 'h2o-pressure-dome-tile',
    }

    local tiles = {}

    for _, tile in pairs(tiles_in_square) do
        local tile_position = tile.position
        local xx, yy = tile_position.x, tile_position.y
        if is_point_in_polygon(xx - x, yy - y) then
            tiles[#tiles + 1] = {name = tile.hidden_tile or DEFAULT_MARAXSIS_TILE, position = {xx, yy}}
        end
    end

    surface.set_tiles(tiles, true, false, true, false)
end

local function place_collision_boxes(pressure_dome_data)
    local surface = pressure_dome_data.surface
    if not surface.valid then return end
    local position = pressure_dome_data.position
    local x, y = position.x, position.y
    local force = pressure_dome_data.entity.force_index

    local top = surface.create_entity{
        name = 'h2o-pressure-dome-collision',
        position = {x, y - size},
        force = force_index,
        create_build_effect_smoke = false,
    }
    top.orientation = 0

    local bottom = surface.create_entity{
        name = 'h2o-pressure-dome-collision',
        position = {x, y + size},
        force = force_index,
        create_build_effect_smoke = false,
    }
    bottom.orientation = 0

    local left = surface.create_entity{
        name = 'h2o-pressure-dome-collision',
        position = {x - size, y},
        force = force_index,
        create_build_effect_smoke = false,
    }
    left.orientation = 0.25

    local right = surface.create_entity{
        name = 'h2o-pressure-dome-collision',
        position = {x + size, y},
        force = force_index,
        create_build_effect_smoke = false,
    }
    right.orientation = 0.25

    local top_right = surface.create_entity{
        name = 'h2o-pressure-dome-collision',
        position = {x + (size - 4.75), y - (size - 4.75)},
        force = force_index,
        create_build_effect_smoke = false,
    }
    top_right.orientation = 0.125

    local top_left = surface.create_entity{
        name = 'h2o-pressure-dome-collision',
        position = {x - (size - 4.75), y - (size - 4.75)},
        force = force_index,
        create_build_effect_smoke = false,
    }
    top_left.orientation = 0.375

    local bottom_right = surface.create_entity{
        name = 'h2o-pressure-dome-collision',
        position = {x + (size - 4.75), y + (size - 4.75)},
        force = force_index,
        create_build_effect_smoke = false,
    }
    bottom_right.orientation = 0.375

    local bottom_left = surface.create_entity{
        name = 'h2o-pressure-dome-collision',
        position = {x - (size - 4.75), y + (size - 4.75)},
        force = force_index,
        create_build_effect_smoke = false,
    }
    bottom_left.orientation = 0.125

    pressure_dome_data.collision_boxes = {
        top,
        bottom,
        left,
        right,
        top_right,
        top_left,
        bottom_right,
        bottom_left,
    }

    for _, e in pairs(pressure_dome_data.collision_boxes) do
        e.active = false
    end
end

h2o.on_event('on_built', function(event)
    local entity = event.entity or event.created_entity
    if not entity.valid or entity.name ~= 'h2o-pressure-dome' then return end

    local pressure_dome_data = {
        entity = entity,
        unit_number = entity.unit_number,
        position = entity.position,
        surface = entity.surface,
        contained_entities = {},
        collision_boxes = {},
    }
    place_collision_boxes(pressure_dome_data)
    place_tiles(pressure_dome_data)

    global.pressure_domes[entity.unit_number] = pressure_dome_data
end)

local function delete_invalid_entities_from_contained_entities_list(pressure_dome_data, additional_entity_to_delete)
    local dome = pressure_dome_data.entity
    if not dome.valid then return end

    local contained_entities = pressure_dome_data.contained_entities
    for _, e in pairs(contained_entities) do
        if not e.valid or e == additional_entity_to_delete then
            local new_contained = {}
            for _, e in pairs(contained_entities) do
                if e.valid and e ~= additional_entity_to_delete then
                    new_contained[#new_contained + 1] = e
                end
            end
            pressure_dome_data.contained_entities = new_contained
            break
        end
    end

    if table_size(pressure_dome_data.contained_entities) == 0 then
        dome.minable = true
    end
end

h2o.on_event('on_destroyed', function(event)
    local entity = event.entity
    if not entity.valid then return end
    local unit_number = entity.unit_number

    local dome = global.pressure_domes[unit_number]
    if dome then
        global.pressure_domes[unit_number] = nil
        unplace_tiles(dome)
        return
    end

    local surface = entity.surface
    local surface_name = surface.name
    if surface_name ~= h2o.MARAXSIS_SURFACE_NAME and surface_name ~= h2o.TRENCH_SURFACE_NAME then
        return
    end

    local new_pressure_domes = nil

    for _, pressure_dome_data in pairs(global.pressure_domes) do
        local dome = pressure_dome_data.entity
        
        if dome.valid then
            delete_invalid_entities_from_contained_entities_list(pressure_dome_data, entity)
        elseif not new_pressure_domes then
            new_pressure_domes = {}
            for _, pressure_dome_data in pairs(global.pressure_domes) do
                local dome = pressure_dome_data.entity
                if dome.valid then
                    pressure_dome_data.unit_number = dome.unit_number
                    new_pressure_domes[dome.unit_number] = pressure_dome_data
                end
            end
        end
    end

    if new_pressure_domes then
        global.pressure_domes = new_pressure_domes
    end
end)
