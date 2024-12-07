--note: much of this code is duplicated from the nightvision script.

local is_abyssal_diving_gear = {
    ["maraxsis-abyssal-diving-gear"] = true,
    ["maraxsis-abyssal-diving-gear-disabled"] = true,
}

-- returns the default buff amount per quality level in vanilla
local function get_quality_buff(quality_level)
    return 1 + quality_level * 0.3
end

local function update_abyssal_light_cone(player)
    local is_on_maraxsis = not not maraxsis.MARAXSIS_SURFACES[player.physical_surface.name]
    storage.abyssal_light_cones = storage.abyssal_light_cones or {}

    local cone = storage.abyssal_light_cones[player.index]
    if cone and not is_on_maraxsis then
        cone.destroy()
        storage.abyssal_light_cones[player.index] = nil
        return
    end

    local character = player.character
    if not character then return end
    local grid = character.grid
    if not grid then return end

    local light_size = 0
    for _, equipment in pairs(grid.get_contents()) do
        if equipment.name == "maraxsis-abyssal-diving-gear" then
            local quality = prototypes.quality[equipment.quality]
            light_size = light_size + (equipment.count * get_quality_buff(quality.level))
        end
    end

    if cone then
        cone.destroy()
        storage.abyssal_light_cones[player.index] = nil
    end

    if light_size == 0 then return end

    storage.abyssal_light_cones[player.index] = rendering.draw_light {
        sprite = "utility/light_medium",
        scale = light_size * 0.6 + 3.5,
        target = character,
        surface = character.surface,
        players = {player},
        intensity = 1,
        color = {r = 1, g = 0.8, b = 0.6},
        minimum_darkness = 0.5,
    }
end

---does the same thing as swap_diving_gear_to_correct_prototype, but only for one equipment
local function swap_diving_gear(grid, player, equipment)
    local equipment_name = equipment.name
    local position = equipment.position
    local quality = equipment.quality.name
    local target
    if not maraxsis.MARAXSIS_SURFACES[player.physical_surface.name] then
        if equipment_name:match("%-disabled$") then return end
        target = equipment_name .. "-disabled"
    else
        target = equipment_name:gsub("%-disabled$", "")
        if target == equipment_name then return end
    end

    assert(is_abyssal_diving_gear[target], "invalid target equipment: " .. target)

    local energy = equipment.energy
    grid.take {equipment = equipment}
    local new_equipment = grid.put {name = target, position = position, quality = quality}
    new_equipment.energy = energy
end

local function swap_diving_gear_to_correct_prototype(grid, player)
    for _, equipment in pairs(grid.equipment) do
        if is_abyssal_diving_gear[equipment.name] then
            swap_diving_gear(grid, player, equipment)
        end
    end
end

maraxsis.on_event({
    defines.events.on_player_changed_surface,
    defines.events.on_player_armor_inventory_changed,
    defines.events.on_player_created,
}, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end
    local armor = player.get_inventory(defines.inventory.character_armor)
    if not armor then return end

    for i = 1, #armor do
        local stack = armor[i]
        if stack.valid_for_read and stack.is_armor then
            local grid = stack.grid
            if grid then
                swap_diving_gear_to_correct_prototype(grid, player)
            end
        end
    end

    update_abyssal_light_cone(player)
end)

maraxsis.on_event(defines.events.on_equipment_inserted, function(event)
    local equipment = event.equipment
    if not equipment.valid or not is_abyssal_diving_gear[equipment.name] then return end
    local grid = event.grid
    if not grid.valid then return end

    for _, player in pairs(game.players) do
        local armor = player.get_inventory(defines.inventory.character_armor)
        if not armor then goto continue end
        for i = 1, #armor do
            local stack = armor[i]
            if stack.valid_for_read and stack.is_armor and stack.grid == grid then
                swap_diving_gear(grid, player, equipment)
            end
        end
        ::continue::
        update_abyssal_light_cone(player)
    end
end)

maraxsis.on_event({defines.events.on_equipment_removed, defines.events.on_player_controller_changed}, function(event)
    for _, player in pairs(game.players) do
        update_abyssal_light_cone(player)
    end
end)
