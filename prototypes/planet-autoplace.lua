local noise_layers = {}
local highest_i = 1
local seed = 4 -- chosen by fair dice roll, guaranteed to be random
for _, planet in pairs(planet_prototypes) do
    local noise = require 'noise'
    local tne = noise.to_noise_expression
    highest_i = math.max(highest_i, #planet.noise_layers_as_array)
    local i = 1
    for noise_layer, settings in pairs(planet.noise_layers) do
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
                expression.arguments.seed1 = data.raw['noise-expression']['py-' .. noise_layer .. '-' .. planet.parent_type].expression.arguments.seed1
            end

            data:extend{{
                type = 'noise-expression',
                name = 'py-' .. noise_layer .. '-' .. planet.type,
                localised_name = noise_layer,
                expression = expression,
            }}
            i = i + 1
        end
    end
end

if table_size(noise_layers) ~= 0 then
    for i = 1, highest_i do
        local name = 'py-autoplace-control-' .. i
        ---@diagnostic disable-next-line: assign-type-mismatch
        data:extend{{
            name = name,
            localised_name = name,
            type = 'autoplace-control',
            ---@diagnostic disable-next-line: assign-type-mismatch
            category = 'terrain',
            can_be_disabled = false,
            richness = false
        }}
    end
end