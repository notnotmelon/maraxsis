data:extend {{
    type = "tips-and-tricks-item",
    name = "maraxsis-briefing",
    category = "space-age",
    tag = "[planet=maraxsis]",
    indent = 0,
    order = "e-a",
    trigger = {
        type = "research",
        technology = "planet-discovery-maraxsis"
    },
    skip_trigger = {
        type = "or",
        triggers = {
            {
                type = "change-surface",
                surface = "maraxsis"
            },
            {
                type = "sequence",
                triggers =
                {
                    {
                        type = "research",
                        technology = "planet-discovery-maraxsis"
                    },
                    {
                        type = "time-elapsed",
                        ticks = 15 * minute
                    },
                    {
                        type = "time-since-last-tip-activation",
                        ticks = 15 * minute
                    }
                }
            }
        }
    },
    simulation = {
        planet = "maraxsis",
        generate_map = false,
        init = [[
            game.simulation.camera_position = {0, 1.5}

            for x = -12, 12, 1 do
                for y = -6, 6 do
                    game.surfaces[1].set_tiles{{position = {x, y}, name = "sand-1-underwater"}}
                end
            end

            game.surfaces[1].create_entity {
                name = "maraxsis-water-shader",
                position = {0, 0},
                create_build_effect_smoke = false
            }

            for _, cliff_info in pairs {
                {position = {-2, 2.5}, orientation = "north-to-east"},
                {position = {-2, -1.5}, orientation = "west-to-south"},
                {position = {-6, -1.5}, orientation = "north-to-east"},
                {position = {-6, -5.5}, orientation = "west-to-south"},
                {position = {-10, -5.5}, orientation = "north-to-east"},
                {position = {-10, -9.5}, orientation = "west-to-south"},
                {position = {-14, -9.5}, orientation = "none-to-east"},
                {position = {2, 2.5}, orientation = "west-to-east"},
                {position = {6, 2.5}, orientation = "west-to-east"},
                {position = {10, 2.5}, orientation = "west-to-east"},
                {position = {14, 2.5}, orientation = "west-to-east"},
                {position = {18, 2.5}, orientation = "west-to-east"},
                {position = {22, 2.5}, orientation = "west-to-none"},
            } do
                local position = cliff_info.position
                position = {position[1], position[2] - 2}
                game.surfaces[1].create_entity {
                    name = "cliff-maraxsis",
                    position = position,
                    cliff_orientation = cliff_info.orientation,
                    create_build_effect_smoke = false
                }
            end

            game.surfaces[1].create_entity {
                name = "maraxsis-tropical-fish-10",
                position = {-5, 3},
                create_build_effect_smoke = false
            }

            game.surfaces[1].create_entity {
                name = "maraxsis-tropical-fish-5",
                position = {4, -2},
                create_build_effect_smoke = false
            }

            game.surfaces[1].create_entity {
                name = "maraxsis-tropical-fish-9",
                position = {1, 8},
                create_build_effect_smoke = false
            }.orientation = 0.24

            local create_list = {}
            table.insert(create_list, { name = "waves-decal", position = {6, -6}, amount = 1})
            for k, position in pairs {{-10, -3}, {-8, -3}, {4, -3}, {8, 1}} do
                table.insert(create_list, { name = "v-brown-carpet-grass", position = position, amount = 1})
            end
            for k, position in pairs {{-10, 2},{-8, 3}, {-7, 3}, {5, 3}, {7, 3}, {3, 4}, {6, 4}, {1, 5}} do
                table.insert(create_list, { name = "yellow-lettuce-lichen-cups-3x3", position = position, amount = 1})
            end
            for k, position in pairs {{-1, 7}, {-2, 8}, {-3, 4}, {0, 3}, {8, 4}} do
                table.insert(create_list, { name = "honeycomb-fungus-1x1", position = position, amount = 1})
            end
            for x = -12, -6, 1 do
                for y = -6, -2 do
                    table.insert(create_list, { name = "polycephalum-slime", position = {x, y}, amount = 1})
                end
            end
            game.surfaces[1].create_decoratives{decoratives = create_list}
        ]],
        checkboard = false,
        planet = "maraxsis",
        mute_wind_sounds = false,
    },
}}

data:extend {{
    type = "tips-and-tricks-item",
    name = "maraxsis-trench-exploration",
    category = "space-age",
    tag = "[item=maraxsis-diesel-submarine]",
    indent = 1,
    order = "e-b",
    trigger = {
        type = "build-entity",
        entity = "maraxsis-diesel-submarine",
    },
    simulation = {
        save = "__maraxsis__/prototypes/tips-and-tricks/maraxsis.zip", -- todo: change to trench exploration save
        mods = {},
        generate_map = false,
        --init = 'game.camera_player = game.get_player(1)', https://forums.factorio.com/viewtopic.php?f=7&t=115110
        checkboard = false
    },
}}

data:extend {{
    type = "tips-and-tricks-item",
    name = "maraxsis-underwater-machines",
    category = "space-age",
    tag = "[item=maraxsis-hydro-plant]",
    indent = 1,
    order = "e-c",
    trigger = {
        type = "research",
        technology = "planet-discovery-maraxsis"
    },
    dependencies = {"maraxsis-briefing"}
}}
