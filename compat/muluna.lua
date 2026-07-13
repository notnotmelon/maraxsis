-- https://github.com/notnotmelon/maraxsis/issues/417

if not mods["planet-muluna"] then return end

for surface in pairs(maraxsis_constants.MARAXSIS_SURFACES) do
    PlanetsLib.create_planet_entity_variant(
        surface,
        data.raw["rocket-silo"]["muluna-big-rocket-silo"],
        {
            name = "maraxsis-muluna-big-rocket-silo",
            localised_name = {"entity-name.muluna-big-rocket-silo"},
            localised_description = {"entity-description.muluna-big-rocket-silo"},
            rocket_entity = "maraxsis-rocket-silo-rocket",
            fixed_recipe = "maraxsis-rocket-part",
            disabled_when_recipe_not_researched = true,
            placeable_by = {{item = "muluna-big-rocket-silo", count = 1}},
            flags = {"placeable-player", "player-creation", "not-in-made-in"},
            hidden = true,
            hidden_in_factoriopedia = true,
        },
        "maraxsis-runtime-entity-replacement",
        "muluna-big-rocket-silo"
    )
end
