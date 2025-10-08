maraxsis.on_event(maraxsis.events.on_built(), function(event)
    local entity = event.entity
    if not entity.valid then return end

    local prototype = entity.name == "entity-ghost" and entity.ghost_prototype or entity.prototype
    if prototype.type ~= "rocket-silo" then return end
    if not prototype.crafting_categories["rocket-building"] then return end

    if entity.get_recipe() then return end

    if entity.surface.name == "maraxsis" then
        entity.set_recipe("maraxsis-rocket-part")
        entity.recipe_locked = true
    end
end)
