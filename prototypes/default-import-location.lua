local function set_default_import_location(item, planet)
    for item_prototype in pairs(defines.prototypes.item) do
        local item = (data.raw[item_prototype] or {})[item]
        if item then
            item.default_import_location = planet
            return
        end
    end

    error("Item not found: " .. item, 2)
end

set_default_import_location("maraxsis-big-cliff-explosives", "nauvis")
set_default_import_location("sp-spidertron-dock", "maraxsis")
set_default_import_location("constructron", "maraxsis")
set_default_import_location("maraxsis-diesel-submarine", "maraxsis")
set_default_import_location("maraxsis-nuclear-submarine", "maraxsis")
set_default_import_location("maraxsis-hydro-plant", "maraxsis")
set_default_import_location("maraxsis-fishing-tower", "maraxsis")
set_default_import_location("maraxsis-sonar", "maraxsis")
set_default_import_location("maraxsis-pressure-dome", "maraxsis")
set_default_import_location("maraxsis-coral", "maraxsis")
set_default_import_location("maraxsis-limestone", "maraxsis")
set_default_import_location("maraxsis-sand", "maraxsis")
set_default_import_location("maraxsis-glass-panes", "maraxsis")
set_default_import_location("maraxsis-fish-food", "maraxsis")
set_default_import_location("maraxsis-tropical-fish", "maraxsis")
set_default_import_location("maraxsis-microplastics", "maraxsis")
set_default_import_location("maraxsis-wyrm-specimen", "maraxsis")
set_default_import_location("maraxsis-wyrm-confinement-cell", "maraxsis")
set_default_import_location("maraxsis-super-sealant-substance", "maraxsis")
set_default_import_location("maraxsis-salt", "maraxsis")
set_default_import_location("maraxsis-salt-filter", "maraxsis")
set_default_import_location("maraxsis-saturated-salt-filter", "maraxsis")
set_default_import_location("maraxsis-salted-fish", "nauvis")
set_default_import_location("maraxsis-salted-tropical-fish", "maraxsis")
set_default_import_location("maraxsis-defluxed-bioflux", "gleba")
set_default_import_location("hydraulic-science-pack", "maraxsis")
set_default_import_location("maraxsis-atmosphere-barrel", "nauvis")
set_default_import_location("maraxsis-liquid-atmosphere-barrel", "aquilo")
set_default_import_location("maraxsis-brackish-water-barrel", "maraxsis")
set_default_import_location("maraxsis-saline-water-barrel", "maraxsis")
set_default_import_location("maraxsis-oxygen-barrel", "maraxsis")
set_default_import_location("maraxsis-hydrogen-barrel", "maraxsis")
set_default_import_location("maraxsis-torpedo", "nauvis")
set_default_import_location("maraxsis-explosive-torpedo", "nauvis")
set_default_import_location("maraxsis-atomic-torpedo", "nauvis")
set_default_import_location("maraxsis-fat-man", "nauvis")
set_default_import_location("maraxsis-abyssal-diving-gear", "maraxsis")
set_default_import_location("maraxsis-salt-reactor", "maraxsis")
