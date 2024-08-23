local trench_movement_factor = 2
---@type PlanetPrototypeData
return {
    noise_layers = {
        moisture = {zoom = 1300*trench_movement_factor, from_parent = true},
        moisture_octave_1 = {zoom = 256*trench_movement_factor, from_parent = true},
        moisture_octave_2 = {zoom = 32*trench_movement_factor, from_parent = true},
        lava_master_master = {zoom = 500},
        lava_master = {zoom = 256},
        lava_river_1 = {zoom = 40},
        lava_river_2 = {zoom = 40},
        lava_river_3 = {zoom = 40},
        geothermal = {zoom = 256},
        rock_1 = {zoom = 30},
        rock_2 = {zoom = 40},
        decorative_1 = {zoom = 40},
        decorative_2 = {zoom = 40},
        primary_resource_octave_1 = {zoom = 200},
        primary_resource_octave_2 = {zoom = 100},
        primary_resource_octave_3 = {zoom = 30},
        bitumen = {zoom = 256},
    },
    parent_type = 'ocean',
    resources = {
        primary = {
            ['ore-zinc'] = {weight = 1},
            ['ore-tin'] = {weight = 1},
            ['stone'] = {weight = 0.6},
        },
        geothermal = {
            ['geothermal-crack'] = {weight = 75, infinite = true},
            ['volcanic-pipe'] = {weight = 25, infinite = true},
        },
        skeleton = {
            ['phosphate-rock-02'] = {weight = 50, infinite = true},
            ['sulfur-patch'] = {weight = 100, infinite = true},
        },
        bitumen = {
            ['bitumen-seep'] = {weight = 1},
        }
    },
    tags = {
        ['tidal'] = true,
        ['dark'] = true,
    },
    type = 'trench',
    connected_surfaces = {
        orbit_surface = nil,
        underwater_surface = nil,
        underground_surface = nil,
    },
}