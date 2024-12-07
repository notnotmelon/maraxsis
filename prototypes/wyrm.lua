data:extend {{
    type = "technology",
    name = "maraxsis-wyrm-confinement",
    icon = "__maraxsis__/graphics/technology/wyrm-confinement.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-wyrm-confinement-cell",
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-wyrm-specimen",
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-geothermal-sulfur"
        }
    },
    prerequisites = {"maraxsis-piscary"},
    research_trigger = {
        type = "craft-item",
        item = "maraxsis-pressure-dome"
    },
    order = "ee[wyrm-confinement]",
}}

data:extend {{
    type = "item",
    name = "maraxsis-wyrm-confinement-cell",
    icon = "__maraxsis__/graphics/icons/wyrm-confinement-cell.png",
    icon_size = 64,
    stack_size = 10,
}}

local wyrm_variants = {}
for i = 1, 4 do
    wyrm_variants[i] = {
        filename = "__maraxsis__/graphics/icons/wyrm-specimen-" .. i .. ".png",
        width = 64,
        height = 64,
        scale = 1 / 2,
        flags = {"icon"}
    }
end

data:extend {{
    type = "item",
    name = "maraxsis-wyrm-specimen",
    icon = "__maraxsis__/graphics/icons/wyrm-specimen-2.png",
    pictures = wyrm_variants,
    icon_size = 64,
    stack_size = 10,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-wyrm-confinement-cell",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "item", name = "maraxsis-glass-panes", amount = 5},
        {type = "item", name = "steel-plate",          amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-wyrm-confinement-cell", amount = 1},
    },
    allow_productivity = true
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-wyrm-specimen",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "item", name = "maraxsis-wyrm-confinement-cell", amount = 1},
        {type = "item", name = "maraxsis-fish-food",             amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-wyrm-specimen", amount = 1},
    },
    auto_recycle = false,
    category = "maraxsis-hydro-plant",
    surface_conditions = {{
        property = "pressure",
        min = 400000,
        max = 400000
    }}
}}

--[[
local legs = {}

data:extend{maraxsis.merge(data.raw['spider-vehicle']['spidertron'], {
    name = 'maraxsis-wyrm',
    icon = '__maraxsis__/graphics/icons/wyrm-specimen-2.png', -- todo: change to an actual icon
    icon_size = 64,
    flags = {'placeable-enemy', 'placeable-off-grid', 'not-repairable', 'breaths-air'},
    max_health = 1000,
    healing_per_tick = 0.01,
    collision_box = {{-1.5, -1.5}, {1.5, 1.5}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    energy_source = {
        type = 'void',
    },
    collision_mask = {layers = {}},
    burner = 'nil',
    inventory_size = 0,
    -- graphics_set
    spider_engine = {legs = legs},
    -- height
    chunk_exploration_radius = 0,
    movement_energy_consumption = '1W',
    automatic_weapon_cycling = false,
    trash_inventory_size = 0,
})}

local leg = maraxsis.merge(data.raw['spider-leg']['spidertron-leg-' .. ((i % 8) + 1)], {
    name = 'maraxsis-wyrm-leg-' .. i,
    part_length = i / 4,
    flags = {'not-on-map', 'placeable-off-grid'},
    movement_acceleration = data.raw['spider-leg']['spidertron-leg-1'].movement_acceleration * (num_legs - i + 1),
    allow_maraxsis_water_placement = true,
    minimal_step_size = 0,
})
--]]
