local function get_submarine_list()
    return maraxsis_constants.SUBMARINES
end

remote.add_interface("maraxsis", {
    get_submarine_list = get_submarine_list,
})
