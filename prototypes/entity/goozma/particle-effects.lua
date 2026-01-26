local space_age_sounds = require "__space-age__.prototypes.entity.sounds"
local smoke_animations = require "__base__.prototypes.entity.smoke-animations"

local hypno_cloud_steps = 30
local hypno_cloud_interval = 10
local hypno_cloud_duration = 60 * 5
local hypno_cloud_repeats = 2

local function make_hypno_cloud_effect(base_name)
    local effects = {}

    table.insert(effects,
        {
            type = "nested-result",
            action =
            {
                type = "direct",
                action_delivery =
                {
                    type = "instant",
                    source_effects =
                    {
                        type = "create-entity",
                        entity_name = base_name .. "-expanding-hypno-cloud-1",
                    }
                }
            }
        })

    for i = 2, hypno_cloud_steps do
        table.insert(effects,
            {
                type = "nested-result",
                action =
                {
                    type = "direct",
                    action_delivery =
                    {
                        type = "delayed",
                        delayed_trigger = base_name .. "-expanding-hypno-cloud-delay-" .. i
                    }
                }
            })
    end
    table.insert(effects,
        {
            type = "nested-result",
            action =
            {
                type = "direct",
                action_delivery =
                {
                    type = "delayed",
                    delayed_trigger = base_name .. "-hypno-cloud-delay"
                }
            }
        })

    return {
        time_cooldown = hypno_cloud_interval * hypno_cloud_steps + (1 + hypno_cloud_repeats) * hypno_cloud_duration,
        effect = effects
    }
end

local function make_hypno_cloud_trigger_effects(base_name, radius, damage_multiplier)
    return {
        type = "direct",
        action_delivery =
        {
            type = "instant",
            target_effects =
            {
                {
                    type = "nested-result",
                    action =
                    {
                        type = "area",
                        ignore_collision_condition = true,
                        radius = radius,
                        target_enemies = true,
                        action_delivery =
                        {
                            type = "instant",
                            target_effects =
                            {
                                {
                                    type = "create-sticker",
                                    sticker = "demolisher-ash-sticker"
                                }
                            }
                        }
                    }
                },
                { -- combat robots can't take stickers
                    type = "nested-result",
                    action =
                    {
                        type = "area",
                        trigger_target_mask = {"flying-robot"},
                        ignore_collision_condition = true,
                        target_enemies = true,
                        radius = radius,
                        action_delivery =
                        {
                            type = "instant",
                            target_effects =
                            {
                                {
                                    type = "damage",
                                    damage = {amount = 1 * damage_multiplier, type = "physical"}
                                },
                                {
                                    type = "damage",
                                    damage = {amount = 2 * damage_multiplier, type = "fire"}
                                }
                            }
                        }
                    }
                }
            }
        }
    }
end

