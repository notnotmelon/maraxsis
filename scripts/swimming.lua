local function transfer_equipment_grid(old_armor, new_armor)
    local old_armor_grid = old_armor.grid
    local new_armor_grid = new_armor.grid

    if not old_armor_grid then return end
    assert(new_armor_grid)

    for _, equipment in pairs(old_armor_grid.equipment) do
        local is_ghost = equipment.type == "equipment-ghost"
        new_armor_grid.put {
            name = is_ghost and equipment.ghost_name or equipment.name,
            position = equipment.position,
            quality = equipment.quality,
            ghost = is_ghost, -- vanilla bug: this just deletes the ghosts if true
            by_player = player,
        }
    end
end

local function restore_walking_speed(character_unit_number)
    if not character_unit_number then return end
    local previous_character_running_speed_modifier = storage.previous_character_running_speed_modifier
    if not previous_character_running_speed_modifier then return end
    previous_character_running_speed_modifier = previous_character_running_speed_modifier[character_unit_number]
    if not previous_character_running_speed_modifier then return end

    local character
    for _, player in pairs(game.players) do
        if player.character and player.character.unit_number == character_unit_number then
            character = player.character
            break
        end
    end

    if not character then return end
    character.character_running_speed_modifier = previous_character_running_speed_modifier
    storage.previous_character_running_speed_modifier[character_unit_number] = nil
end

local function transfer_armor_item(armor, target_armor_name, character_unit_number)
    restore_walking_speed(character_unit_number)

    if not armor.valid or not armor.valid_for_read then return end
    if not prototypes.item[target_armor_name] then return end
    local temp_inventory = game.create_inventory(1)
    local stack = temp_inventory[1]
    stack.set_stack {
        name = target_armor_name,
        count = 1,
        quality = armor.quality,
        health = armor.health,
        spoil_percent = armor.spoil_percent
    }

    transfer_equipment_grid(armor, stack)
    armor.set_stack(stack)
    temp_inventory.destroy()
end
maraxsis.register_delayed_function("transfer_armor_item", transfer_armor_item)

local function update_armor(player)
    local armor_inventory
    if player.controller_type == defines.controllers.editor then
        armor_inventory = player.get_inventory(defines.inventory.editor_armor)
    else
        armor_inventory = player.get_inventory(defines.inventory.character_armor)
    end
    if not armor_inventory or armor_inventory.is_empty() then return end

    local armor = armor_inventory[1]
    if not armor.valid_for_read then return end

    local armor_name = armor.name
    local target_armor_name
    local physical_surface = player.physical_surface
    local started_swimming = not not maraxsis.MARAXSIS_SURFACES[physical_surface.name]
    if started_swimming then
        target_armor_name = armor_name .. "-maraxsis-swimming"
    else
        target_armor_name = armor_name:gsub("%-maraxsis%-swimming", "")
    end

    if armor_name == target_armor_name then return end

    -- teleport the player to a safe location
    if not started_swimming and player.character then
        local character = player.character

        local currently_collides = character.surface.entity_prototype_collides(character.name, character.position, false)
        if currently_collides then
            local safe_location = character.surface.find_non_colliding_position(character.name, character.position, 32, 0.5)
            if safe_location then
                storage.previous_character_running_speed_modifier = storage.previous_character_running_speed_modifier or {}
                storage.previous_character_running_speed_modifier[character.unit_number] = character.character_running_speed_modifier
                character.character_running_speed_modifier = -1
                character.teleport(safe_location)
                maraxsis.execute_later("transfer_armor_item", 30, armor, target_armor_name, character.unit_number)
                return
            end
        end
    end

    transfer_armor_item(armor, target_armor_name)
end

maraxsis.on_event({
    defines.events.on_player_changed_surface,
    defines.events.on_player_respawned,
    defines.events.on_player_driving_changed_state,
    defines.events.on_player_armor_inventory_changed,
    defines.events.on_player_cheat_mode_enabled,
    defines.events.on_player_controller_changed,
}, function(event)
    local player = game.get_player(event.player_index)
    update_armor(player)
end)

maraxsis.on_nth_tick(537, function(event)
    for _, player in pairs(game.connected_players) do
        update_armor(player)
    end
end)

maraxsis.on_event(defines.events.on_player_cursor_stack_changed, function(event)
    local player = game.get_player(event.player_index)
    local cursor_stack = player.cursor_stack
    if not cursor_stack.valid_for_read then return end

    local cursor_stack_name = cursor_stack.name
    if not cursor_stack_name:find("-maraxsis-swimming", 1, true) then return end

    local target_stack_name = cursor_stack_name:gsub("%-maraxsis%-swimming", "")
    transfer_armor_item(cursor_stack, target_stack_name)
end)