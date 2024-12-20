if not mods["Rocket-Silo-Construction"] then return end
local collision_mask_util = require "__core__/lualib/collision-mask-util"

for _, silo in pairs {
    data.raw["assembling-machine"]["rsc-silo-stage1"],
    data.raw["assembling-machine"]["rsc-silo-stage2"],
    data.raw["assembling-machine"]["rsc-silo-stage3"],
    data.raw["assembling-machine"]["rsc-silo-stage4"],
    data.raw["assembling-machine"]["rsc-silo-stage5"],
    data.raw["assembling-machine"]["rsc-silo-stage6"],
} do
    silo.collision_mask = collision_mask_util.get_mask(silo)
    silo.collision_mask.layers[maraxsis_dome_collision_mask] = true
end
