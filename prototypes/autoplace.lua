local function extend_autoplace(prototype)
    local noise_layers = {}
    local seed = 4 -- chosen by fair dice roll, guaranteed to be random
    local noise = require 'noise'
    local tne = noise.to_noise_expression
    local i = 1
    for noise_layer, settings in pairs(prototype.noise_layers) do
        if not settings.cellular then
            noise_layers[noise_layer] = true
            local zoom = noise.get_control_setting('h2o-autoplace-control-' .. i).size_multiplier

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
                expression.arguments.seed1 = data.raw['noise-expression']['h2o-' .. noise_layer .. '-' .. prototype.parent_type].expression.arguments.seed1
            end
            local name = 'h2o-' .. noise_layer .. '-' .. prototype.type
            data:extend {{
                type = 'noise-expression',
                name = name,
                localised_name = noise_layer,
                expression = expression,
            }}
            i = i + 1
        end
    end

    if table_size(noise_layers) ~= 0 then
        for j = 1, i do
            local name = 'h2o-autoplace-control-' .. j
            data:extend {{
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
end

for _, prototype in pairs {
    require 'scripts.map-gen.surfaces.maraxsis',
    require 'scripts.map-gen.surfaces.maraxsis-trench',
} do extend_autoplace(prototype) end
