local maraxsis_rocket_part = data.raw["recipe"]["maraxsis-rocket-part"]

maraxsis_rocket_part.ingredients = table.deepcopy(data.raw["recipe"]["rocket-part"].ingredients)
table.insert(maraxsis_rocket_part.ingredients, {type = "item", name = "maraxsis-super-sealant-substance", amount = 1})
