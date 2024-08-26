local collision_mask_util = require '__core__/lualib/collision-mask-util'
_G.maraxsis_collision_mask = collision_mask_util.get_first_unused_layer()

local template = {
    type = 'simple-entity',
    count_as_rock_for_filtered_deconstruction = false,
    icon_size = 64,
    protected_from_tile_building = false,
    remove_decoratives = false,
    selectable_in_game = false,
    subgroup = data.raw.tile['water'].subgroup,
    flags = {'not-on-map', 'hidden'},
    collision_box = {{-16, -16}, {16, 16}},
    secondary_draw_order = -1,
    collision_mask = {}
}

for size = 0, 5 do
    size = 2 ^ size
    for i = 1, size do
        for j = 1, size do
            local frame_sequence = {}
            for k = 1, 32 do
                table.insert(frame_sequence, j + size * (k - 1 + (i - 1) * 32))
            end
            local water = table.deepcopy(template)
            water.render_layer = 'light-effect'
            water.icon = '__dihydrogen-monoxide__/graphics/tile/water/water-combined.png'
            water.icon_size = 32
            water.name = 'h2o-water-shader-' .. (32 / size) .. '-' .. j .. '-' .. i
            water.localised_name = water.name
            water.animations = {
                layers = {
                    {
                        height = 256 / size,
                        width = 256 / size,
                        line_length = 32 * size,
                        variation_count = 1,
                        filename = '__dihydrogen-monoxide__/graphics/tile/water/water-combined.png',
                        frame_count = 32 * size * size,
                        animation_speed = 0.5,
                        scale = 4,
                        frame_sequence = frame_sequence,
                        draw_as_glow = false,
                        shift = size == 32 and {-0.5, -0.5} or nil
                    },
                }
            }
            data:extend{water}
        end
    end
end

