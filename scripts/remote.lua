local function get_submarine_list()
    return maraxsis_constants.SUBMARINES
end

remote.add_interface("maraxsis", {
    get_submarine_list = get_submarine_list,
    set_light_radius_modifier = function(source_key, modifier) maraxsis.set_modifier(source_key, "light_radius", modifier) end,
    set_swim_speed_modifier =   function(source_key, modifier) maraxsis.set_modifier(source_key, "swim_speed", modifier) end,
    set_hypno_resistance_modifier =   function(source_key, modifier) maraxsis.set_modifier(source_key, "hypno_resistance", modifier) end,
})
