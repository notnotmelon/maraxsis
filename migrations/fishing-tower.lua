local surface = game.get_surface("maraxsis")
if not surface then return end

storage.fishing_tower_spawners = storage.fishing_tower_spawners or {}

for _, entity in pairs(surface.find_entities_filtered {name = "maraxsis-fishing-tower"}) do
    local fish_spawner = entity.surface.create_entity {
        name = "maraxsis-fish-spawner",
        position = entity.position,
        force = "neutral",
    }

    fish_spawner.destructible = false
    fish_spawner.active = true
    fish_spawner.operable = false
    fish_spawner.minable_flag = false

    local registration_number = script.register_on_object_destroyed(entity)
    storage.fishing_tower_spawners[registration_number] = fish_spawner
end