local function make_particle_effects(base_name, order, scale, damage_multiplier)
    local main_cloud_scale = 1 + 0.5 * scale
    local expanding_cloud_steps = hypno_cloud_steps
    local hypno_cloud = {
        type = "smoke-with-trigger",
        name = base_name .. "-hypno-cloud",
        localised_name = {"entity-name.demolisher-hypno-cloud", {"entity-name." .. base_name}},
        order = order,
        flags = {"not-on-map"},
        hidden = true,
        show_when_smoke_off = true,
        particle_count = 1,
        particle_spread = {1, 1},
        particle_distance_scale_factor = 0.5,
        particle_scale_factor = {1, 0.707},
        wave_speed = {1 / 80, 1 / 60},
        wave_distance = {0.3, 0.2},
        spread_duration_variation = 20,
        particle_duration_variation = 60 * 3,
        render_layer = "object",

        affected_by_wind = false,
        cyclic = true,
        duration = hypno_cloud_duration, -- linger for up to 5s
        fade_away_duration = 60,
        spread_duration = 20,
        color = {0.239, 0.239, 0.239, 0.50},
        attach_to_target = true,
        fade_when_attachment_is_destroyed = true,
        animation = {
            width = 152,
            height = 120,
            line_length = 5,
            frame_count = 60,
            shift = {-0.53125, -0.4375},
            priority = "high",
            animation_speed = 0.25,
            filename = "__base__/graphics/entity/smoke/smoke.png",
            flags = {"smoke"}
        },
        action = {
            {
                type = "cluster",
                cluster_count = math.ceil(4 * main_cloud_scale),
                distance = 5 * main_cloud_scale,
                distance_deviation = 5 * main_cloud_scale,
                action_delivery =
                {
                    type = "instant",
                    target_effects =
                    {
                        {
                            type = "create-smoke",
                            show_in_tooltip = false,
                            entity_name = "demolisher-ash-cloud-visual-dummy",
                            initial_height = 0
                        },
                    }
                }
            },
            {
                type = "cluster",
                cluster_count = math.ceil(4 * main_cloud_scale),
                distance = 11 * main_cloud_scale,
                distance_deviation = 3 * main_cloud_scale,
                action_delivery =
                {
                    type = "instant",
                    target_effects =
                    {
                        {
                            type = "create-smoke",
                            show_in_tooltip = false,
                            entity_name = "demolisher-ash-cloud-visual-dummy",
                            initial_height = 0
                        }
                    }
                }
            },
            {
                type = "cluster",
                cluster_count = math.ceil(6 * main_cloud_scale),
                distance = 17 * main_cloud_scale,
                distance_deviation = 3 * main_cloud_scale,
                action_delivery =
                {
                    type = "instant",
                    target_effects =
                    {
                        {
                            type = "create-smoke",
                            show_in_tooltip = false,
                            entity_name = "demolisher-ash-cloud-visual-dummy",
                            initial_height = 0
                        }
                    }
                }
            },
            {
                type = "cluster",
                cluster_count = math.ceil(8 * main_cloud_scale),
                distance = 23 * main_cloud_scale,
                distance_deviation = 3 * main_cloud_scale,
                action_delivery =
                {
                    type = "instant",
                    target_effects =
                    {
                        {
                            type = "create-smoke",
                            show_in_tooltip = false,
                            entity_name = "demolisher-ash-cloud-visual-dummy",
                            initial_height = 0
                        }
                    }
                }
            },
            {
                type = "cluster",
                cluster_count = math.ceil(12 * main_cloud_scale),
                distance = 29 * main_cloud_scale,
                distance_deviation = 3 * main_cloud_scale,
                action_delivery =
                {
                    type = "instant",
                    target_effects =
                    {
                        {
                            type = "create-smoke",
                            show_in_tooltip = false,
                            entity_name = "demolisher-ash-cloud-visual-dummy",
                            initial_height = 0
                        }
                    }
                }
            },
            {
                -- thicker outer ring
                type = "cluster",
                cluster_count = math.ceil(3 * 32 * main_cloud_scale),
                distance = 32 * main_cloud_scale,
                distance_deviation = 0.5,
                action_delivery =
                {
                    type = "instant",
                    target_effects =
                    {
                        {
                            type = "create-trivial-smoke",
                            smoke_name = "goozma-hypno-cloud-boundary",
                            initial_height = 0,
                            offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}},
                            starting_frame = 30,
                            starting_frame_deviation = 30,
                            speed_from_center = 0.1,
                            speed_from_center_deviation = 0.1
                        }
                    }
                }
            },
            make_hypno_cloud_trigger_effects(base_name, 32 * main_cloud_scale, damage_multiplier)
        },
        action_cooldown = 10
    }
    local function make_expanding_hypno_cloud(i, cloud_scale)
        local max_radius = 32 * cloud_scale
        local band_thickness = 4
        local bands = math.max(1, math.floor(max_radius / band_thickness) - 1)
        local actions = {}
        for j = 1, bands do
            local radius = max_radius - (j - 0.5) * band_thickness
            local particles = math.floor(radius / 4)
            if particles > 2 then
                local cluster = {
                    type = "cluster",
                    cluster_count = particles,
                    distance = radius,
                    distance_deviation = band_thickness * 0.75,
                    action_delivery =
                    {
                        type = "instant",
                        target_effects =
                        {
                            {
                                type = "create-smoke",
                                show_in_tooltip = false,
                                entity_name = "demolisher-ash-cloud-visual-dummy",
                                initial_height = 0
                            }
                        }
                    }
                }
                table.insert(actions, cluster)
            end
        end
        -- outer band, no variation
        local outer_cluster = {
            -- thicker outer ring
            type = "cluster",
            cluster_count = math.max(2, 3 * math.ceil(max_radius)),
            distance = max_radius,
            distance_deviation = 0.02,
            action_delivery =
            {
                type = "instant",
                target_effects =
                {
                    {
                        type = "create-trivial-smoke",
                        smoke_name = "goozma-hypno-cloud-expanding-boundary",
                        initial_height = 0,
                        -- repeat_count = 10,
                        offset_deviation = {{-0.025, -0.025}, {0.025, 0.025}},
                        starting_frame = 30,
                        starting_frame_deviation = 30,
                        speed_from_center = 0.1,
                        speed_from_center_deviation = 0.1
                    }
                }
            }
        }
        table.insert(actions, outer_cluster)
        -- add the significant actions
        table.insert(actions, make_hypno_cloud_trigger_effects(base_name, 32 * cloud_scale, damage_multiplier))
        local expanding_hypno_cloud =
        {
            type = "smoke-with-trigger",
            name = base_name .. "-expanding-hypno-cloud-" .. i,
            localised_name = {"entity-name.demolisher-expanding-hypno-cloud", {"entity-name." .. base_name}, "" .. i},
            order = order .. "-" .. string.format("%02d", i),
            flags = {"not-on-map"},
            hidden = true,
            show_when_smoke_off = true,
            particle_count = 1,
            particle_spread = {1, 1},
            particle_distance_scale_factor = 0.5,
            particle_scale_factor = {1, 0.707},
            wave_speed = {1 / 80, 1 / 60},
            wave_distance = {0.3, 0.2},
            spread_duration_variation = 0,
            particle_duration_variation = hypno_cloud_interval,
            render_layer = "object",

            affected_by_wind = false,
            cyclic = false,
            duration = hypno_cloud_interval * 2,
            fade_away_duration = hypno_cloud_interval,
            spread_duration = hypno_cloud_interval,
            color = {0.239, 0.239, 0.239, 0.50},
            attach_to_target = true,
            fade_when_attachment_is_destroyed = true,
            animation = {
                width = 152,
                height = 120,
                line_length = 5,
                frame_count = 60,
                shift = {-0.53125, -0.4375},
                priority = "high",
                animation_speed = 0.25,
                filename = "__base__/graphics/entity/smoke/smoke.png",
                flags = {"smoke"}
            },
            action = actions,
            action_cooldown = hypno_cloud_interval
        }
        return expanding_hypno_cloud
    end
    local function make_expanding_hypno_clouds()
        local expanding_hypno_clouds = {}
        local start_expansion = 2
        for i = 1, expanding_cloud_steps do
            local cloud_scale = main_cloud_scale * (i + start_expansion) / (expanding_cloud_steps + start_expansion)
            table.insert(expanding_hypno_clouds, make_expanding_hypno_cloud(i, cloud_scale))
        end

        table.insert(expanding_hypno_clouds[1].action, {
            type = "direct",
            action_delivery =
            {
                type = "instant",
                target_effects =
                {
                    {
                        type = "play-sound",
                        sound = space_age_sounds.ash_cloud_explosion,
                    }
                }
            }
        })

        return expanding_hypno_clouds
    end
    local expanding_hypno_clouds = make_expanding_hypno_clouds()

    local expanding_hypno_cloud_delays = {}
    local ticks_between_expanding_hypno_cloud_steps = hypno_cloud_interval
    for i = 2, expanding_cloud_steps do
        table.insert(expanding_hypno_cloud_delays, {
            type = "delayed-active-trigger",
            name = base_name .. "-expanding-hypno-cloud-delay-" .. i,
            delay = ticks_between_expanding_hypno_cloud_steps * (i - 1),
            cancel_when_source_is_destroyed = true,
            action =
            {
                {
                    type = "direct",
                    action_delivery =
                    {
                        type = "instant",
                        source_effects =
                        {
                            {
                                type = "create-entity",
                                entity_name = expanding_hypno_clouds[i].name
                            }
                        }
                    }
                }
            }
        })
    end

    table.insert(expanding_hypno_cloud_delays, {
        type = "delayed-active-trigger",
        name = base_name .. "-hypno-cloud-delay",
        delay = ticks_between_expanding_hypno_cloud_steps * expanding_cloud_steps,
        repeat_count = hypno_cloud_repeats,
        repeat_delay = hypno_cloud_duration,
        cancel_when_source_is_destroyed = true,
        action =
        {
            {
                type = "direct",
                action_delivery =
                {
                    type = "instant",
                    source_effects =
                    {
                        {
                            type = "create-entity",
                            entity_name = hypno_cloud.name
                        }
                    }
                }
            }
        }
    })

    local prototypes = {hypno_cloud}
    for _, prototype in pairs(expanding_hypno_clouds) do
        table.insert(prototypes, prototype)
    end
    for _, prototype in pairs(expanding_hypno_cloud_delays) do
        table.insert(prototypes, prototype)
    end
    return prototypes
