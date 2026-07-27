function maraxsis.make_hypno_technology(params)
    assert(params.technology)
    local name = "maraxsis-hypno-technology-" .. params.technology
    if data.raw.technology[name] then return end
end

function maraxsis.make_hypno_recipe(params)
    assert(not params.categories)
    assert(params.recipe and data.raw.recipe[params.recipe], params.recipe)

    local recipe = table.deepcopy(data.raw.recipe[params.recipe])
    recipe.name = "maraxsis-hypno-" .. recipe.name
    
    recipe.main_product = recipe.main_product or recipe.results[1].name
    local old_main_product = data.raw.item[recipe.main_product] or data.raw.fluid[recipe.main_product] or data.raw.capsule[recipe.main_product]

    recipe.results = params.results or recipe.results
    recipe.ingredients = params.ingredients or recipe.ingredients

    for side, products in pairs{ingredient = recipe.ingredients, result = recipe.results} do
        for _, product in pairs(products) do
            for _, swap in pairs(params.swaps or {}) do
                local is_on_correct_side = swap.side == nil or side == swap.side
                if is_on_correct_side and swap.swap_for == product.name then
                    for k, v in pairs(swap) do
                        product[k] = v
                    end
                    if side == "result" and swap.swap_for == recipe.main_product then
                        recipe.main_product = swap.name
                    end
                    break
                end
            end
        end
    end

    for _, ingredient in pairs(params.new_ingredients or {}) do
        table.insert(recipe.ingredients, ingredient)
    end
    for _, result in pairs(params.new_results or {}) do
        table.insert(recipe.results, result)
    end

    recipe.main_product = params.main_product or recipe.main_product or recipe.results[1].name
    local main_product = data.raw.item[recipe.main_product] or data.raw.fluid[recipe.main_product] or data.raw.capsule[recipe.main_product] or data.raw.module[recipe.main_product] or data.raw.armor[recipe.main_product] or data.raw.gun[recipe.main_product] or data.raw.ammo[recipe.main_product]

    if not recipe.icons then
        if type(recipe.icon) == "string" then
            recipe.icons = {
                {
                    icon = recipe.icon,
                    icon_size = recipe.icon_size or 64
                }
            }
        elseif main_product then
            recipe.icons = main_product.icons or {
                {
                    icon = main_product.icon,
                    icon_size = main_product.icon_size or 64
                }
            }
        else
            recipe.icons = {}
        end
    end

    table.insert(recipe.icons, {
        icon = "__maraxsis__/graphics/icons/estrogen.png",
        icon_size = 64,
        tint = {0.5, 0.5, 0.5, 0.5}
    })

    recipe.auto_recycle = false
    recipe.enabled = false
    recipe.hide_from_player_crafting = true

    local old_main_product = old_main_product or main_product
    recipe.localised_name = {
        "recipe-name.maraxsis-hypnotized",
        {
            "?",
            recipe.localised_name or {"recipe-name." .. params.recipe},
            (old_main_product.localised_name or {"item-name." .. old_main_product.name}),
            {"fluid-name." .. old_main_product.name}
        }
    }

    data:extend{recipe}
end

-- science
for quality_change, prefix in pairs{"", "maraxsis-deepsea-research-"} do
    maraxsis.make_hypno_recipe{
        recipe = prefix .. "automation-science-pack",
        swaps = {
            {name = "automation-science-pack", swap_for = "automation-science-pack", quality_change = quality_change},
            {name = "iron-plate", swap_for = "copper-plate"},
            {name = "copper-cable", swap_for = "iron-gear-wheel"},
        }
    }

    maraxsis.make_hypno_recipe{
        recipe = prefix .. "logistic-science-pack",
        swaps = {
            {name = "logistic-science-pack", swap_for = "logistic-science-pack", quality_change = quality_change},
            {name = "pipe", swap_for = "transport-belt"},
            {name = "pump", swap_for = "inserter"},
        }
    }

    maraxsis.make_hypno_recipe{
        recipe = prefix .. "military-science-pack",
        swaps = {
            {name = "military-science-pack", swap_for = "military-science-pack", quality_change = quality_change},
            {name = "land-mine", swap_for = "grenade"},
            {name = "refined-concrete", swap_for = "wall"},
            {name = "firearm-magazine", swap_for = "piercing-rounds-magazine"},
        }
    }

    maraxsis.make_hypno_recipe{
        recipe = prefix .. "chemical-science-pack",
        swaps = {
            {name = "chemical-science-pack", swap_for = "chemical-science-pack", quality_change = quality_change},
            {name = "battery", swap_for = "sulfur"},
            {name = "constant-combinator", swap_for = "advanced-circuit"},
            {name = "electric-engine-unit", swap_for = "engine-unit"},
        }
    }

    maraxsis.make_hypno_recipe{
        recipe = prefix .. "production-science-pack",
        swaps = {
            {name = "production-science-pack", swap_for = "production-science-pack", quality_change = quality_change},
            {name = "barrel", swap_for = "rail"},
            {name = "agricultural-tower", swap_for = "electric-furnace"},
            {name = mods["rigor-module"] and "rigor-module" or "quality-module", swap_for = "productivity-module"},
        }
    }

    maraxsis.make_hypno_recipe{
        recipe = prefix .. "utility-science-pack",
        swaps = {
            {name = "utility-science-pack", swap_for = "utility-science-pack", quality_change = quality_change},
            {name = "rocket-fuel", swap_for = "low-density-structure"},
            {name = "maraxsis-super-sealant-substance", swap_for = "processing-unit", amount = 1},
            {name = "uranium-235", swap_for = "flying-robot-frame"},
        }
    }
