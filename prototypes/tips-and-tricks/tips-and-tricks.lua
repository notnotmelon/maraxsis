data:extend {{
    type = "tips-and-tricks-item-category",
    name = "maraxsis",
    order = "q[maraxsis]"
}}

data:extend {{
    type = "tips-and-tricks-item",
    name = "maraxsis-maraxsis",
    category = "maraxsis",
    tag = "[technology=maraxsis-maraxsis]",
    indent = 0,
    trigger = {
        type = "research",
        technology = "maraxsis-maraxsis"
    },
    simulation = {
        save = "__maraxsis__/prototypes/tips-and-tricks/maraxsis.zip",
        mods = {},
        generate_map = false,
        --init = 'game.camera_player = game.get_player(1)', https://forums.factorio.com/viewtopic.php?f=7&t=115110
        checkboard = false
    },
    is_title = true
}}

data:extend {{
    type = "tips-and-tricks-item",
    name = "maraxsis-trench-exploration",
    category = "maraxsis",
    tag = "[item=maraxsis-diesel-submarine]",
    indent = 1,
    trigger = {
        type = "build-entity",
        count = 1,
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
    category = "maraxsis",
    tag = "[item=maraxsis-hydro-plant]",
    indent = 1,
    trigger = {
        type = "research",
        technology = "maraxsis-maraxsis"
    },
    dependencies = {"maraxsis-maraxsis"}
}}
