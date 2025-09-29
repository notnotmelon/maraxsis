if not mods["Krastorio2-spaced-out"] then return end

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

data.raw["assembling-machine"]["kr-quantum-computer"].energy_usage = "50MW"