end

local trivial_smoke = smoke_animations.trivial_smoke
data:extend {
    trivial_smoke {
        name = "goozma-hypno-cloud-boundary",
        color = {255, 105, 180, 0.1},
        affected_by_wind = false,
        render_layer = "under-elevated",
        start_scale = 1,
        end_scale = 10,
        spread_duration = 30,
        movement_slow_down_factor = 0.25,
        duration = 60,
        fade_in_duration = 10,
        fade_away_duration = 50,
        draw_as_glow = true,
        show_when_smoke_off = true
    },
    trivial_smoke {
        name = "goozma-hypno-cloud-expanding-boundary",
        color = {255, 105, 180, 0.1},
        render_layer = "under-elevated",
        start_scale = 0.3,
        end_scale = 2,
        spread_duration = 20,
        affected_by_wind = false,
        movement_slow_down_factor = 0.01,
        duration = 40,
        fade_in_duration = 10,
        fade_away_duration = 30,
        draw_as_glow = true,
        show_when_smoke_off = true
    },
}

data.raw["trivial-smoke"]["goozma-hypno-cloud-boundary"].animation.draw_as_glow = true
data.raw["trivial-smoke"]["goozma-hypno-cloud-expanding-boundary"].animation.draw_as_glow = true

return {
    make_hypno_cloud_effect = make_hypno_cloud_effect,
    make_particle_effects = make_particle_effects
}
