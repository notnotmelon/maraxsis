data:extend {{
    type = "technology",
    name = "maraxsis-preservatives",
    icon = "__maraxsis__/graphics/technology/preservatives.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-salted-fish"
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-salted-tropical-fish"
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-defluxed-bioflux"
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-salted-science"
        },
    },
    prerequisites = {"maraxsis-project-seadragon"},
    unit = {
        count = 1000,
        ingredients = {
            {"agricultural-science-pack", 1},
            {"hydraulic-science-pack",    1},
        },
        time = 60,
    },
    order = "ea[preservatives]",
}}

local salted_fish = table.deepcopy(data.raw.capsule["raw-fish"])
salted_fish.name = "maraxsis-salted-fish"
salted_fish.spoil_result = "raw-fish"
salted_fish.icon = "__maraxsis__/graphics/icons/salted-fish.png"
salted_fish.icon_size = 64
data:extend {salted_fish}

local salted_tropical_fish = table.deepcopy(data.raw.capsule["maraxsis-tropical-fish"])
salted_tropical_fish.name = "maraxsis-salted-tropical-fish"
salted_tropical_fish.spoil_result = "maraxsis-tropical-fish"
salted_tropical_fish.icon = "__maraxsis__/graphics/icons/salted-tropical-fish.png"
salted_tropical_fish.icon_size = 64
salted_tropical_fish.pictures = nil
data:extend {salted_tropical_fish}

local defluxed_bioflux = table.deepcopy(data.raw.capsule.bioflux)
defluxed_bioflux.name = "maraxsis-defluxed-bioflux"
defluxed_bioflux.spoil_result = "bioflux"
defluxed_bioflux.icon = "__maraxsis__/graphics/icons/defluxed-bioflux.png"
defluxed_bioflux.icon_size = 64
data:extend {defluxed_bioflux}

local salted_science = table.deepcopy(data.raw.tool["agricultural-science-pack"])
salted_science.name = "maraxsis-salted-science"
salted_science.spoil_result = "agricultural-science-pack"
salted_science.icon = "__maraxsis__/graphics/icons/salted-science.png"
salted_science.icon_size = 64
salted_science.localised_description = nil
data:extend {salted_science}

data:extend {{
    type = "recipe",
    name = "maraxsis-salted-fish",
    enabled = false,
    energy_required = 0.5,
    ingredients = {
        {type = "item", name = "raw-fish",      amount = 1},
        {type = "item", name = "maraxsis-salt", amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-salted-fish", amount = 1},
    },
    allow_productivity = false,
    category = "maraxsis-hydro-plant",
    result_is_always_fresh = false,
    auto_recycle = false,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-salted-tropical-fish",
    enabled = false,
    energy_required = 0.5,
    ingredients = {
        {type = "item", name = "maraxsis-tropical-fish", amount = 1},
        {type = "item", name = "maraxsis-salt",          amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-salted-tropical-fish", amount = 1},
    },
    allow_productivity = false,
    category = "maraxsis-hydro-plant",
    result_is_always_fresh = false,
    auto_recycle = false,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-defluxed-bioflux",
    enabled = false,
    energy_required = 0.5,
    ingredients = {
        {type = "item", name = "bioflux",       amount = 1},
        {type = "item", name = "maraxsis-salt", amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-defluxed-bioflux", amount = 1},
    },
    allow_productivity = false,
    category = "maraxsis-hydro-plant",
    result_is_always_fresh = false,
    auto_recycle = false,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-salted-science",
    enabled = false,
    energy_required = 0.5,
    ingredients = {
        {type = "item", name = "agricultural-science-pack", amount = 1},
        {type = "item", name = "maraxsis-salt",          amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-salted-science", amount = 1},
    },
    allow_productivity = false,
    category = "maraxsis-hydro-plant",
    result_is_always_fresh = false,
    auto_recycle = false,
}}

local function update_recipe_icon(recipe)
    local item = data.raw.capsule[recipe.name] or data.raw.item[recipe.name] or data.raw.tool[recipe.name]
    local salt = data.raw.item["maraxsis-salt"]
    recipe.icons = {
        {icon = recipe.icon or item.icon, icon_size = recipe.icon_size or item.icon_size},
        {icon = salt.icon,                icon_size = salt.icon_size,                    scale = 0.4, shift = {6, 6}},
    }
    recipe.icon = nil
    recipe.icon_size = nil
end

update_recipe_icon(data.raw.recipe["maraxsis-salted-fish"])
update_recipe_icon(data.raw.recipe["maraxsis-salted-tropical-fish"])
update_recipe_icon(data.raw.recipe["maraxsis-defluxed-bioflux"])
update_recipe_icon(data.raw.recipe["maraxsis-salted-science"])
