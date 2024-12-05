local surface = game.get_surface("maraxsis-trench")
if not surface then return end

local mgs = surface.map_gen_settings
mgs.autoplace_settings.entity.settings["vulcanus-chimney"] = nil
mgs.autoplace_settings.entity.settings["maraxsis-chimney"] = {}
surface.map_gen_settings = mgs
