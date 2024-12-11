local surface = game.get_surface("maraxsis")
if not surface then return end

local mgs = surface.map_gen_settings
mgs.autoplace_settings.entity.settings["maraxsis-polylplast"] = {}
surface.map_gen_settings = mgs
