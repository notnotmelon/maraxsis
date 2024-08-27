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

local function add_fuel_value(fluid, value)
    fluid = data.raw.fluid[fluid]
    if not fluid then return end
    fluid.fuel_value = fluid.fuel_value or value
end

add_fuel_value('crude-oil', '150kJ')
add_fuel_value('petroleum-gas', '200kJ')
add_fuel_value('hydrogen', '225kJ')
add_fuel_value('heavy-oil', '250kJ')
add_fuel_value('light-oil', '300kJ')

for _, fluid in pairs(data.raw.fluid) do -- todo: check fluid fuel category
    local fuel_value = fluid.fuel_value
    if not fuel_value or type(fuel_value) ~= 'string' then goto continue end
    local barrel = data.raw.item[fluid.name .. '-barrel']
    if not barrel then goto continue end
    if barrel.fuel_category then error('Dihydrogen Monoxide encountered a mod incompatibility! Barrel ' .. barrel.name .. ' already has a fuel category. Please report this') end

    local number_part, unit = fuel_value:match('^(%d+)(.*)')
    number_part = tonumber(number_part)
    if not number_part then goto continue end
    barrel.fuel_value = tostring(number_part * 50) .. unit -- 50 fluid per barrel
    barrel.fuel_category = 'h2o-diesel'
    barrel.burnt_result = 'empty-barrel'
    ::continue::
end

local nightvision_to_extend = {}
for _, nightvision in pairs(data.raw['night-vision-equipment']) do
    if nightvision.name == 'ee-super-night-vision-equipment' then goto continue end

    local disabled = table.deepcopy(nightvision)
    disabled.take_result = nightvision.take_result or nightvision.name
    disabled.name = nightvision.name .. '-disabled'
    disabled.darkness_to_turn_on = 1
    disabled.localised_name = nightvision.localised_name or {'equipment-name.' .. nightvision.name}
    
    disabled.localised_description = {'',
        nightvision.localised_description or {'?', {'', {'equipment-description.' .. nightvision.name}, '\n'}, {'', {'item-description.' .. nightvision.name}, '\n'}, ''},
        {'equipment-description.nightvision-disabled-underwater'}
    }
    
    nightvision_to_extend[#nightvision_to_extend + 1] = disabled

    ::continue::
end
data:extend(nightvision_to_extend)
