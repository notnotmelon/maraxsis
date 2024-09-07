local function extend_autoplace(prototype)
    local noise_layers = {}
    local seed = 4 -- chosen by fair dice roll, guaranteed to be random
    local i = 1
    for noise_layer, settings in pairs(prototype.noise_layers) do
        if not settings.cellular then
            noise_layers[noise_layer] = true
            local zoom = "var('control-setting:h2o-autoplace-control-" .. i .. ":size:multiplier')"

            local seed = seed
            --if settings.from_parent then
            --    seed = data.raw['noise-expression']['h2o-' .. noise_layer .. '-' .. prototype.parent_type].expression.arguments.seed1
            --end

            local expression = [[basis_noise{
                x = x,
                y = y,
                seed0 = map_seed,
                seed1 = ]] .. seed .. [[,
                input_scale = 0.9999728452 / ]] .. zoom .. [[,
                output_scale = 1.2 / 1.7717819213867
            }]]
            
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
