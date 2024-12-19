local planet_map_gen = require "prototypes.planet.map-gen"

maraxsis.on_event(maraxsis.events.on_init(), function()
    for surface_name, map_gen_settings in pairs(planet_map_gen) do
        local surface = game.get_surface(surface_name)
        if not surface then goto continue end
        map_gen_settings = map_gen_settings()

        local previous_mgs = surface.map_gen_settings
        local previous_autoplace_settings = previous_mgs.autoplace_settings
        previous_mgs.autoplace_settings = map_gen_settings.autoplace_settings

        for _, autoplace_type in pairs {"tile", "decorative", "entity"} do
            local new_autoplace_settings = map_gen_settings.autoplace_settings[autoplace_type].settings
            for name, settings in pairs(previous_autoplace_settings[autoplace_type].settings) do
                if new_autoplace_settings[name] then
                    new_autoplace_settings[name] = settings
                end
            end
            map_gen_settings.autoplace_settings[autoplace_type].treat_missing_as_default = true
        end

        previous_mgs.cliff_settings = map_gen_settings.cliff_settings

        surface.map_gen_settings = previous_mgs
        ::continue::
    end
end)
