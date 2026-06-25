if not mods["aai-industry"] then return end
if mods.pystellarexpedition then return end

data.raw.recipe["motor"].categories = {"maraxsis-hydro-plant-or-assembling"}
data.raw.recipe["electric-motor"].categories = {"maraxsis-hydro-plant-or-assembling"}

data.raw.item["maraxsis-glass-panes"].localised_name = {"item-name.maraxsis-reinforced-glass"}
