local function deep_equals(table1, table2) --Checks if two objects are identical. ie returns true if {"space-science-pack",1} and {"space-science-pack",1} are compared from different object references
    if table1 == table2 then return true end
    if type(table1) ~= "table" or type(table2) ~= "table" then return false end
    for key, value in pairs(table1) do
        if not deep_equals(value, table2[key]) then return false end
    end
    for key in pairs(table2) do
        if table1[key] == nil then return false end
    end
    return true
end





if data.raw.car["cargo-plane"] then --Checks if Aircraft-space-age is loaded.
    local aircraft_surface_conditions = data.raw.car["cargo-plane"].surface_conditions



    if aircraft_surface_conditions then
        for _,car in pairs(data.raw.car) do
            if deep_equals(car.surface_conditions,aircraft_surface_conditions) then
                car.surface_conditions = {{
                    property = "pressure",
                    min = 700,
                    max = 50000
                  },
                  {
                    property = "gravity",
                    max = 20,
                  }
                }
            end
        end
    end
    
end