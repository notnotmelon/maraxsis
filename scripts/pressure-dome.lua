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

maraxsis.on_event(maraxsis.events.on_init(), function()
    if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["add_blacklist_name"] then
        remote.call("PickerDollies", "add_blacklist_name", "maraxsis-pressure-dome")
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

local FLOODED_STATUS = {
    diode = defines.entity_status_diode.red,
    label = {"entity-status.flooded"},
}
local DOME_DISABLEABLE_TYPES = maraxsis.DOME_DISABLEABLE_TYPES
local DOME_EXCLUDED_FROM_DISABLE = maraxsis.DOME_EXCLUDED_FROM_DISABLE
local function disable_due_to_dome_low_pressure(entity, powered_and_has_fluid)
    if not entity.valid or not entity.is_updatable then return end
    if not DOME_DISABLEABLE_TYPES[entity.type] or DOME_EXCLUDED_FROM_DISABLE[entity.name] then return end

    local should_be_active = not not powered_and_has_fluid
    if entity.active == should_be_active then return end
    entity.active = should_be_active

    storage.flooded_warning_info_icons = storage.flooded_warning_info_icons or {}
    local warning = storage.flooded_warning_info_icons[entity.unit_number]

    if should_be_active then
        entity.custom_status = nil
        if warning then
            warning.destroy()
            storage.flooded_warning_info_icons[entity.unit_number] = nil
        end
    else
        entity.custom_status = FLOODED_STATUS
        if not warning then
            warning = rendering.draw_sprite {
                sprite = "maraxsis-flooded-warning",
                target = entity,
                surface = entity.surface_index,
                target_offset = {0, -1.5},
            }
            storage.flooded_warning_info_icons[entity.unit_number] = warning
        end
    end
end

maraxsis.on_nth_tick(66667, function()
    local new_warning_icons = {}
    for k, warning_icon in pairs(storage.flooded_warning_info_icons or {}) do
        if warning_icon.valid then
            new_warning_icons[k] = warning_icon
        end
    end
    storage.flooded_warning_info_icons = new_warning_icons
end)

local function create_dome_light(pressure_dome_data)
    local surface = pressure_dome_data.surface
    if not surface.valid then return end

    local light = surface.create_entity {
        name = "maraxsis-pressure-dome-lamp",
        position = pressure_dome_data.position,
        force = pressure_dome_data.force_index,
        quality = pressure_dome_data.quality,
        create_build_effect_smoke = false,
    }

    light.minable_flag = false
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
        quality = light.quality,
        create_build_effect_smoke = false,
    }

    combinator.minable_flag = false
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
        if e.valid then
            local quality = e.quality.name
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

local mobile_entities = {
    ["unit"] = true,
    ["spider-unit"] = true,
    ["car"] = true,
    ["spider-vehicle"] = true,
    ["cargo-wagon"] = true,
    ["fluid-wagon"] = true,
    ["locomotive"] = true,
    ["artillery-wagon"] = true,
    ["logistic-robot"] = true,
    ["construction-robot"] = true,
    ["combat-robot"] = true,
    ["character"] = true,
    ["segmented-unit"] = true,
    ["segment"] = true,
    ["spider-leg"] = true,
    ["fish"] = true,
    ["elevated-curved-rail-a"] = true,
    ["elevated-curved-rail-b"] = true,
    ["elevated-half-diagonal-rail"] = true,
    ["elevated-straight-rail"] = true,
}

maraxsis.on_event(maraxsis.events.on_built(), function(event)
    local entity = event.entity or event.created_entity
    if not entity.valid or entity.name == "maraxsis-pressure-dome" then return end
    if mobile_entities[entity.type] then return end
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
                    collision_box.minable_flag = false
                end
            end
            disable_due_to_dome_low_pressure(entity, pressure_dome_data.powered_and_has_fluid)
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

local DEFAULT_MARAXSIS_TILE = "sand-3-underwater"
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

local function place_collision_boxes(pressure_dome_data, health, player)
    local surface = pressure_dome_data.surface
    if not surface.valid then return end
    local position = pressure_dome_data.position
    local x, y = position.x, position.y
    local force = pressure_dome_data.force_index
    local quality = pressure_dome_data.quality

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
            quality = quality,
            create_build_effect_smoke = false,
            direction = orientation,
            player = player -- setup the undo queue
        }
        collision_box.health = health
        collision_box.active = false
        collision_box.operable = false -- vanilla bug: operable does nothing on cars
        table.insert(pressure_dome_data.collision_boxes, collision_box)

        player = nil -- only setup the undo queue for 1 entity. do not spam the undo queue
    end
