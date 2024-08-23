local function init_noise_layers(planet_prototype)
    local noise_layers = planet_prototype.noise_layers or {}
    noise_layers.resource = {cellular = true}
    noise_layers.star_pattern = {zoom = 1}
    return noise_layers
end

local function extend_autoplace(planet_prototype, extended_data)
    local noise_layers = {}
    local seed = 4 -- chosen by fair dice roll, guaranteed to be random
    local noise = require 'noise'
    local tne = noise.to_noise_expression
    local i = 1
    for noise_layer, settings in pairs(init_noise_layers(planet_prototype)) do
        if not settings.cellular then
            noise_layers[noise_layer] = true
            local zoom = noise.get_control_setting('py-autoplace-control-' .. i).size_multiplier

            local x = noise.var('x')
            local y = noise.var('y')
            if settings.fx then
                x = tne(settings.fx(x, y))
            end
            if settings.fy then
                y = tne(settings.fy(x, y))
            end
            local expression = h2o.basis_noise(x, y, seed, zoom)
            if settings.from_parent then
                expression.arguments.seed1 = extended_data['py-' .. noise_layer .. '-' .. planet_prototype.parent_type].expression.arguments.seed1
            end
            local name = 'py-' .. noise_layer .. '-' .. planet_prototype.type
            extended_data[name] = {
                type = 'noise-expression',
                name = name,
                localised_name = noise_layer,
                expression = expression,
            }
            i = i + 1
        end
    end

    if table_size(noise_layers) ~= 0 then
        for j = 1, i do
            local name = 'py-autoplace-control-' .. j
            extended_data[name] = {
                name = name,
                localised_name = name,
                type = 'autoplace-control',
                ---@diagnostic disable-next-line: assign-type-mismatch
                category = 'terrain',
                can_be_disabled = false,
                richness = false
            }
        end
    end
end

local function create_gas_prototype(gas)
    return {
        type = 'resource',
        name = 'cryogenic-distillation-of-' .. gas,
        localised_name = gas.localised_name or {'fluid-name.' .. gas},
        category = 'cryogenic-distillation',
        order = 'z',
        icon = '__pystellarexpeditiongraphics__/graphics/icons/cryogenic-distillate.png',
        icon_size = 64,
        map_grid = false,
        infinite = true,
        stage_counts = {0},
        stages = {
            filename = '__core__/graphics/empty.png',
            width = 1,
            height = 1
        },
        highlight = true,
        randomize_visual_position = false,
        minimum = 1,
        normal = 100000,
        resource_patch_search_radius = 3,
        infinite_depletion_amount = 0,
        minable = {
            mining_time = 10,
            results = {
                {type = 'fluid', name = gas, amount = 100},
            },
        },
        collision_box = {{-0.3, -0.3}, {0.3, 0.3}},
        autoplace = nil,
        flags = {'placeable-neutral', 'placeable-off-grid', 'not-on-map'},
        selectable_in_game = false,
        script_autoplace = true,
        mining_visualisation_tint = data.raw.fluid[gas].base_color,
    }
end

local function create_sprites(planet_type, sprites_data, extended_data)
    local sprites_amount = sprites_data[1]
    local width = sprites_data[2]
    local height = sprites_data[3] or width
    for i = 1, sprites_amount do
        local index = string.format("%02d", i)
        table.insert(extended_data, {
            type = 'sprite',
            name = "pyse-planet-sprite-" .. planet_type .. "-" .. i,
            filename = '__pystellarexpeditiongraphics__/graphics/zones/' .. planet_type .. '/' .. planet_type .. '-' .. index .. '.png',
            width = width,
            height = height,
            flags = {'gui-icon'}
        })
    end
    return extended_data
end

-- required and optional fields to create a planet prototype
---@class PlanetPrototypeData
---@field tags table<string, boolean|number|table>
---@field sprites {[1]: integer, [2]: integer, [3]: integer?}? -- number of sprite variations, their width and height
---@field corner_sprite data.SpritePrototype?
---@field type string
---@field native_life table<string, true>?
---@field noise_layers table<string, NoiseLayerSettings>?
---@field resources ResourceSettings?
---@field parent_type string?
---@field possible_names string[]?
---@field spawn_conditions table<string, boolean>?
---@field cliff_thresholds table?
---@field connected_surfaces table
---@field gui_builder string?

---@class NoiseLayerSettings
---@field cellular boolean? -- use cellular settings
---@field fx? fun(x: number, y: number): number
---@field fy? fun(x: number, y: number): number
---@field zoom number?
---@field from_parent boolean? -- inherit settings from parent planet

