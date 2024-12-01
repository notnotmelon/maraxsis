-- Adds helper functions for data stage. Shared across all pymods and adapted for use in maraxsis

maraxsis.on_event = function() end

---Returns a 1x1 empty image.
---@return table
maraxsis.empty_image = function()
    return {
        filename = "__core__/graphics/empty.png",
        size = 1,
        priority = "high",
        direction_count = 1,
        frame_count = 1,
        line_length = 1
    }
end

---Creates a new prototype by cloning 'old' and overwriting it with properties from 'new'. Provide 'nil' as a string in order to delete items inside 'old'
---@param old data.AnyPrototype
---@param new table
---@return data.AnyPrototype
maraxsis.merge = function(old, new)
    if not old then
        error("Failed to maraxsis.merge: Old prototype is nil", 2)
    end

    old = table.deepcopy(old)
    for k, v in pairs(new) do
        if v == "nil" then
            old[k] = nil
        else
            old[k] = v
        end
    end
    return old
end

maraxsis.surface_conditions = function()
    return {{
        property = "pressure",
        min = 200000,
        max = 400000,
    }}
end
