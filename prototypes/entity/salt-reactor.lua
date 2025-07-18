local hit_effects = require("__base__.prototypes.entity.hit-effects")
local item_sounds = require("__base__.prototypes.item_sounds")

data:extend {{
    type = "animation",
    name = "maraxsis-salt-reactor-animation",
    filename = "__maraxsis__/graphics/entity/salt-reactor/salt-reactor.png",
    priority = "high",
    width = 3200 / 8,
    height = 3200 / 8,
    shift = util.by_pixel(0, 0),
    frame_count = 60,
    line_length = 8,
    animation_speed = 1,
    scale = 0.5,
}}

data:extend {{
    type = "animation",
    name = "maraxsis-salt-reactor-animation-glow",
    filename = "__maraxsis__/graphics/entity/salt-reactor/salt-reactor-emission.png",
    priority = "high",
    width = 3200 / 8,
    height = 3200 / 8,
    shift = util.by_pixel(0, 0),
    frame_count = 60,
    line_length = 8,
    animation_speed = 1,
    scale = 0.5,
    draw_as_glow = true,
    blend_mode = "additive",
}}

data:extend {{
    type = "fusion-reactor",
    name = "maraxsis-salt-reactor",
    icon = "__maraxsis__/graphics/icons/salt-reactor.png",
    maraxsis_buildability_rules = {water = false, dome = true, coral = false, trench = true, trench_entrance = false, trench_lava = false},
    heating_energy = data.raw["generator"]["steam-turbine"].heating_energy,
    icon_size = 64,
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 0.5, result = "maraxsis-salt-reactor"},
    max_health = 1000,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    working_sound = {
        sound = {
            filename = "__maraxsis__/sounds/salt-reactor.ogg",
            volume = 1,
        },
        apparent_volume = 1.5,
        max_sounds_per_type = 3,
        audible_distance_modifier = 1,
        fade_in_ticks = 4,
        fade_out_ticks = 20
    },
    resistances = {
        {
            type = "fire",
            percent = 80
        }
    },
    collision_box = {{-2.9, -2.9}, {2.9, 2.9}},
    selection_box = {{-3, -3}, {3, 3}},
    damaged_trigger_effect = hit_effects.entity(),
    icon_draw_specification = {shift = {0, -0.5}, scale = 1.5},
    icons_positioning = {{
        inventory_index = defines.inventory.furnace_modules, shift = {0, 0.9}, max_icons_per_row = 3
    }},
    graphics_set = {
        structure = {
            layers = {
                {
                    filename = "__maraxsis__/graphics/entity/salt-reactor/salt-reactor.png",
                    priority = "high",
                    width = 3200 / 8,
                    height = 3200 / 8,
                    shift = util.by_pixel(0, 0),
                    frame_count = 60,
                    line_length = 8,
                    animation_speed = 1,
                    scale = 0.5,
                },
                {
                    filename = "__maraxsis__/graphics/entity/salt-reactor/salt-reactor-sh.png",
                    priority = "high",
                    width = 800,
                    height = 600,
                    scale = 0.5,
                    frame_count = 1,
                    shift = util.by_pixel(0, 0),
                    draw_as_shadow = true,
                },
            },
        },
        plasma_category = "maraxsis-salt-reactor"
    },
    burner = {
        type = "burner",
        fuel_categories = {"maraxsis-salt-reactor"},
        effectivity = 1,
        fuel_inventory_size = 1,
        burnt_inventory_size = 1,
        light_flicker = {
            color = defines.color.limegreen,
            minimum_intensity = 0.2,
            maximum_intensity = 0.4,
            minimum_light_size = 2.5
        }
    },
    two_direction_only = true,
    power_input = "2MW",
    neighbour_bonus = 1.50,
    neighbour_connectable = table.deepcopy(data.raw["fusion-reactor"]["fusion-reactor"].neighbour_connectable),
    input_fluid_box = table.deepcopy(data.raw["fusion-reactor"]["fusion-reactor"].input_fluid_box),
    output_fluid_box = table.deepcopy(data.raw["fusion-reactor"]["fusion-reactor"].output_fluid_box),
    energy_source = table.deepcopy(data.raw["fusion-reactor"]["fusion-reactor"].energy_source),
    max_fluid_usage = 300 / second, -- at normal quality,
    source_inventory_size = 1,
    crafting_categories = {"maraxsis-salt-reactor"},
}}

local em_plant_pictures = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures
for _, fluid_box in pairs{
    data.raw["fusion-reactor"]["maraxsis-salt-reactor"].input_fluid_box.pipe_connections,
    data.raw["fusion-reactor"]["maraxsis-salt-reactor"].output_fluid_box.pipe_connections
} do
    for _, pipe_connection in pairs(fluid_box) do
        local direction = table.invert(defines.direction)[pipe_connection.direction]
        for _, em_pipe_picture in pairs(em_plant_pictures[direction].layers) do
            em_pipe_picture = table.deepcopy(em_pipe_picture)
            em_pipe_picture.shift[1] = em_pipe_picture.shift[1] + pipe_connection.position[1]
            em_pipe_picture.shift[2] = em_pipe_picture.shift[2] + pipe_connection.position[2]
            if pipe_connection.position[1] == 2.5 then em_pipe_picture.shift[1] = em_pipe_picture.shift[1] + 1 end
            if pipe_connection.position[1] == -2.5 then em_pipe_picture.shift[1] = em_pipe_picture.shift[1] - 1 end
            if pipe_connection.position[2] == 2.5 then em_pipe_picture.shift[2] = em_pipe_picture.shift[2] + 1 end
            if pipe_connection.position[2] == -2.5 then em_pipe_picture.shift[2] = em_pipe_picture.shift[2] - 1 end
            table.insert(data.raw["fusion-reactor"]["maraxsis-salt-reactor"].graphics_set.structure.layers, 1, em_pipe_picture)
        end
    end
