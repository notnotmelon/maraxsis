local TRENCH_MOVEMENT_FACTOR = maraxsis.TRENCH_MOVEMENT_FACTOR
local SUBMARINES = maraxsis.SUBMARINES

maraxsis.on_event(maraxsis.events.on_built(), function(event)
    local entity = event.entity
    if not entity.valid then return end
    if not SUBMARINES[entity.name] then return end

    local color = entity.color
    local is_default = serpent.line(color) == "{a = 0.5, b = 0, g = 0.5, r = 1}"
    if is_default then
        entity.color = SUBMARINES[entity.name]
    end
end)

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
maraxsis.register_delayed_function("exit_submarine", exit_submarine)

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
    local distance = math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2)
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
maraxsis.register_delayed_function("enter_submarine", enter_submarine)

---determines if the submarine should rise to the surface or sink to the bottom. returns nil if surface transfer is impossible
---@param submarine LuaEntity
---@return LuaSurface?, MapPosition?
local function determine_submerge_direction(submarine)
    local position = submarine.position
    local surface = submarine.surface
    local surface_name = surface.name
    local prototype = maraxsis.prototypes[surface_name]
    if not prototype then error("no prototype for surface " .. surface_name) end

    local opposite_surface_name = maraxsis.MARAXSIS_GET_OPPOSITE_SURFACE[surface_name]
    local target_surface = maraxsis.prototypes[opposite_surface_name].get_surface()

    if surface_name == maraxsis.MARAXSIS_SURFACE_NAME then
        local tile_at_surface = surface.get_tile(position)
        if not tile_at_surface.valid or tile_at_surface.name ~= "maraxsis-trench-entrance" then
            for _, player in pairs(game.connected_players) do
                player.create_local_flying_text {
                    text = {"maraxsis.cannot-submerge"},
                    position = position,
                    create_at_cursor = false
                }
            end
            return nil
        end
        local target_position = {x = position.x * TRENCH_MOVEMENT_FACTOR, y = position.y * TRENCH_MOVEMENT_FACTOR}
        target_surface.request_to_generate_chunks(target_position, 1)
        target_surface.force_generate_chunk_requests()
        target_position = target_surface.find_non_colliding_position(submarine.name, target_position, 40, 0.5, false)
        if not target_position then return nil end
        return target_surface, target_position
    elseif surface_name == maraxsis.TRENCH_SURFACE_NAME then
        local target_position = {x = position.x / TRENCH_MOVEMENT_FACTOR, y = position.y / TRENCH_MOVEMENT_FACTOR}
        target_surface.request_to_generate_chunks(target_position, 1)
        target_surface.force_generate_chunk_requests()
        local tile_at_surface = target_surface.get_tile(target_position)
        if tile_at_surface.valid and tile_at_surface.name ~= "maraxsis-trench-entrance" then
            for _, player in pairs(game.connected_players) do
                player.create_local_flying_text {
                    text = {"maraxsis.rocks-in-the-way"},
                    position = position,
                    create_at_cursor = false
                }
            end
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

    local players_to_open_gui = {}
    for _, player in pairs(game.players) do
        if player.opened == submarine and player.surface ~= target_surface then table.insert(players_to_open_gui, player) end
    end
    submarine.teleport(target_position, target_surface, true)
    for _, player in pairs(players_to_open_gui) do
        if player.surface ~= target_surface then
            player.set_controller {
                type = defines.controllers.remote,
                position = target_position,
                surface = target_surface
            }
        end
        player.opened = submarine
    end

    if passenger and passenger.physical_vehicle == submarine then
        passenger.teleport(target_position, target_surface, true)
        maraxsis.execute_later("enter_submarine", 1, passenger, submarine)
    end

    if driver and driver.physical_vehicle == submarine then
        driver.teleport(target_position, target_surface, true)
        maraxsis.execute_later("enter_submarine", 1, driver, submarine)
    end

    return true
end

maraxsis.on_event("maraxsis-trench-submerge", function(event)
    local player = game.get_player(event.player_index)
    if not player then return end
    local submarine = player.vehicle

    if submarine and SUBMARINES[submarine.name] then
        decend_or_ascend(submarine)
    end
end)

-- override the default toggle driving control so that submarines can be entered from further distances.
maraxsis.on_event("toggle-driving", function(event)
    local player = game.get_player(event.player_index)
    if not player then return end
    local selected = player.selected
    local selected_submarine = selected and selected.valid and SUBMARINES[selected.name]
    local submarine = player.physical_vehicle
    local surface = player.physical_surface

    if player.physical_surface ~= player.surface then return end

    -- case 1: player is not hovering the sub but trying to exit.
    if submarine and SUBMARINES[submarine.name] and not selected_submarine then
        maraxsis.execute_later("exit_submarine", 1, event)
        -- case 2: player is hovering the sub and trying to enter. the vanilla vechicle enter range is too low for water vehicles so we artificially increase it
    elseif can_enter_submarine(player, selected) then
        maraxsis.execute_later("enter_submarine", 1, player, selected)
    end
end)

maraxsis.on_event("on_spidertron_patrol_waypoint_reached", function(event)
    if event.waypoint.type ~= "submerge" then return end
    local submarine = event.spidertron
    if not submarine or not submarine.valid then return end
    if not maraxsis.SUBMARINES[submarine.name] then return end

    if not decend_or_ascend(submarine) then
        submarine.force.print {"maraxsis.submarine-failed-to-submerge", submarine.gps_tag}
    end
end)
