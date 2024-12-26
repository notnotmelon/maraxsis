local electricity = data.raw.item["maraxsis-electricity"]

electricity.spoil_ticks = (0.5 * 60) * 1.35 + 10 -- items start to spoil when the recipe starts.
electricity.spoil_to_trigger_result = {
    trigger = {
        type = "direct",
        action_delivery = {
            type = "instant",
            source_effects = {
                type = "create-entity",
                entity_name = "maraxsis-electricity",
                affects_target = true,
                show_in_tooltip = false,
                as_enemy = false,
                find_non_colliding_position = false,
                trigger_created_entity = true,
                check_buildability = false,
            }
        }
    },
    items_per_trigger = 1,
}