end

data.raw["fusion-reactor"]["maraxsis-salt-reactor"].input_fluid_box.volume = 1000
data.raw["fusion-reactor"]["maraxsis-salt-reactor"].input_fluid_box.filter = "water"
data.raw["fusion-reactor"]["maraxsis-salt-reactor"].input_fluid_box.pipe_covers = pipecoverspictures()
data.raw["fusion-reactor"]["maraxsis-salt-reactor"].output_fluid_box.volume = 1000
data.raw["fusion-reactor"]["maraxsis-salt-reactor"].output_fluid_box.filter = "maraxsis-supercritical-steam"
data.raw["fusion-reactor"]["maraxsis-salt-reactor"].output_fluid_box.pipe_covers = pipecoverspictures()
for _, pipe_connection in pairs(data.raw["fusion-reactor"]["maraxsis-salt-reactor"].output_fluid_box.pipe_connections) do
    pipe_connection.connection_category = "maraxsis-salt-reactor"
end

data:extend {{
    type = "recipe-category",
    name = "maraxsis-salt-reactor"
}}

data:extend {{
    type = "fuel-category",
    name = "maraxsis-salt-reactor"
}}

data:extend {{
    type = "fluid",
    name = "molten-salt",
    icon = "__maraxsis__/graphics/icons/molten-salt.png",
    icon_size = 64,
    default_temperature = 800,
    max_temperature = 1500,
    heat_capacity = "10kJ",
    base_flow_rate = data.raw.fluid.steam.base_flow_rate,
    base_color = {1, 1, 0.5},
    flow_color = {1, 1, 0.75},
    gas_temperature = 1465,
    auto_barrel = false,
}}

data:extend {{
    type = "recipe",
    name = "molten-salt",
    enabled = false,
    energy_required = 32,
    ingredients = {
        {type = "item",  name = "salt",    amount = 50},
    },
    results = {
        {type = "fluid", name = "molten-salt", amount = 50},
    },
    allow_productivity = true,
    category = "metallurgy",
    auto_recycle = false,
}}


data:extend {{
    type = "item",
    name = "msr-fuel-cell",
    icon = "__maraxsis__/graphics/icons/msr-fuel-cell.png",
    inventory_move_sound = item_sounds.reactor_inventory_move,
    pick_sound = item_sounds.reactor_inventory_pickup,
    drop_sound = item_sounds.reactor_inventory_move,
    fuel_value = "40GJ",
    fuel_category = "maraxsis-salt-reactor",
    stack_size = 50,
    default_import_location = "maraxsis",
    weight = 20*kg
}}

data:extend {{
    type = "recipe",
    name = "msr-fuel-cell",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "item",  name = "maraxsis-glass-panes",    amount = 10},
        {type = "item",  name = "uranium-238",          amount = 1},
        {type = "fluid", name = "molten-salt", amount = 500},
    },
    results = {
        {type = "item", name = "msr-fuel-cell", amount = 1},
    },
    category = "crafting-with-fluid",
    allow_productivity = true,
    auto_recycle = false,
}}

data:extend {{
    type = "recipe",
    name = "maraxsis-salt-reactor",
    enabled = false,
    energy_required = 10,
    ingredients = {
        {type = "item",  name = "maraxsis-glass-panes",    amount = 200},
        {type = "item",  name = "tungsten-plate",          amount = 200},
        {type = "item",  name = "processing-unit",         amount = 100},
        {type = "item", name = "nuclear-reactor", amount = 1},
    },
    results = {
        {type = "item", name = "maraxsis-salt-reactor", amount = 1},
    },
    category = "maraxsis-hydro-plant",
    surface_conditions = maraxsis.surface_conditions(),
}}

data:extend {{
    type = "item",
    name = "maraxsis-salt-reactor",
    icon = "__maraxsis__/graphics/icons/salt-reactor.png",
    icon_size = 64,
    place_result = "maraxsis-salt-reactor",
    stack_size = 1,
}}

data:extend {{
    type = "technology",
    name = "maraxsis-salt-reactor",
    icon = "__maraxsis__/graphics/technology/salt-reactor.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "maraxsis-salt-reactor"
        },
        {
            type = "unlock-recipe",
            recipe = "maraxsis-oversized-steam-turbine"
        },
        {
            type = "unlock-recipe",
            recipe = "msr-fuel-cell"
        },
        {
            type = "unlock-recipe",
            recipe = "molten-salt"
        },
    },
    prerequisites = {"nuclear-power", "maraxsis-hydro-plant"},
    research_trigger = {
        type = "craft-item",
        item = "salt",
        count = 100
    },
    order = "d-e",
}}
