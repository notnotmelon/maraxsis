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

local PRESSURE_DOME_TILE = "maraxsis-pressure-dome-tile"

maraxsis.on_event("on_init", function()
    if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["add_blacklist_name"] then
        remote.call("PickerDollies", "add_blacklist_name", "maraxsis-pressure-dome")
    end
    for mask in pairs(prototypes.tile[PRESSURE_DOME_TILE].collision_mask.layers) do
        storage.dome_collision_mask = mask
        break
    end

    storage.pressure_domes = storage.pressure_domes or {}
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
        collision_mask = {layers = {["object"] = true},},
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

local function get_four_corners(entity)
    local position = entity.position
    local x, y = position.x, position.y
    local collision_box = entity.prototype.collision_box
    local orientation = entity.orientation

    if entity.type == "straight-rail" then
        orientation = (orientation + 0.25) % 1
    elseif entity.type == "cliff" then
        collision_box = {
            left_top = {x = -2, y = -2},
            right_bottom = {x = 2, y = 2},
        }
    else -- expand the collision box to the actual tile size
        collision_box = {
            left_top = {x = math.floor(collision_box.left_top.x * 2) / 2, y = math.floor(collision_box.left_top.y * 2) / 2},
            right_bottom = {x = math.ceil(collision_box.right_bottom.x * 2) / 2, y = math.ceil(collision_box.right_bottom.y * 2) / 2},
        }
    end

    local left_top = collision_box.left_top
    local right_bottom = collision_box.right_bottom

    if orientation == 0 then
        return {
            {x = x + left_top.x,     y = y + left_top.y},
            {x = x + right_bottom.x, y = y + left_top.y},
            {x = x + right_bottom.x, y = y + right_bottom.y},
            {x = x + left_top.x,     y = y + right_bottom.y},
        }
    end

    local cos = math.cos(orientation * 2 * math.pi)
    local sin = math.sin(orientation * 2 * math.pi)

    local corners = {}
    for _, corner in pairs {
        {x = left_top.x,     y = left_top.y},
        {x = right_bottom.x, y = left_top.y},
        {x = right_bottom.x, y = right_bottom.y},
        {x = left_top.x,     y = right_bottom.y},
    } do
        local corner_x, corner_y = corner.x, corner.y
        corners[#corners + 1] = {
            x = x + corner_x * cos - corner_y * sin,
            y = y + corner_x * sin + corner_y * cos,
        }
    end
    return corners
end

local function count_points_in_dome(pressure_dome_data, entity)
    local dome_position = pressure_dome_data.position
    local x, y = dome_position.x, dome_position.y

    local count = 0
    for _, entity_corner in pairs(get_four_corners(entity)) do
        if is_point_in_polygon(entity_corner.x - x, entity_corner.y - y) then
            count = count + 1
        end
    end
    return count
end

local function create_dome_light(pressure_dome_data)
    local surface = pressure_dome_data.surface
    if not surface.valid then return end

    local light = surface.create_entity {
        name = "maraxsis-pressure-dome-lamp",
        position = pressure_dome_data.position,
        force = pressure_dome_data.force_index,
        create_build_effect_smoke = false,
    }

    light.minable = false
    light.destructible = false

    local control_behavior = light.get_or_create_control_behavior()
    control_behavior.use_colors = true

    pressure_dome_data.light = light
end

local function create_dome_combinator(pressure_dome_data)
    local light = pressure_dome_data.light
    if not light or not light.valid then
        create_dome_light(pressure_dome_data)
    end

    local combinator = light.surface.create_entity {
        name = "maraxsis-pressure-dome-combinator",
        position = light.position,
        force = light.force,
        create_build_effect_smoke = false,
    }

    combinator.minable = false
    combinator.destructible = false
    combinator.operable = false

    local red = combinator.get_wire_connector(defines.wire_connector_id.circuit_red, true)
    local green = combinator.get_wire_connector(defines.wire_connector_id.circuit_green, true)
    local light_red = light.get_wire_connector(defines.wire_connector_id.circuit_red, false)
    local light_green = light.get_wire_connector(defines.wire_connector_id.circuit_green, false)

    local red_success = red.connect_to(light_red, false)
    local green_success = green.connect_to(light_green, false)

    assert(red_success, "Failed to connect red wire to the dome light. Please report this!")
    assert(green_success, "Failed to connect green wire to the dome light. Please report this!")

    pressure_dome_data.combinator = combinator
    return combinator
end

local function update_combinator(pressure_dome_data)
    local combinator = pressure_dome_data.combinator
    if not combinator or not combinator.valid then
        combinator = create_dome_combinator(pressure_dome_data)
    end

    local all_machines_inside = {}
    for _, e in pairs(pressure_dome_data.contained_entities) do
        local quality = e.quality.name
        if e.valid then
            for _, item_to_place in pairs(e.prototype.items_to_place_this or {}) do
                all_machines_inside[item_to_place.name] = all_machines_inside[item_to_place.name] or {}
                all_machines_inside[item_to_place.name][quality] = (all_machines_inside[item_to_place.name][quality] or 0) + 1
            end
        end
    end

    local control_behavior = combinator.get_or_create_control_behavior()

    if not control_behavior.get_section(1) then
        control_behavior.add_section()
    end

    local section = control_behavior.get_section(1)
    section.group = ""

    local parameters = {}
    for name, by_quality in pairs(all_machines_inside) do
        for quality, count in pairs(by_quality) do
            parameters[#parameters + 1] = {
                value = {type = "item", name = name, quality = quality},
                min = count,
                max = count,
            }
        end
    end
    
    section.filters = parameters
end

maraxsis.on_event("on_built", function(event)
    local entity = event.entity or event.created_entity
    if not entity.valid or entity.name == "maraxsis-pressure-dome" then return end
    local surface = entity.surface

    for _, pressure_dome_data in pairs(storage.pressure_domes) do
        local dome = pressure_dome_data.entity
        if not dome.valid or dome.surface ~= surface then goto continue end

        local points_in_dome = count_points_in_dome(pressure_dome_data, entity)
        if points_in_dome == 0 then
            goto continue
        elseif points_in_dome == 4 then
            for _, collision_box in pairs(pressure_dome_data.collision_boxes) do
                if collision_box.valid then
                    collision_box.minable = false
                end
            end
            table.insert(pressure_dome_data.contained_entities, entity)
            update_combinator(pressure_dome_data)
        else
            maraxsis.cancel_creation(entity, event.player_index, {"cant-build-reason.entity-in-the-way", prototypes.entity["maraxsis-pressure-dome"].localised_name})
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
            if is_point_in_polygon(xx + 0.5, yy) then
                local x, y = x + xx, y + yy
                tiles[#tiles + 1] = {name = PRESSURE_DOME_TILE, position = {x, y}}
            end
        end
    end

    surface.set_tiles(tiles, true, false, true, false)
end

local DEFAULT_MARAXSIS_TILE = "dirt-5-underwater"
local function unplace_tiles(pressure_dome_data)
    local surface = pressure_dome_data.surface
    if not surface.valid then return end
    local position = pressure_dome_data.position
    local x, y = position.x, position.y

    local tile_to_unplace
    if surface.platform then
        tile_to_unplace = "space-platform-foundation"
    end

    local area = {
        {x - size, y - size},
        {x + size, y + size},
    }

    local tiles_in_square = surface.find_tiles_filtered {
        area = area,
        name = PRESSURE_DOME_TILE,
    }

    local tiles = {}

    for _, tile in pairs(tiles_in_square) do
        local tile_position = tile.position
        local xx, yy = tile_position.x, tile_position.y
        if is_point_in_polygon(xx - x + 0.5, yy - y) then
            tiles[#tiles + 1] = {name = tile_to_unplace or tile.hidden_tile or DEFAULT_MARAXSIS_TILE, position = {xx, yy}}
        end
    end

    surface.set_tiles(tiles, true, false, true, false)
    if not surface.platform then
        surface.destroy_decoratives {
            area = area,
            name = prototypes.tile[PRESSURE_DOME_TILE].bound_decoratives,
        }
    end
end

local function place_collision_boxes(pressure_dome_data, health)
    local surface = pressure_dome_data.surface
    if not surface.valid then return end
    local position = pressure_dome_data.position
    local x, y = position.x, position.y
    local force = pressure_dome_data.force_index

    local diagonal_offset = 4.75
    local positions_and_orientations = {
        {x,                            y - size,                     defines.direction.north},
        {x,                            y + size,                     defines.direction.south},
        {x - size,                     y,                            defines.direction.east},
        {x + size,                     y,                            defines.direction.west},
        {x + (size - diagonal_offset), y - (size - diagonal_offset), defines.direction.northeast},
        {x - (size - diagonal_offset), y - (size - diagonal_offset), defines.direction.southeast},
        {x + (size - diagonal_offset), y + (size - diagonal_offset), defines.direction.southeast},
        {x - (size - diagonal_offset), y + (size - diagonal_offset), defines.direction.northeast},
    }

    for _, pos_and_orient in pairs(positions_and_orientations) do
        local pos_x, pos_y, orientation = pos_and_orient[1], pos_and_orient[2], pos_and_orient[3]
        local collision_box = surface.create_entity {
            name = "maraxsis-pressure-dome-collision",
            position = {pos_x, pos_y},
            force = force,
            create_build_effect_smoke = false,
            direction = orientation
        }
        collision_box.health = health
        collision_box.active = false
        collision_box.operable = false -- vanilla bug: operable does nothing on cars
        table.insert(pressure_dome_data.collision_boxes, collision_box)
    end
end

local function check_can_build_dome(entity)
    local error_message = nil
    local contained_entities = {}
    local colliding_entities = {}
    local surface = entity.surface
    local position = entity.position
    local x, y = position.x, position.y

    local entities_inside_square = surface.find_entities_filtered {
        area = {
            {x - size, y - size},
            {x + size, y + size},
        },
        collision_mask = {["object"] = true},
    }

    for _, e in pairs(entities_inside_square) do
        local count = count_points_in_dome({position = position}, e)
        if count == 0 then
            -- pass
        elseif count == 4 then
            if e.force.name == "neutral" or e.prototype.collision_mask.layers[storage.dome_collision_mask] then
                error_message = error_message or {"cant-build-reason.entity-in-the-way", e.localised_name}
                colliding_entities[#colliding_entities + 1] = e
            else
                contained_entities[#contained_entities + 1] = e
            end
        else
            error_message = error_message or {"cant-build-reason.entity-in-the-way", e.localised_name}
            colliding_entities[#colliding_entities + 1] = e
        end
    end

    for xx = -math.floor(size) + x, math.floor(size) + x do
        for yy = -math.floor(size) + y, math.floor(size) + y do
            local tile = surface.get_tile(xx, yy)
            if tile.collides_with("water_tile") then
                return false, colliding_entities, {"cant-build-reason.entity-in-the-way", tile.prototype.localised_name}
            end
        end
    end

    if error_message then
        return false, colliding_entities, error_message
    else
        return true, contained_entities, nil
    end
end

local ALLOWED_CONTROLLERS = {
    [defines.controllers.character] = true,
    [defines.controllers.god] = true,
    [defines.controllers.cutscene] = true,
}
local function get_player_from_trigger_effect(event)
    local entity = event.source_entity
    local player = entity.last_user
    if not player then return nil end

    if not ALLOWED_CONTROLLERS[player.controller_type] then return nil end
    if player.surface_index ~= entity.surface.index then return nil end

    return player
end

maraxsis.on_event(defines.events.on_script_trigger_effect, function(event)
    if event.effect_id ~= "on_built_maraxsis_pressure_dome" then return end
    local entity = event.source_entity
    if not entity.valid or entity.name ~= "maraxsis-pressure-dome" then return end
    local player = get_player_from_trigger_effect(event)

    local can_build, contained_entities, error_msg = check_can_build_dome(entity)
    if not can_build then
        local successfully_cleared_area = true
        local to_unmark = {}
        for _, colliding_entity in pairs(contained_entities) do
            if not colliding_entity.to_be_deconstructed() then
                local deconstructed = colliding_entity.order_deconstruction(entity.force)
                successfully_cleared_area = successfully_cleared_area and deconstructed
                if deconstructed then to_unmark[#to_unmark + 1] = colliding_entity end
            end
        end
        if not successfully_cleared_area then
            for _, colliding_entity in pairs(to_unmark) do
                colliding_entity.cancel_deconstruction(entity.force)
            end
        end

        local tags = entity.tags
        local surface = entity.surface
        local force_index = entity.force_index
        local position = entity.position
        maraxsis.cancel_creation(entity, player and player.index, error_msg)

        if successfully_cleared_area then
            surface.create_entity {
                name = "entity-ghost",
                inner_name = "maraxsis-pressure-dome",
                tags = tags,
                force = force_index,
                position = position,
                player = player,
            }
        end
        return
    end

    local position = entity.position
    local surface = entity.surface
    local force_index = entity.force_index
    local health = entity.health
    entity.destroy()
    entity = rendering.draw_sprite {
        sprite = "maraxsis-pressure-dome-sprite",
        render_layer = "higher-object-above",
        target = position,
        surface = surface,
    }

    local pressure_dome_data = {
        entity = entity,
        unit_number = entity.id,
        position = position,
        surface = surface,
        contained_entities = contained_entities,
        force_index = force_index,
        collision_boxes = {},
    }

    create_dome_light(pressure_dome_data)
    update_combinator(pressure_dome_data)
    place_collision_boxes(pressure_dome_data, health)
    place_tiles(pressure_dome_data)

    if table_size(contained_entities) ~= 0 then
        for _, e in pairs(pressure_dome_data.collision_boxes) do
            e.minable = false
        end
    end

    storage.pressure_domes[entity.id] = pressure_dome_data
end)

local function delete_invalid_entities_from_contained_entities_list(pressure_dome_data, additional_entity_to_delete)
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
            update_combinator(pressure_dome_data)
            break
        end
    end

    if table_size(pressure_dome_data.contained_entities) == 0 then
        for _, collision_box in pairs(pressure_dome_data.collision_boxes) do
            if collision_box.valid then
                collision_box.minable = true
            end
        end
    end
end

local function destroy_collision_boxes(pressure_dome_data)
    for _, collision_box in pairs(pressure_dome_data.collision_boxes) do
        collision_box.destroy()
    end
    pressure_dome_data.collision_boxes = {}
end

local function bigass_explosion(surface, x, y) -- this looks really stupid. too bad!
    if not surface.valid then return end
    x = x + math.random(-5, 5)
    y = y + math.random(-5, 5)
    surface.create_entity {
        name = "kr-big-random-pipes-remnant",
        position = {x, y},
    }
    if math.random() > 0.33 then
        surface.create_entity {
            name = "nuclear-reactor-explosion",
            position = {x, y},
        }
        rendering.draw_light {
            sprite = "utility/light_medium",
            scale = 3,
            intensity = 0.5,
            target = {x, y},
            time_to_live = 60,
            surface = surface,
        }
    end
end
maraxsis.register_delayed_function("bigass_explosion", bigass_explosion)

local function random_point_in_circle(radius)
    local angle = math.random() * 2 * math.pi
    radius = math.random() * radius
    return radius * math.cos(angle), radius * math.sin(angle)
end

local function on_dome_died(event, pressure_dome_data)
    local surface = pressure_dome_data.surface
    if not surface.valid then return end
    local position = pressure_dome_data.position

    local contained_entities = pressure_dome_data.contained_entities
    for _, e in pairs(contained_entities) do
        if e.valid then
            if event.cause then
                e.die(event.force, event.cause)
            elseif event.force then
                e.die(event.force)
            else
                e.die()
            end
        end
    end

    for i = 1, #DOME_POLYGON, 2 do
        local x, y = position.x + DOME_POLYGON[i], position.y + DOME_POLYGON[i + 1]
        maraxsis.execute_later("bigass_explosion", math.random(1, 90), surface, x, y)
    end
    for i = 1, #DOME_POLYGON, 2 do
        local x, y = position.x + DOME_POLYGON[i], position.y + DOME_POLYGON[i + 1]
        maraxsis.execute_later("bigass_explosion", math.random(1, 90), surface, x, y)
    end
    for i = 1, 16 do
        local rx, ry = random_point_in_circle(size)
        maraxsis.execute_later("bigass_explosion", math.random(1, 90), surface, position.x + rx, position.y + ry)
    end
end

maraxsis.on_event("on_destroyed", function(event)
    local entity = event.entity
    if not entity.valid then return end
    local unit_number = entity.unit_number

    if entity.name == "maraxsis-pressure-dome-collision" then
        for _, pressure_dome_data in pairs(storage.pressure_domes) do
            local dome = pressure_dome_data.entity
            if dome.valid then
                for _, collision_box in pairs(pressure_dome_data.collision_boxes) do
                    if collision_box.valid and collision_box == entity then
                        entity = dome
                        unit_number = dome.id
                        goto parent_dome_found
                    end
                end
            end
        end
    end
    ::parent_dome_found::

    local pressure_dome_data = storage.pressure_domes[unit_number]
    if pressure_dome_data then
        storage.pressure_domes[unit_number] = nil
        unplace_tiles(pressure_dome_data)
        destroy_collision_boxes(pressure_dome_data)
        local light = pressure_dome_data.light
        if light then light.destroy() end
        if event.name == defines.events.on_entity_died then
            on_dome_died(event, pressure_dome_data)
        end
        entity.destroy()
        return
    end

    local surface = entity.surface
    local surface_name = surface.name
    if not maraxsis.MARAXSIS_SURFACES[surface_name] then
        return
    end

    local new_pressure_domes = nil

    for _, pressure_dome_data in pairs(storage.pressure_domes) do
        local dome = pressure_dome_data.entity

        if dome.valid then
            delete_invalid_entities_from_contained_entities_list(pressure_dome_data, entity)
        elseif not new_pressure_domes then
            new_pressure_domes = {}
            for _, pressure_dome_data in pairs(storage.pressure_domes) do
                local dome = pressure_dome_data.entity
                if dome.valid then
                    pressure_dome_data.unit_number = dome.id
                    new_pressure_domes[dome.id] = pressure_dome_data
                end
            end
        end
    end

    if new_pressure_domes then
        storage.pressure_domes = new_pressure_domes
    end
end)

local function find_pressure_dome_data_by_collision_entity(collision_box)
    for _, pressure_dome_data in pairs(storage.pressure_domes) do
        for _, cb in pairs(pressure_dome_data.collision_boxes) do
            if cb.valid and cb == collision_box then
                return pressure_dome_data
            end
        end
    end
end

maraxsis.on_event(defines.events.on_selected_entity_changed, function(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end
    local entity = player.selected
    if not entity or not entity.valid then return end

    if entity.name ~= "maraxsis-pressure-dome-collision" then return end

    local pressure_dome_data = find_pressure_dome_data_by_collision_entity(entity)
    if not pressure_dome_data then return end

    delete_invalid_entities_from_contained_entities_list(pressure_dome_data, nil)
end)

maraxsis.on_event(defines.events.on_entity_damaged, function(event)
    local entity = event.entity
    if not entity.valid then return end

    if entity.name ~= "maraxsis-pressure-dome-collision" then return end

    local pressure_dome_data = find_pressure_dome_data_by_collision_entity(entity)
    if not pressure_dome_data then return end

    for _, collision_box in pairs(pressure_dome_data.collision_boxes) do
        if collision_box.valid then
            collision_box.health = entity.health
        end
    end
end)

local function figure_out_wire_type(player)
    local cursor_stack = player.cursor_stack
    if cursor_stack and cursor_stack.valid_for_read then
        local stack_name = cursor_stack.name
        if stack_name == "red-wire" then
            return defines.wire_connector_id.circuit_red
        elseif stack_name == "green-wire" then
            return defines.wire_connector_id.circuit_green
        end
    end

    return nil
end

local sqrt = math.sqrt
local function distance(entity1, entity2)
    local x1, y1 = entity1.position.x, entity1.position.y
    local x2, y2 = entity2.position.x, entity2.position.y
    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
end

maraxsis.on_event("open-gui", function(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end
    local entity = player.selected
    if not entity or not entity.valid then return end

    if entity.name ~= "maraxsis-pressure-dome-collision" then return end

    local pressure_dome_data = find_pressure_dome_data_by_collision_entity(entity)
    if not pressure_dome_data then return end
    local light = pressure_dome_data.light
    if not light or not light.valid then
        local dome = pressure_dome_data.entity
        if not dome.valid then return end
        pressure_dome_data.light = create_dome_light(pressure_dome_data)
    end

    local wire_type = figure_out_wire_type(player)
    if not wire_type then
        player.opened = nil
        player.opened = light
        return
    end

    local drag_target = player.drag_target
    if drag_target then
        local entity = player.drag_target.target_entity
        if distance(entity, light) < 24 then
            local wire = entity.get_wire_connector(wire_type, true)
            local light_wire = light.get_wire_connector(wire_type, false)
            local success = wire.connect_to(light_wire, false)
            if not success then
                wire.disconnect_from(light_wire)
            end
        end
        return
    end

    player.selected = light
    player.drag_wire {position = light.position}
    player.selected = entity
end)
