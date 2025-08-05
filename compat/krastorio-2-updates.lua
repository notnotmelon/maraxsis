if not mods["Krastorio2-spaced-out"] and not mods["Krastorio2"] then return end

local fluid_replacements = {
    ["kr-oxygen"] = "oxygen",
    ["kr-hydrogen"] = "hydrogen",
}

for _, recipe in pairs(data.raw.recipe) do
    local product_lists = {}
    if recipe.ingredients then product_lists[#product_lists + 1] = recipe.ingredients end
    if recipe.results then product_lists[#product_lists + 1] = recipe.results end

    for _, products in pairs(product_lists) do
        for _, product in pairs(products) do
            if fluid_replacements[product.name] then
                product.name = fluid_replacements[product.name]
            end
        end
    end

    if recipe.main_product and fluid_replacements[recipe.main_product] then
        recipe.main_product = fluid_replacements[recipe.main_product]
    end
end

for fluid in pairs(fluid_replacements) do
    data.raw.fluid[fluid] = nil
end

local fluid_void_recipes_to_delete = table.invert {
    "kr-burn-kr-oxygen",
    "kr-burn-kr-hydrogen",
}

for recipe_name in pairs(fluid_void_recipes_to_delete) do
    data.raw.recipe[recipe_name] = nil
end

local new_effects = {}
for _, effect in pairs(data.raw.technology["kr-fluid-excess-handling"].effects) do
    if effect.type == "unlock-recipe" and fluid_void_recipes_to_delete[effect.recipe] then
        -- pass
    else
        new_effects[#new_effects + 1] = effect
    end
end
data.raw.technology["kr-fluid-excess-handling"].effects = new_effects

data.raw.recipe["kr-hydrogen"].localised_name = {"fluid-name.hydrogen"}
data.raw.recipe["kr-hydrogen"].icon = nil
data.raw.recipe["kr-hydrogen"].icon_size = nil
data.raw.recipe["kr-oxygen"].localised_name = {"fluid-name.oxygen"}
data.raw.recipe["kr-oxygen"].icon = nil
data.raw.recipe["kr-oxygen"].icon_size = nil

local new_ingredients = {}
for _, ingredient in pairs(data.raw.recipe["promethium-science-pack"].ingredients) do
    if ingredient.name == "biter-egg" then
        ingredient.amount = ingredient.amount * 2
        table.insert(data.raw.recipe["kr-promethium-research-data"].ingredients, ingredient)
    else
        table.insert(new_ingredients, ingredient)
    end
end
data.raw.recipe["promethium-science-pack"].ingredients = new_ingredients
