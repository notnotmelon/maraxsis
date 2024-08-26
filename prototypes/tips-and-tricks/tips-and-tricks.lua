data:extend{{
    type = 'tips-and-tricks-item-category',
    name = 'maraxsis',
    order = 'q[maraxsis]'
}}

data:extend{{
    type = 'tips-and-tricks-item',
    name = 'h2o-maraxsis',
    category = 'maraxsis',
    tag = '[technology=h2o-maraxsis]',
    indent = 0,
    trigger = {
        type = 'research',
        technology = 'h2o-maraxsis'
    },
    is_title = true
}}

data:extend{{
    type = 'tips-and-tricks-item',
    name = 'h2o-quantum-coraldynamics',
    category = 'maraxsis',
    tag = '[item=h2o-heart-of-the-sea]',
    indent = 1,
    trigger = {
        type = 'build-entity',
        count = 1,
        entity = 'h2o-hydro-plant', -- todo change to quantum computer
    }
}}