end

local function intersects_with_2x2_box(entity, box_location)
    local corners = get_four_corners(entity)

    local box_x, box_y = box_location.x, box_location.y
    local box_left_top = {x = box_x - 1, y = box_y - 1}
    local box_right_bottom = {x = box_x + 1, y = box_y + 1}

    for _, corner in pairs(corners) do
        local x, y = corner.x, corner.y
        if x >= box_left_top.x and x <= box_right_bottom.x and y >= box_left_top.y and y <= box_right_bottom.y then
            return true
        end
    end

    return false
end

local function check_can_build_dome(surface, position)
    local error_message = nil
    local contained_entities = {}
    local colliding_entities = {}
    local x, y = position.x, position.y

    local entities_inside_square = surface.find_entities_filtered {
        area = {
            {x - size, y - size},
            {x + size, y + size},
        },
        collision_mask = {["object"] = true, [maraxsis_trench_entrance_collision_mask] = true},
    }

    for _, e in pairs(entities_inside_square) do
        local count = count_points_in_dome({position = position}, e)
        if count == 0 then
            -- pass
        elseif count == 4 then
            local layers = e.prototype.collision_mask.layers
            if e.force.name == "neutral" or layers[maraxsis_dome_collision_mask] then
                error_message = error_message or {"cant-build-reason.entity-in-the-way", e.localised_name}
                colliding_entities[#colliding_entities + 1] = e
            elseif layers.object and intersects_with_2x2_box(e, position) then
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
            local tile_collision = tile.collides_with("object")
                or tile.collides_with(maraxsis_lava_collision_mask)
                or tile.collides_with(maraxsis_trench_entrance_collision_mask)

            if tile_collision and is_point_in_polygon(xx - x + 0.5, yy - y) then
                return false, colliding_entities, {"cant-build-reason.entity-in-the-way", tile.prototype.localised_name}, true
            end
        end
    end

    if error_message then
        return false, colliding_entities, error_message
    else
        return true, contained_entities, nil
    end
end

local function place_regulator(pressure_dome_data)
    local surface = pressure_dome_data.surface
    if not surface.valid then return end
    local position = pressure_dome_data.position
    local x, y = position.x, position.y
    local force = pressure_dome_data.force_index
    local quality = pressure_dome_data.quality

    local regulator = pressure_dome_data.regulator
    if not regulator or not regulator.valid then
        storage.script_placing_the_regulator = true
        regulator = surface.create_entity {
            name = "maraxsis-regulator",
            position = {x, y},
            quality = quality,
            force = force,
            create_build_effect_smoke = false,
            raise_built = true,
        }
        storage.script_placing_the_regulator = false
    end

    regulator.minable_flag = false
    regulator.destructible = false
    regulator.operable = true

    pressure_dome_data.regulator = regulator

    local regulator_fluidbox = pressure_dome_data.regulator_fluidbox
    if not regulator_fluidbox or not regulator_fluidbox.valid then
        regulator_fluidbox = surface.create_entity {
            name = "maraxsis-regulator-fluidbox-" .. quality.name,
            position = {x, y},
            force = force,
            create_build_effect_smoke = false,
        }
    end

    regulator_fluidbox.minable_flag = false
    regulator_fluidbox.destructible = false
    regulator_fluidbox.operable = false

    pressure_dome_data.regulator_fluidbox = regulator_fluidbox
end

-- ensure regulators always have the correct temperature of atmosphere (25 deg C)
maraxsis.on_nth_tick(631, function()
    for _, pressure_dome_data in pairs(storage.pressure_domes) do
        local regulator_fluidbox = pressure_dome_data.regulator_fluidbox
        if not regulator_fluidbox or not regulator_fluidbox.valid then
            place_regulator(pressure_dome_data)
        end

        local fluid = regulator_fluidbox.fluidbox[1]
        if fluid and fluid.temperature ~= 25 then
            fluid.temperature = 25
            regulator_fluidbox.fluidbox[1] = fluid
        end
    end
end)

--- sorts all domes by y position and re-draws.
--- this prevents Z-fighting.
--- https://github.com/notnotmelon/maraxsis/issues/174
local function rerender_all_domes()
    local sorted_by_y_position = {}
    for _, pressure_dome_data in pairs(storage.pressure_domes) do
        table.insert(sorted_by_y_position, pressure_dome_data)
    end
    table.sort(sorted_by_y_position, function(a, b)
        return a.position.y < b.position.y
    end)
    
    storage.pressure_domes = {}
    for _, pressure_dome_data in pairs(sorted_by_y_position) do
        local surface = pressure_dome_data.surface
        if surface.valid then
            pressure_dome_data.entity.destroy()
            pressure_dome_data.opacity = pressure_dome_data.opacity or 255
            local opacity = pressure_dome_data.opacity
            local entity = rendering.draw_sprite {
                sprite = "maraxsis-pressure-dome-sprite",
                render_layer = "higher-object-above",
                target = pressure_dome_data.position,
                surface = pressure_dome_data.surface,
            }
            entity.color = {opacity, opacity, opacity, opacity}
            pressure_dome_data.entity = entity
            pressure_dome_data.unit_number = entity.id
            storage.pressure_domes[entity.id] = pressure_dome_data
        else
            storage.pressure_domes[pressure_dome_data.unit_number] = pressure_dome_data
        end
    end
end

maraxsis.on_event(maraxsis.events.on_built(), function(event)
    local entity = event.entity
    if not entity.valid or entity.name ~= "maraxsis-pressure-dome" then return end
    local player = event.player_index and game.get_player(event.player_index)

    local surface, position = entity.surface, entity.position
    local can_build, contained_entities, error_msg, tile_collision = check_can_build_dome(surface, position)
    local force_index = entity.force_index
    local quality = entity.quality

    if tile_collision then
        maraxsis.cancel_creation(entity, player and player.index, error_msg)
        return
    end

    if not can_build then
        local successfully_cleared_area = true
        local to_unmark = {}
        local undo_index = 0
        for _, colliding_entity in pairs(contained_entities) do
            if colliding_entity.valid and not colliding_entity.to_be_deconstructed() then
                local deconstructed
                if player then
                    deconstructed = pcall(colliding_entity.order_deconstruction, entity.force, player, undo_index)
                    undo_index = 1
                else
                    deconstructed = colliding_entity.order_deconstruction(entity.force)
                end
                successfully_cleared_area = successfully_cleared_area and deconstructed
                if deconstructed then to_unmark[#to_unmark + 1] = colliding_entity end
            end
        end
        if not successfully_cleared_area then
            for _, colliding_entity in pairs(to_unmark) do
                if colliding_entity.valid then colliding_entity.cancel_deconstruction(entity.force) end
            end
        end

        local tags = entity.tags
        maraxsis.cancel_creation(entity, player and player.index, error_msg)

        if successfully_cleared_area then
            surface.create_entity {
                name = "entity-ghost",
                inner_name = "maraxsis-pressure-dome",
                tags = tags,
                force = force_index,
                position = position,
                player = player,
                quality = quality,
            }
        end
        return
    end

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
        quality = quality,
        contained_entities = contained_entities,
        force_index = force_index,
        collision_boxes = {},
    }

    create_dome_light(pressure_dome_data)
    update_combinator(pressure_dome_data)
    place_collision_boxes(pressure_dome_data, health, player)
    place_tiles(pressure_dome_data)
    place_regulator(pressure_dome_data)

    if table_size(contained_entities) ~= 0 then
        for _, e in pairs(pressure_dome_data.collision_boxes) do
            e.minable_flag = false
        end
    end

    storage.pressure_domes[entity.id] = pressure_dome_data
    rerender_all_domes()
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
                collision_box.minable_flag = true
            end
        end
    end
end

local function destroy_collision_boxes(pressure_dome_data)
    for _, collision_box in pairs(pressure_dome_data.collision_boxes) do
        collision_box.destroy()
    end
    pressure_dome_data.collision_boxes = {}

    if pressure_dome_data.regulator then
        pressure_dome_data.regulator.destroy()
        pressure_dome_data.regulator = nil
    end

    if pressure_dome_data.regulator_fluidbox then
        pressure_dome_data.regulator_fluidbox.destroy()
        pressure_dome_data.regulator_fluidbox = nil
    end
end

local function bigass_explosion(surface, x, y) -- this looks really stupid. too bad!
    if not surface.valid then return end
    x = x + math.random(-5, 5)
    y = y + math.random(-5, 5)
    surface.create_entity {
        name = "cargo-landing-pad-remnants",
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

maraxsis.on_event(maraxsis.events.on_destroyed(), function(event)
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

maraxsis.on_event(maraxsis.events.on_entity_clicked(), function(event)
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
        light = pressure_dome_data.light
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

-- handle the case of ghost pressure domes being built via blueprint
maraxsis.on_event(maraxsis.events.on_built(), function(event)
    if storage.script_placing_the_regulator then return end

    local entity = event.entity
    if not entity.valid then return end
    local is_ghost = entity.name == "entity-ghost" -- this would only be false in the editor mode.

    local name = is_ghost and entity.ghost_name or entity.name
    if name ~= "maraxsis-regulator" then return end
    local quality = entity.quality
    local position = entity.position
    local surface = entity.surface
    local force_index = entity.force_index
    local tags = entity.tags
    local player = event.player_index and game.get_player(event.player_index)

    entity.destroy()

    local new_dome_ghost = surface.create_entity {
        name = is_ghost and "entity-ghost" or "maraxsis-pressure-dome",
        inner_name = is_ghost and "maraxsis-pressure-dome" or nil,
        tags = tags,
        force = force_index,
        position = position,
        player = player,
        quality = quality,
        raise_built = true,
    }
end)

maraxsis.on_nth_tick(73, function()
    for _, dome_data in pairs(storage.pressure_domes) do
        local regulator = dome_data.regulator
        if not regulator or not regulator.valid then goto continue end
        local regulator_fluidbox = dome_data.regulator_fluidbox
        if not regulator_fluidbox or not regulator_fluidbox.valid then goto continue end

        local powered_and_has_fluid = (regulator_fluidbox.get_fluid_count("maraxsis-atmosphere") > 0) and regulator_fluidbox.is_crafting()
        if powered_and_has_fluid == dome_data.powered_and_has_fluid then goto continue end

        for _, e in pairs(dome_data.contained_entities) do
            disable_due_to_dome_low_pressure(e, powered_and_has_fluid)
        end

        dome_data.powered_and_has_fluid = powered_and_has_fluid

        ::continue::
    end
end)

-- https://github.com/notnotmelon/maraxsis/issues/34
maraxsis.on_event(maraxsis.events.on_mined_tile(), function(event)
    local dome_tiles_to_rebuild = {}
    for _, tile in pairs(event.tiles) do
        local name = tile.old_tile.name
        if name == PRESSURE_DOME_TILE then
            dome_tiles_to_rebuild[#dome_tiles_to_rebuild + 1] = {position = tile.position, name = name}
        end
    end
    if not dome_tiles_to_rebuild[1] then return end
    local surface = game.get_surface(event.surface_index)
    surface.set_tiles(dome_tiles_to_rebuild, true, false, false, false)
end)

maraxsis.on_nth_tick(5, function(event)
    for _, pressure_dome_data in pairs(storage.pressure_domes) do
        local entity = pressure_dome_data.entity
        local surface = pressure_dome_data.surface
        if not entity.valid or not surface.valid then goto continue end

        local opacity = pressure_dome_data.opacity or 255
        local dome_position = pressure_dome_data.position
        local x, y = dome_position.x, dome_position.y

        local any_player_inside = false
        for _, player in pairs(game.connected_players) do
            local player_position = player.position
            if player.surface == surface and is_point_in_polygon(player_position.x - x, player_position.y - y) then
                any_player_inside = true
                break
            end
        end

        if any_player_inside then
            opacity = math.max(opacity - 16, 60)
        else
            opacity = math.min(opacity + 16, 255)
        end

        if opacity ~= pressure_dome_data.opacity then
            entity.color = {opacity, opacity, opacity, opacity}
            pressure_dome_data.opacity = opacity
        end
        ::continue::
    end
end)