end

-- nauvis
do
    maraxsis.make_hypno_recipe{
        technology = "nauvis",
        recipe = "biter-egg",
        swaps = {
            {name = "biter-egg", swap_for = "biter-egg", quality_min = "uncommon"},
        }
    }
    
    maraxsis.make_hypno_recipe{
        technology = "nauvis",
        recipe = "copper-plate",
        swaps = {
            {name = "iron-ore", swap_for = "copper-ore"},
        },
    }
    
    maraxsis.make_hypno_recipe{
        technology = "nauvis",
        recipe = "iron-plate",
        swaps = {
            {name = "copper-ore", swap_for = "iron-ore"},
        },
    }
end

-- vulcanus
do
    maraxsis.make_hypno_recipe{
        technology = "vulcanus",
        recipe = "tungsten-carbide",
        swaps = {
            {name = "tungsten-plate", swap_for = "tungsten-ore"},
            {name = "uranium-235", swap_for = "carbon"},
            {name = "tungsten-carbide", swap_for = "tungsten-carbide", quality_change = 1},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "vulcanus",
        recipe = "molten-iron-from-lava",
        swaps = {
            {name = "uranium-ore", swap_for = "stone", independent_probability = 0.05, amount = 1},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "vulcanus",
        recipe = "molten-copper-from-lava",
        swaps = {
            {name = "uranium-ore", swap_for = "stone", independent_probability = 0.05, amount = 1},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "vulcanus",
        recipe = "casting-steel",
        swaps = {
            {name = "engine-unit", swap_for = "steel-plate"},
            {name = "molten-iron", swap_for = "molten-iron", amount = 100},
        },
        energy_required = data.raw.recipe["engine-unit"].energy_required
    }

    maraxsis.make_hypno_recipe{
        technology = "vulcanus",
        recipe = "casting-copper",
        swaps = {
            {name = "molten-iron", swap_for = "molten-copper"},
        }
    }
    
    maraxsis.make_hypno_recipe{
        technology = "vulcanus",
        recipe = "casting-iron",
        swaps = {
            {name = "molten-copper", swap_for = "molten-iron"},
        }
    }
end

-- fulgora
do
    maraxsis.make_hypno_recipe{
        technology = "fulgora",
        recipe = "holmium-solution",
        swaps = {
            {type = "item", name = "holmium-plate", swap_for = "holmium-solution", amount = 5},
        }

    }

    if mods["Cerys-Moon-of-Fulgora"] then
        maraxsis.make_hypno_recipe{
            technology = "fulgora",
            recipe = "scrap-recycling",
            results = table.deepcopy(data.raw.recipe["cerys-nuclear-scrap-recycling"].results)
        }
    end
end

-- cerys
if mods["Cerys-Moon-of-Fulgora"] then
    maraxsis.make_hypno_recipe{
        technology = "cerys",
        recipe = "cerys-nuclear-scrap-recycling",
        results = table.deepcopy(data.raw.recipe["scrap-recycling"].results)
    }
end

-- gleba
do
    maraxsis.make_hypno_recipe{
        technology = "gleba",
        recipe = "pentapod-egg",
        swaps = {
            {name = "nutrients", swap_for = "nutrients", quality_min = "normal", quality_max = "normal"},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "gleba",
        recipe = "bioflux",
        swaps = {
            {name = "jelly", swap_for = "jelly", amount = 15},
            {name = "yumako-mash", swap_for = "yumako-mash", amount = 12},
            {name = "bioflux", swap_for = "bioflux", quality_change = 1},
        }
    }
end

-- aquilo
do
    maraxsis.make_hypno_recipe{
        technology = "aquilo",
        recipe = "ammoniacal-solution-separation",
        swaps = {
            {type = "fluid", name = "molten-iron", swap_for = "ice", amount = 25},
            {type = "fluid", name = "molten-copper", swap_for = "ammonia", amount = 25},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "aquilo",
        recipe = "ice-melting",
        swaps = {
            {type = "fluid", name = "water", swap_for = "ice", amount = 20, side = "ingredient"},
            {type = "item", name = "ice", swap_for = "water", amount = 1, side = "result"},
        },
    }
end

-- maraxsis
do
    maraxsis.make_hypno_recipe{
        technology = "maraxsis",
        recipe = "ske_h2o",
        swaps = {
            {name = "oxygen", swap_for = "hydrogen"},
            {name = "hydrogen", swap_for = "oxygen"},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "maraxsis",
        recipe = "maraxsis-salt-filter-cleaning",
        swaps = {
            {name = "saline-water", swap_for = "water"},
            {name = "raw-fish", swap_for = "carbon-fiber"},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "maraxsis",
        recipe = "microplastics",
        swaps = {
            {name = "raw-fish", swap_for = "maraxsis-tropical-fish"},
            {name = "yumako-mash", swap_for = "jelly"},
            {name = "railgun-ammo", swap_for = "piercing-rounds-magazine"},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "maraxsis",
        recipe = "maraxsis-carbon",
        swaps = {
            {name = "coal", swap_for = "carbon", amount = 2},
        },
    }

    maraxsis.make_hypno_recipe{
        technology = "maraxsis",
        recipe = "maraxsis-ooozma-specimen",
        hidden = false,
        swaps = {
            {name = "maraxsis-ooozma-specimen", swap_for = "maraxsis-ooozma-confinement-cell", side = "result"},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "maraxsis",
        recipe = "hydraulic-science-pack",
        swaps = {
            {name = "salt", swap_for = "salt", quality_change = 0},
            {name = "maraxsis-ooozma-specimen", swap_for = "maraxsis-ooozma-specimen", quality_change = -1},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "maraxsis",
        recipe = "maraxsis-limestone-crushing",
        swaps = {
            {type = "item", name = "maraxsis-coral", swap_for = "calcite"},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "maraxsis",
        recipe = "maraxsis-geothermal-sulfur",
        swaps = {
            {type = "fluid", name = "heavy-oil", swap_for = "sulfur", amount = 100},
        }
    }
end

-- space
do
    maraxsis.make_hypno_recipe{
        technology = "space",
        recipe = "advanced-metallic-asteroid-crushing",
        swaps = {
            {name = "oxide-asteroid-chunk", swap_for = "metallic-asteroid-chunk", side = "ingredient"},
        }
    }
    maraxsis.make_hypno_recipe{
        technology = "space",
        recipe = "metallic-asteroid-crushing",
        swaps = {
            {name = "carbonic-asteroid-chunk", swap_for = "metallic-asteroid-chunk", side = "ingredient"},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "space",
        recipe = "advanced-oxide-asteroid-crushing",
        swaps = {
            {name = "carbonic-asteroid-chunk", swap_for = "oxide-asteroid-chunk", side = "ingredient"},
        }
    }
    maraxsis.make_hypno_recipe{
        technology = "space",
        recipe = "oxide-asteroid-crushing",
        swaps = {
            {name = "metallic-asteroid-chunk", swap_for = "oxide-asteroid-chunk", side = "ingredient"},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "space",
        recipe = "advanced-carbonic-asteroid-crushing",
        swaps = {
            {name = "metallic-asteroid-chunk", swap_for = "carbonic-asteroid-chunk", side = "ingredient"},
        }
    }
    maraxsis.make_hypno_recipe{
        technology = "space",
        recipe = "carbonic-asteroid-crushing",
        swaps = {
            {name = "oxide-asteroid-chunk", swap_for = "carbonic-asteroid-chunk", side = "ingredient"},
        }
    }

    maraxsis.make_hypno_recipe{
        technology = "space",
        recipe = "promethium-science-pack",
        swaps = {
            {name = "pentapod-egg", swap_for = "biter-egg"},
            {name = "promethium-science-pack", swap_for = "promethium-science-pack", quality_min = "uncommon"},
        }
    }
end
