local rocket_silo_lib = require("__PlanetsLib__.scripts.rocket-parts")
if game.planets["maraxsis"] and game.planets["maraxsis"].surface then
    local maraxsis_rocket_silos = game.planets["maraxsis"].surface.find_entities_filtered{{filter_type = "name",name="rocket-silo"}}
    for _,silo in pairs(maraxsis_rocket_silos) do
        local fake_event = {
            entity = silo
        }
        rocket_silo_lib.on_built_rocket_silo(fake_event) --Runs PlanetsLib's on_built_rocket_silo code, which locks the rocket silo if configured to. See PlanetsLib.assign_rocket_part_recipe.
    end
end
