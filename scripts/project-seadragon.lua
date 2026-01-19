-- Adapted from Rubia & Alternative Rocket Sprite Extension.

maraxsis.on_event(maraxsis.events.on_built(), function(event)
    local entity = event.entity
    if not entity.valid then return end
    local surface = entity.surface
    if surface.name ~= "maraxsis" then return end

    local is_ghost = entity.name == "entity-ghost"
    local type = is_ghost and entity.ghost_type or entity.type
    if type ~= "rocket-silo" then return end
    local prototype = is_ghost and entity.ghost_prototype or entity.prototype
    if not prototype.crafting_categories["rocket-building"] then return end
    local name = is_ghost and entity.ghost_name or entity.name
    if name == "maraxsis-rocket-silo" then return end

    local new_entity = surface.create_entity {
        name = is_ghost and "entity-ghost" or "maraxsis-rocket-silo",
        inner_name = is_ghost and "maraxsis-rocket-silo" or nil,
        tags = is_ghost and entity.tags or nil,
        position = entity.position,
        direction = entity.direction,
        force = entity.force_index,
        quality = entity.quality,
        health = entity.health,
        raise_built = true,
        player = event.player_index and game.get_player(event.player_index) or nil,
    }
    assert(new_entity and new_entity.valid)
    new_entity.mirroring = entity.mirroring
    new_entity.copy_settings(entity)

    --Transfer modules, but only if the entity has them!
    local module_inventory = entity.get_module_inventory() 
    if not is_ghost and module_inventory then
        local modules = module_inventory.get_contents()
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
