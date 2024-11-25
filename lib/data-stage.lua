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

---Adds a localised string to the prototype's description.
---@param type string
---@param prototype data.AnyPrototype
---@param localised_string LocalisedString
maraxsis.add_to_description = function(type, prototype, localised_string)
    if prototype.localised_description and prototype.localised_description ~= "" then
        prototype.localised_description = {"", prototype.localised_description, "\n", localised_string}
        return
    end

    local place_result = prototype.place_result or prototype.placed_as_equipment_result
    if type == "item" and place_result then
        for _, machine in pairs(data.raw) do
            machine = machine[place_result]
            if machine and machine.localised_description then
                prototype.localised_description = {
                    "?",
                    {"", machine.localised_description, "\n", localised_string},
                    localised_string
                }
                return
            end
        end

        local entity_type = prototype.place_result and "entity" or "equipment"
        prototype.localised_description = {
            "?",
            {"", {entity_type .. "-description." .. place_result}, "\n", localised_string},
            {"", {type .. "-description." .. prototype.name},      "\n", localised_string},
            localised_string
        }
    else
        prototype.localised_description = {
            "?",
            {"", {type .. "-description." .. prototype.name}, "\n", localised_string},
            localised_string
        }
    end
end

---adds a glow layer to any item prototype.
---@param prototype data.ItemPrototype
maraxsis.make_item_glowing = function(prototype)
    if not prototype then
        error("No prototype provided")
    end
    if prototype.pictures then
        for _, picture in pairs(prototype.pictures) do
            picture.draw_as_glow = true
        end
        return
    end
    if prototype.icon and not prototype.icons then
        prototype.icons = {{icon = prototype.icon, icon_size = prototype.icon_size}}
        prototype.icon = nil
    end
    if not prototype.icons then
        error("No icon found for " .. prototype.name)
    end
    local pictures = {}
    for _, picture in pairs(table.deepcopy(prototype.icons)) do
        picture.draw_as_glow = true
        local icon_size = picture.icon_size or prototype.icon_size
        picture.filename = picture.icon
        picture.shift = {0, 0}
        picture.width = icon_size
        picture.height = icon_size
        picture.scale = 16 / icon_size
        picture.icon = nil
        picture.icon_size = nil
        pictures[#pictures + 1] = picture
    end
    prototype.pictures = pictures
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

---The purpose of the farm_speed functions is to remove the farm building itself
---from the building speed. For example, for xyhiphoe mk1 which has only one animal
---per farm, we want the speed to be equal to 1 xyhiphoe not 2 (farm + module)
---Returns the correct farm speed for a mk1 farm based on number of modules and desired speed using mk1 modules
---@param num_slots integer
---@param desired_speed number
---@return number
function maraxsis.farm_speed(num_slots, desired_speed)
    -- mk1 modules are 100% bonus speed. The farm itself then counts as much as one module
    return desired_speed / (num_slots + 1)
end

---Takes two prototype names (both must use the style of IconSpecification with icon = string_path), returns an IconSpecification with the icons as composites
---@param base_prototype string
---@param child_prototype string
---@param shadow_alpha number?
function maraxsis.composite_molten_icon(base_prototype, child_prototype, shadow_alpha)
    shadow_alpha = shadow_alpha or 0.6
    base_prototype = data.raw.fluid[base_prototype] or data.raw.item[base_prototype]
    child_prototype = data.raw.fluid[child_prototype] or data.raw.item[child_prototype]
    return {
        {
            icon = base_prototype.icon,
            icon_size = base_prototype.icon_size,
        },
        {
            icon = child_prototype.icon,
            icon_size = child_prototype.icon_size,
            shift = {10, 10},
            scale = 0.65,
            tint = {r = 0, g = 0, b = 0, a = shadow_alpha}
        },
        {
            icon = child_prototype.icon,
            icon_size = child_prototype.icon_size,
            shift = {10, 10},
            scale = 0.5,
            tint = {r = 1, g = 1, b = 1, a = 1}
        },
    }
end

---Define pipe connection pipe pictures, not all entities use these.
---@param pictures string
---@param shift_north table?
---@param shift_south table?
---@param shift_west table?
---@param shift_east table?
---@param replacements table?
---@return table
maraxsis.pipe_pictures = function(pictures, shift_north, shift_south, shift_west, shift_east, replacements)
    local new_pictures = {
        north = shift_north and
            {
                filename = "__base__/graphics/entity/" .. pictures .. "/" .. pictures .. "-pipe-N.png",
                priority = "extra-high",
                width = 35,
                height = 18,
                shift = shift_north
            } or
            maraxsis.empty_image(),
        south = shift_south and
            {
                filename = "__base__/graphics/entity/" .. pictures .. "/" .. pictures .. "-pipe-S.png",
                priority = "extra-high",
                width = 44,
                height = 31,
                shift = shift_south
            } or
            maraxsis.empty_image(),
        west = shift_west and
            {
                filename = "__base__/graphics/entity/" .. pictures .. "/" .. pictures .. "-pipe-W.png",
                priority = "extra-high",
                width = 19,
                height = 37,
                shift = shift_west
            } or
            maraxsis.empty_image(),
        east = shift_east and
            {
                filename = "__base__/graphics/entity/" .. pictures .. "/" .. pictures .. "-pipe-E.png",
                priority = "extra-high",
                width = 20,
                height = 38,
                shift = shift_east
            } or
            maraxsis.empty_image()
    }
    for direction, image in pairs(replacements or {}) do
        if not (new_pictures[direction].filename == "__core__/graphics/empty.png") then
            new_pictures[direction].filename = image.filename
            new_pictures[direction].width = image.width
            new_pictures[direction].height = image.height
            new_pictures[direction].priority = image.priority or new_pictures[direction].priority
        end
    end
    return new_pictures
end

---Define pipe connection pipe covers, not all entities use these.
---@param n boolean?
---@param s boolean?
---@param w boolean?
---@param e boolean?
---@return table
maraxsis.pipe_covers = function(n, s, w, e)
    if (n == nil and s == nil and w == nil and e == nil) then
        n, s, e, w = true, true, true, true
    end

    n =
        n and
        {
            layers = {
                {
                    filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north.png",
                    priority = "extra-high",
                    width = 128,
                    height = 128,
                    scale = 0.5
                },
                {
                    filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north-shadow.png",
                    priority = "extra-high",
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    draw_as_shadow = true
                }
            }
        } or
        maraxsis.empty_image()
    e =
        e and
        {
            layers = {
                {
                    filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east.png",
                    priority = "extra-high",
                    width = 128,
                    height = 128,
                    scale = 0.5
                },
                {
                    filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east-shadow.png",
                    priority = "extra-high",
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    draw_as_shadow = true
                }
            }
        } or
        maraxsis.empty_image()
    s =
        s and
        {
            layers = {
                {
                    filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south.png",
                    priority = "extra-high",
                    width = 128,
                    height = 128,
                    scale = 0.5
                },
                {
                    filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south-shadow.png",
                    priority = "extra-high",
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    draw_as_shadow = true
                }
            }
        } or
        maraxsis.empty_image()
    w =
        w and
        {
            layers = {
                {
                    filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west.png",
                    priority = "extra-high",
                    width = 128,
                    height = 128,
                    scale = 0.5
                },
                {
                    filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west-shadow.png",
                    priority = "extra-high",
                    width = 128,
                    height = 128,
                    scale = 0.5,
                    draw_as_shadow = true
                }
            }
        } or
        maraxsis.empty_image()

    return {north = n, south = s, east = e, west = w}
end

---Standardizes a product or ingredient prototype to a common format.
---@param p data.IngredientPrototype | data.ProductPrototype | string
---@return data.IngredientPrototype | data.ProductPrototype
maraxsis.standardize_product = function(p)
    if type(p) == "string" then p = {p, 1} end
    local name = p.name or p[1]
    if not p.type and name then
        if data.raw.fluid[name] then
            p.type = "fluid"
        else
            p.type = "item"
        end
    end

    p.name = name
    if not (p.amount_min and p.amount_max) then p.amount = p.amount or p[2] or 1 end
    p[1] = nil
    p[2] = nil

    return p
end

---Returns an iterator through all prototypes of a given supertype.
---@param parent_type string
---@return function
function maraxsis.iter_prototypes(parent_type)
    local types = defines.prototypes[parent_type]
    local t, n, d

    return function()
        repeat
            if not t or not n then
                n, d, t, _ = nil, nil, next(types, t)
            end

            if t then
                n, d = next(data.raw[t], n)
            end
        until n or not t

        return n, d
    end
end
