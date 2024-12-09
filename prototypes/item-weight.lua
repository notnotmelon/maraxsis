local function i_want_to_fit_this_many_per_rocket(item, count)
    for item_type in pairs(defines.prototypes.item) do
        local item = (data.raw[item_type] or {})[item]
        if item then
            if count == 0 then
                item.weight = 5000000
            else
                item.weight = 1000000 / count
            end
            return
        end
    end
    error("Could not find item " .. item)
end

i_want_to_fit_this_many_per_rocket("maraxsis-fishing-tower", 20)
i_want_to_fit_this_many_per_rocket("maraxsis-big-cliff-explosives", 10)
i_want_to_fit_this_many_per_rocket("sp-spidertron-dock", 20)
i_want_to_fit_this_many_per_rocket("maraxsis-diesel-submarine", 1)
i_want_to_fit_this_many_per_rocket("maraxsis-nuclear-submarine", 1)
i_want_to_fit_this_many_per_rocket("constructron", 1)
i_want_to_fit_this_many_per_rocket("maraxsis-hydro-plant", 5)
i_want_to_fit_this_many_per_rocket("maraxsis-sonar", 20)
i_want_to_fit_this_many_per_rocket("maraxsis-pressure-dome", 0)
i_want_to_fit_this_many_per_rocket("maraxsis-coral", 500)
i_want_to_fit_this_many_per_rocket("maraxsis-limestone", 200)
i_want_to_fit_this_many_per_rocket("maraxsis-sand", 500)
i_want_to_fit_this_many_per_rocket("maraxsis-glass-panes", 500)
i_want_to_fit_this_many_per_rocket("maraxsis-fish-food", 100)
i_want_to_fit_this_many_per_rocket("maraxsis-tropical-fish", 100)
i_want_to_fit_this_many_per_rocket("maraxsis-microplastics", 1000)
i_want_to_fit_this_many_per_rocket("maraxsis-wyrm-specimen", 20)
i_want_to_fit_this_many_per_rocket("maraxsis-wyrm-confinement-cell", 20)
i_want_to_fit_this_many_per_rocket("maraxsis-super-sealant-substance", 50)
i_want_to_fit_this_many_per_rocket("maraxsis-salt", 1000)
i_want_to_fit_this_many_per_rocket("maraxsis-salt-filter", 50)
i_want_to_fit_this_many_per_rocket("maraxsis-saturated-salt-filter", 50)
i_want_to_fit_this_many_per_rocket("maraxsis-salted-fish", 300)
i_want_to_fit_this_many_per_rocket("maraxsis-salted-tropical-fish", 100)
i_want_to_fit_this_many_per_rocket("maraxsis-defluxed-bioflux", 1000)
i_want_to_fit_this_many_per_rocket("maraxsis-torpedo", 25)
i_want_to_fit_this_many_per_rocket("maraxsis-explosive-torpedo", 25)
i_want_to_fit_this_many_per_rocket("maraxsis-atomic-torpedo", 0)
i_want_to_fit_this_many_per_rocket("maraxsis-abyssal-diving-gear", 1)
i_want_to_fit_this_many_per_rocket("maraxsis-trench-duct", 1)
i_want_to_fit_this_many_per_rocket("maraxsis-salt-reactor", 1)
i_want_to_fit_this_many_per_rocket("maraxsis-electricity", 0)
i_want_to_fit_this_many_per_rocket("maraxsis-salted-science", 1000)
