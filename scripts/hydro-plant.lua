local function is_hydro_plant(entity)
    local name = entity.name == "entity-ghost" and entity.ghost_name or entity.name
    return name == "maraxsis-hydro-plant" or name == "maraxsis-hydro-plant-extra-module-slots"
end

local swap_target = {
    ["maraxsis-hydro-plant"] = "maraxsis-hydro-plant-extra-module-slots",
    ["maraxsis-hydro-plant-extra-module-slots"] = "maraxsis-hydro-plant",
}

-- swap the hydro plant with 2 extra modules slots in the trench surface
maraxsis.on_event(maraxsis.events.on_built(), function(event)
    local entity = event.entity
    if not entity.valid then return end

    if not is_hydro_plant(entity) then return end
    local surface = entity.surface
    local is_ghost = entity.name == "entity-ghost"
    local name = is_ghost and entity.ghost_name or entity.name

    local is_space = not not surface.platform
    local is_trench_or_space = is_space or surface.name == maraxsis.TRENCH_SURFACE_NAME
    if is_trench_or_space and name == "maraxsis-hydro-plant-extra-module-slots" then
        return
    elseif not is_trench_or_space and name == "maraxsis-hydro-plant" then
        return
    end
    local swap_target = swap_target[name]

    local player = event.player_index and game.get_player(event.player_index)

    local new_entity = surface.create_entity {
        name = is_ghost and "entity-ghost" or swap_target,
        inner_name = is_ghost and swap_target or nil,
        tags = is_ghost and entity.tags or nil,
        position = entity.position,
        direction = entity.direction,
        force = entity.force_index,
        quality = entity.quality,
        health = entity.health,
        raise_built = true,
        player = player,
    }
    new_entity.mirroring = entity.mirroring
    new_entity.copy_settings(entity)

    if not is_ghost then
        local modules = entity.get_module_inventory().get_contents()
        for _, item in pairs(modules) do
            local inserted_count = new_entity.insert(item)
            if inserted_count < item.count then
                item.count = item.count - inserted_count
                surface.spill_item_stack {
                    position = entity.position,
                    stack = item,
                    enable_looted = true,
                    force = entity.force_index,
                    allow_belts = false
                }
            end
        end
    end

    entity.destroy()
end)
