local surface = game.get_surface("maraxsis")
if not surface then return end

local mgs = surface.map_gen_settings
mgs.autoplace_settings.tile.settings["lowland-red-vein-2-underwater"] = {}
surface.map_gen_settings = mgs