local layer = 4
local waterifiy = {
    ---creates a copy of a tile prototype that can be used underneath py fancy water
    ---@param tile string
    ---@param include_submarine_exclusion_zone boolean
    ---@return table
    tile = function(tile, include_submarine_exclusion_zone)
        tile = table.deepcopy(data.raw.tile[tile])
        tile.localised_name = {'tile-name.underwater'}
        tile.name = tile.name .. '-underwater'
        tile.collision_mask = {maraxsis_collision_mask}
        tile.layer = layer
        ---@diagnostic disable-next-line: param-type-mismatch
        tile.map_color = h2o.color_combine(tile.map_color or data.raw.tile['water'].map_color, data.raw.tile['deepwater'].map_color, 0.25)
        tile.pollution_absorption_per_second = data.raw.tile['water'].pollution_absorption_per_second
        tile.draw_in_water_layer = true
        --tile.walking_sound = nil -- TODO: add a swimming sound
        tile.walking_speed_modifier = 0.2
        water_tile_type_names[#water_tile_type_names+1] = tile.name
    
        if not include_submarine_exclusion_zone then return {tile} end
    
        local submarine_exclusion_zone = table.deepcopy(tile)
        submarine_exclusion_zone.layer = layer
        submarine_exclusion_zone.name = tile.name .. '-submarine-exclusion-zone'
        submarine_exclusion_zone.collision_mask = {maraxsis_collision_mask, 'rail-layer'}
        water_tile_type_names[#water_tile_type_names+1] = submarine_exclusion_zone.name
        
        layer = layer + 1
        return {tile, submarine_exclusion_zone}
    end,
    ---@param entity string
    ---@return table
    entity = function(entity)
        local underwater
        for entity_prototype in pairs(defines.prototypes.entity) do
            for _, prototype in pairs(data.raw[entity_prototype]) do
                if prototype.name == entity then
                    underwater = prototype
                    break
                end
            end
        end
        if not underwater then error('entity not found ' .. entity) end
        underwater = table.deepcopy(underwater)
        underwater.localised_name = underwater.localised_name or {'entity-name.' .. underwater.name}
        underwater.name = underwater.name .. '-underwater'
        
        underwater.localised_name = underwater.localised_name or {'entity-name.' .. underwater.name}
        collision_mask_util.remove_layer(collision_mask_util.get_mask(underwater), maraxsis_collision_mask)
        collision_mask_util.add_layer(collision_mask_util.get_mask(underwater), 'ground-tile')
        ---@diagnostic disable-next-line: param-type-mismatch
        underwater.map_color = h2o.color_combine(underwater.map_color or data.raw.tile['water'].map_color, data.raw.tile['deepwater'].map_color, 0.3)

        return {underwater}
    end,
}

data:extend(waterifiy.tile('sand-1', true))
data:extend(waterifiy.tile('sand-3', true))
data:extend(waterifiy.tile('dirt-5', true))
data:extend(waterifiy.tile('grass-2', false))
data:extend(waterifiy.entity('cliff'))
data:extend(waterifiy.entity('sand-rock-big'))

---creates a new cliff entity with the upper area masked with the provided tile
---@param tile string
local function trenchifiy(tile)
    local results = {}

    local cliff = data.raw['cliff']['cliff']
    for k, orientation in pairs(cliff.orientations) do
        local pictures = {}

        for _, picture in pairs(orientation.pictures) do
            local layer = table.deepcopy(picture.layers[1])
            for _, version in pairs{layer, layer.hr_version} do
                version.filename = version.filename:gsub('.png', '-'..tile..'.png')
                version.filename = version.filename:gsub('__base__/graphics/terrain/cliffs', '__dihydrogen-monoxide__/graphics/entity/cliffs')
            end
            pictures[#pictures+1] = layer
        end

        results[#results+1] = {
            name = tile .. '-trench-' .. k:gsub('_', '-'),
            type = 'simple-entity',
            collision_box = {{-2, -2}, {2, 2}},
            count_as_rock_for_filtered_deconstruction = false,
            collision_mask = {},
            map_color = data.raw.tile[tile .. '-underwater'].map_color,
            flags = {'hidden'},
            secondary_draw_order = -1,
            render_layer = 'ground-tile',
            protected_from_tile_building = false,
            remove_decoratives = false,
            selectable_in_game = false,
            icon = data.raw.cliff.cliff.icon,
            icon_size = data.raw.cliff.cliff.icon_size,
            pictures = pictures
        }
    end

    return results
end

data:extend(trenchifiy('sand-1'))
data:extend(trenchifiy('sand-3'))
data:extend(trenchifiy('dirt-5'))

--[[local trench_wall_cliff = table.deepcopy(data.raw['cliff']['cliff'])
trench_wall_cliff.name = 'cliff-trench-wall'
trench_wall_cliff.localised_name = {'entity-name.trench-wall'}
trench_wall_cliff.cliff_explosive = nil
trench_wall_cliff.minable = nil
trench_wall_cliff.selectable_in_game = false
trench_wall_cliff.map_color = {0.2, 0.2, 0.2, 1}
for k, orientation in pairs(trench_wall_cliff.orientations) do
    for _, picture in pairs(orientation.pictures) do
        for _, layer in pairs(picture.layers) do
            layer.tint = {r = 0.2, g = 0.2, b = 0.3}
            layer.hr_version.tint = {r = 0.2, g = 0.2, b = 0.3}
        end
    end
end
data:extend{trench_wall_cliff}--]]

-- NESW

local X = 'sand'
local O = 'water'
local N = 'doesnt-matter'
local corner_order = {
    {{N, X, N},
    {O, O, X},
    {N, O, N}},
    
    {{N, O, N},
    {O, O, X},
    {N, X, N}},
    
    {{N, O, N},
    {X, O, O},
    {N, X, N}},
    
    {{N, X, N},
    {X, O, O},
    {N, O, N}},
    
    
    {{O, O, X},
    {O, O, O},
    {N, O, N}},
    
    {{N, O, N},
    {O, O, O},
    {O, O, X}},
    
    {{O, O, O},
    {O, O, O},
    {X, O, O}},
    
    {{X, O, O},
    {O, O, O},
    {O, O, O}},

    
    {{N, X, N},
    {O, O, O},
    {N, O, N}},
    
    {{N, O, N},
    {O, O, X},
    {N, O, N}},
    
    {{N, O, N},
    {O, O, O},
    {N, X, N}},
    
    {{N, O, N},
    {X, O, O},
    {N, O, N}},

    
    {{N, X, N},
    {X, O, X},
    {N, O, N}},
    
    {{N, X, N},
    {O, O, N},
    {N, X, N}},
    
    {{N, O, N},
    {X, O, X},
    {N, N, N}},
    
    {{N, X, N},
    {X, O, O},
    {N, X, N}},

    
    {{N, X, N},
    {X, O, X},
    {N, X, N}},
}

local base_shader = data.raw['simple-entity']['h2o-water-shader-1-1-1']
local filename = '__dihydrogen-monoxide__/graphics/tile/water/water-coastline.png'

local function recursively_generate_coastline_shaders(variants, i)
    local result = {}
    if i == #variants then
        for _, variant in pairs(variants[i]) do
            result[#result+1] = {variant}
        end
        return result
    end
    for _, variant in pairs(variants[i]) do
        local next_variants = recursively_generate_coastline_shaders(variants, i + 1)
        for _, name_array in pairs(next_variants) do
            local name_array_copy = table.deepcopy(name_array)
            table.insert(name_array_copy, 1, variant)
            result[#result+1] = name_array_copy
        end
    end
    return result
end

local i = 0
local y = 0
for _, grid in pairs(corner_order) do
    local variants = {}
    for _, row in pairs(grid) do
        for _, cell in pairs(row) do
            local cell_variants = {}
            if cell == X then
                cell_variants[#cell_variants+1] = X
            elseif cell == O then
                cell_variants[#cell_variants+1] = O
            else
                cell_variants[#cell_variants+1] = X
                cell_variants[#cell_variants+1] = O
            end
            variants[#variants+1] = cell_variants
        end
    end

    for _, name_array in pairs(recursively_generate_coastline_shaders(variants, 1)) do
        local name = 'h2o-coastline-shader'
        for _, n in pairs(name_array) do
            name = name .. '-' .. n
        end
        if data.raw['simple-entity'][name] then goto continue end
        local water = table.deepcopy(base_shader)
        water.name = name
        water.localised_name = name
        water.animations = {
            layers = {
                {
                    height = 64,
                    width = 64,
                    line_length = 2,
                    variation_count = 2,
                    filename = filename,
                    frame_count = 1,
                    animation_speed = 0.5,
                    scale = 0.5,
                    draw_as_glow = false,
                    shift = {0.5, 0.5},
                    y = y
                },
            }
        }
        data:extend{water}
        i = i + 1
        ::continue::
    end

    y = y + 64
end

local trench_entrance = table.deepcopy(data.raw.tile['out-of-map'])
trench_entrance.name = 'trench-entrance'
trench_entrance.layer = 255
trench_entrance.map_color = {0, 0, 0.1, 1}
trench_entrance.collision_mask = {'water-tile', 'player-layer', 'object-layer', 'item-layer'}
data:extend{trench_entrance}