---@class ResourceSettings
---@field primary table<string, table>? -- primary resurce names and settings
---@field secondary table<string, table>? -- primary resurce names and settings
---@field rock table<string, table>? -- rock names and settings

-- planet prototype used in data stage
---@class PlanetPrototype
---@field tags table<string, {chance: number, min_value: integer, max_value: integer}> -- possible tags for this planet, their chances and amount
---@field sprites data.SpritePrototype[]? -- sprite prototypes that are displayed in the stellar map GUI
---@field corner_sprite data.SpritePrototype? -- corner sprite prototype that is displayed in the stellar map GUI
---@field type string -- type of the planet. acid, lava, ect
---@field native_life table<string, true>? -- native life to display in the planet GUI
---@field noise_layers table<string, NoiseLayerSettings> -- noise layers for this planet
---@field resources ResourceSettings? -- resources found on this planet
---@field parent_type string? -- used when noise layers are inherited
---@field possible_names string[]? -- possible names for this planet
---@field noise_layers_as_array string[] -- noise layers in an ordered table
---@field spawn_conditions {moon: boolean, star: boolean, planet: boolean, asteroid: boolean}? -- conditions for this planet to be spawned by the solar system generator
---@field cliff_thresholds number[]? -- elevation thresholds for the cliff algorithm
---@field connected_surfaces {orbit: string?, underwater: string?, underground: string?} -- connected surfaces and their types
---@field gui_builder 'star'|'asteroid'|'gas-giant'|'planet' -- GUI builder for this planet
---@field new fun(prototype_data: PlanetPrototypeData): PlanetPrototype -- constructor for the planet prototype
---@field data_stage_init fun(prototype_data: PlanetPrototypeData, extended_data: table): nil -- update the required prototype table in data stage
PlanetPrototype = {
    __tostring = function(self)
        return self.type
    end,

    __index = {
        ---@param prototype_data PlanetPrototypeData
        new = function(prototype_data)
            local self = setmetatable(table.deepcopy(prototype_data), PlanetPrototype) --[[@as PlanetPrototype]]
            for tag, chance in pairs(prototype_data.tags) do
                if type(chance) == 'boolean' then
                    self.tags[tag] = {chance = 1}
                elseif type(chance) == 'number' then
                    self.tags[tag] = {chance = chance}
                elseif type(chance) == 'table' then
                    self.tags[tag] = {chance = chance.chance, min_value = chance.min_value or 1, max_value = chance.max_value or 1}
                end
            end

            if prototype_data.sprites then
                ---@diagnostic disable-next-line: deprecated
                self.sprites = create_sprites(prototype_data.type, prototype_data.sprites, {})
            end

            -- normalize distribution of ore entities
            if prototype_data.resources then
                for category, resource in pairs(prototype_data.resources) do
                    local total_weight = 0
                    for _, ore in pairs(resource) do
                        total_weight = total_weight + ore.weight
                    end

                    local threshold = 0
                    for i, ore in pairs(resource) do
                        threshold = threshold + (ore.weight / total_weight)
                        local prototype_ore = self.resources[category][i]
                        prototype_ore.threshold = threshold
                        prototype_ore.weight = nil
                    end
                end
            end

            -- noise expressions
            self.noise_layers = init_noise_layers(prototype_data)
            local as_array = {}
            local i = 1
            for noise_layer, setting in pairs(self.noise_layers) do
                if not setting.cellular then
                    as_array[i] = noise_layer
                    i = i + 1
                end
            end
            self.noise_layers_as_array = as_array

            if self.possible_names and #self.possible_names == 0 then self.possible_names = nil end

            if self.cliff_thresholds then
                table.sort(self.cliff_thresholds)
            end

            return self
        end,

        data_stage_init = function(prototype_data, extended_data)
            if prototype_data.sprites then
                ---@diagnostic disable-next-line: deprecated
                create_sprites(prototype_data.type, prototype_data.sprites, extended_data)
            end
            if prototype_data.corner_sprite then
                table.insert(extended_data, prototype_data.corner_sprite)
            end
            extend_autoplace(prototype_data, extended_data)

            -- error checking
            if prototype_data.native_life then
                for life, type in pairs(prototype_data.native_life) do
                    if type == 'item' then -- TODO native_life has boolean as type, this will never run
                        if not data.raw.item[life] and not data.raw.module[life] then
                            error('Planet ' .. prototype_data.type .. ' has native life ' .. life .. ' but no item with that name exists')
                        end
                    end
                end
            end
        end
    }
}
setmetatable(PlanetPrototype, PlanetPrototype)
