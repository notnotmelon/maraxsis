local tech = data.raw.technology["landing-pad-unloading-bay-range"]
if not tech then return end
assert(tech.unit)

table.insert(tech.prerequisites, "maraxsis-project-seadragon")
table.insert(tech.prerequisites, "space-science-pack")
table.insert(tech.prerequisites, "production-science-pack")
table.insert(tech.prerequisites, "utility-science-pack")
table.insert(tech.prerequisites, "metallurgic-science-pack")
table.insert(tech.prerequisites, "electromagnetic-science-pack")
table.insert(tech.prerequisites, "agricultural-science-pack")

for _, ingredient in pairs{
    {"automation-science-pack",      1},
    {"logistic-science-pack",        1},
    {"chemical-science-pack",        1},
    {"space-science-pack",           1},
    {"production-science-pack",      1},
    {"utility-science-pack",         1},
    {"metallurgic-science-pack",     1},
    {"electromagnetic-science-pack", 1},
    {"agricultural-science-pack",    1},
    {"hydraulic-science-pack",       1},
} do
    table.insert(tech.unit.ingredients, ingredient)
end

tech.unit.time = math.max(tech.unit.time, 60)
tech.unit.count_formula = "2^(L-1)*5000"
tech.order = "ex[maraxsis]"
tech.icons = util.technology_icon_constant_capacity(data.raw.technology["landing-pad-unloading-bay"].icon)
tech.icon_size = data.raw.technology["landing-pad-unloading-bay"].icon_size

tech.unit.ingredients = table.dedupe(tech.unit.ingredients, function(element) return element[1] end)
tech.prerequisites = table.dedupe(tech.prerequisites)