local TRENCH_MOVEMENT_FACTOR = h2o.TRENCH_MOVEMENT_FACTOR
local SUBMARINES = h2o.SUBMARINES

local function exit_submarine(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end
    local selected = player.selected
    local selected_submarine = selected and selected.valid and SUBMARINES[selected.name]
    local vehicle = player.vehicle

    if not vehicle or not SUBMARINES[vehicle.name] or selected_submarine then return end

    if not player.character then return end
    local safe_position = player.surface.find_non_colliding_position(player.character.name, player.position, 15, 0.5, false)
    player.vehicle.set_driver(nil)
    player.driving = false
    if not safe_position then return end
    player.teleport(safe_position)
end
h2o.register_delayed_function('exit_submarine', exit_submarine)

---when the player presses 'enter' on a submarine, should it succeed?
---@param player LuaPlayer
---@param submarine LuaEntity?
---@return boolean
local function can_enter_submarine(player, submarine)
    if not (submarine and submarine.valid and SUBMARINES[submarine.name]) then return false end
    if player.vehicle == submarine then return false end
    if player.surface ~= submarine.surface or not player.force.is_friend(submarine.force_index) then return false end

    local reach = player.character and player.character.reach_distance or 0
    reach = reach * 3
    local a = player.position
    local b = submarine.position
    local distance = math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
    if distance > reach then return false end

    local has_driver = not not submarine.get_driver()
    local has_passenger = not not submarine.get_passenger()
    if has_driver and has_passenger then return false end

    return true
end

---@param player LuaPlayer
---@param submarine LuaEntity
local function enter_submarine(player, submarine)
    if not player.valid or not submarine.valid then return end

    if submarine.get_driver() == player or (player.is_player() and submarine.get_driver() == player.character) then return end

    local has_driver = not not submarine.get_driver()
    local has_passenger = not not submarine.get_passenger()

    if has_driver and has_passenger then
        return
    elseif has_driver then
        submarine.set_passenger(player)
    else
        submarine.set_driver(player)
    end
    storage.breath[player.index] = nil
end
h2o.register_delayed_function('enter_submarine', enter_submarine)

---determines if the submarine should rise to the surface or sink to the bottom. returns nil if surface transfer is impossible
---@param submarine LuaEntity
---@return LuaSurface?, MapPosition?
local function determine_submerge_direction(submarine)
    local position = submarine.position
    local surface = submarine.surface
    local surface_name = surface.name
    local prototype = h2o.prototypes[surface_name]
    if not prototype then error('no prototype for surface ' .. surface_name) end

    local opposite_surface_name = h2o.MARAXSIS_GET_OPPOSITE_SURFACE[surface_name]
    local target_surface = h2o.prototypes[opposite_surface_name].get_surface()

    if surface_name == h2o.MARAXSIS_SURFACE_NAME then
        local tile_at_surface = surface.get_tile(position.x, position.y)
        if not tile_at_surface.valid or tile_at_surface.name ~= 'trench-entrance' then return nil end
        local target_position = {x = position.x * TRENCH_MOVEMENT_FACTOR, y = position.y * TRENCH_MOVEMENT_FACTOR}
        target_surface.request_to_generate_chunks(target_position, 1)
        target_surface.force_generate_chunk_requests()
        target_position = target_surface.find_non_colliding_position(submarine.name, target_position, 40, 0.5, false)
        if not target_position then return nil end
        return target_surface, target_position
    elseif surface_name == h2o.TRENCH_SURFACE_NAME then
        local target_position = {x = position.x / TRENCH_MOVEMENT_FACTOR, y = position.y / TRENCH_MOVEMENT_FACTOR}
        target_surface.request_to_generate_chunks(target_position, 1)
        target_surface.force_generate_chunk_requests()
        local tile_at_surface = target_surface.get_tile(target_position.x, target_position.y)
        if tile_at_surface.valid and tile_at_surface.name ~= 'trench-entrance' then
            --[[surface.create_entity {
                name = 'flying-text',
                position = position,
                text = {'maraxsis.rocks-in-the-way'},
            }--]] -- todo: readd
            return nil
        end
        return target_surface, target_position
    end

    return nil
end

---transfers a submarine between surfaces
---@param submarine LuaEntity
---@return boolean true if the submarine was successfully transferred
local function decend_or_ascend(submarine)
    local target_surface, target_position = determine_submerge_direction(submarine)
    if not target_surface then return false end
    if not target_position then return false end

    local passenger, driver = submarine.get_passenger(), submarine.get_driver()

    if passenger and not passenger.is_player() then
        passenger = passenger.player
    end

    if driver and not driver.is_player() then
        driver = driver.player
    end

    submarine.teleport(target_position, target_surface, true)

    if passenger then
        passenger.teleport(target_position, target_surface, true)
        h2o.execute_later('enter_submarine', 1, passenger, submarine)
    end

    if driver then
        driver.teleport(target_position, target_surface, true)
        h2o.execute_later('enter_submarine', 1, driver, submarine)
    end

    return true
end

h2o.on_event('toggle-driving', function(event)
    local player = game.get_player(event.player_index)
    if not player then return end
    local selected = player.selected
    local selected_submarine = selected and selected.valid and SUBMARINES[selected.name]
    local submarine = player.vehicle
    local surface = player.surface

    -- case 1: player is hovering the sub and trying to exit. if they are in a trench we need to block them from leaving the sub
    if submarine and SUBMARINES[submarine.name] and selected and selected.valid and selected == submarine then
        if not decend_or_ascend(submarine) then
            if surface.name == h2o.TRENCH_SURFACE_NAME then
                h2o.execute_later('enter_submarine', 1, player, submarine)
            end
        end
    -- case 2: player is not hovering the sub but trying to exit.
    -- if they are in a trench we need to block them from leaving the sub otherwise search nearby tiles for a safe exit point
    elseif submarine and SUBMARINES[submarine.name] and not selected_submarine then
        if not decend_or_ascend(submarine) then
            if surface.name == h2o.TRENCH_SURFACE_NAME then
                h2o.execute_later('enter_submarine', 1, player, submarine)
            else
                h2o.execute_later('exit_submarine', 1, event)
            end
        end
    -- case 3: player is hovering the sub and trying to enter. the vanilla vechicle enter range is too low for water vehicles so we artificially increase it
    elseif can_enter_submarine(player, selected) then
        enter_submarine(player, selected)
    end
end)