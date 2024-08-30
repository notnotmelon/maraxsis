data:extend {{
    type = 'tips-and-tricks-item-category',
    name = 'maraxsis',
    order = 'q[maraxsis]'
}}

data:extend {{
    type = 'tips-and-tricks-item',
    name = 'h2o-maraxsis',
    category = 'maraxsis',
    tag = '[technology=h2o-maraxsis]',
    indent = 0,
    trigger = {
        type = 'research',
        technology = 'h2o-maraxsis'
    },
    simulation = {
        save = '__maraxsis__/prototypes/tips-and-tricks/maraxsis.zip',
        mods = {},
        generate_map = false,
        --init = 'game.camera_player = game.get_player(1)', https://forums.factorio.com/viewtopic.php?f=7&t=115110
        checkboard = false
    },
    is_title = true
}}

data:extend {{
    type = 'tips-and-tricks-item',
    name = 'h2o-trench-exploration',
    category = 'maraxsis',
    tag = '[item=h2o-diesel-submarine]',
    indent = 1,
    trigger = {
        type = 'build-entity',
        count = 1,
        entity = 'h2o-diesel-submarine',
    },
    simulation = {
        save = '__maraxsis__/prototypes/tips-and-tricks/maraxsis.zip', -- todo: change to trench exploration save
        mods = {},
        generate_map = false,
        --init = 'game.camera_player = game.get_player(1)', https://forums.factorio.com/viewtopic.php?f=7&t=115110
        checkboard = false
    },
}}

data:extend {{
    type = 'tips-and-tricks-item',
    name = 'h2o-quantum-coraldynamics',
    category = 'maraxsis',
    tag = '[item=h2o-heart-of-the-sea]',
    indent = 1,
    trigger = {
        type = 'craft-item',
        count = 1,
        item = 'h2o-quantum-computer',
        event_type = 'crafting-finished'
    },
}}

data:extend {{
    type = 'tips-and-tricks-item',
    name = 'h2o-underwater-machines',
    category = 'maraxsis',
    tag = '[item=h2o-hydro-plant]',
    indent = 1,
    trigger = {
        type = 'research',
        technology = 'h2o-maraxsis'
    },
    dependencies = {'h2o-maraxsis'}
}}
