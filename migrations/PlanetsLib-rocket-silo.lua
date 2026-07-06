local rocket_silo_lib = require("__PlanetsLib__.scripts.rocket-parts")

if not game.planets["maraxsis"] or not game.planets["maraxsis"].surface then
    return
end

local maraxsis_rocket_silos = game.planets["maraxsis"].surface.find_entities_filtered{type = "rocket-silo"}
for _, silo in pairs(maraxsis_rocket_silos) do
    local fake_event = {
        entity = silo
    }

    -- Runs PlanetsLib's on_built_rocket_silo code, which locks the rocket silo if configured to. See PlanetsLib.assign_rocket_part_recipe.
    rocket_silo_lib.on_built_rocket_silo(fake_event)
end
