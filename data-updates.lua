local techs_to_add_hydraulic_pack = {
    
}
for _, tech_name in pairs(techs_to_add_hydraulic_pack) do
    local tech = data.raw.technology[tech_name]
    if tech then
        table.insert(tech.unit.ingredients, {'h2o-hydraulic-science-pack', 1})
    end
end

local techs_to_add_hydraulic_pack_as_prerequisite = {
    
}
for _, tech_name in pairs(techs_to_add_hydraulic_pack_as_prerequisite) do
    local tech = data.raw.technology[tech_name]
    if tech then
        table.insert(tech.prerequisites, 'h2o-hydraulic-science-pack')
    end
end