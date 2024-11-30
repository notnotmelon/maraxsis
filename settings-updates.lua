local function lock_bool_setting(name, value)
    data.raw["bool-setting"][name].hidden = true
    data.raw["bool-setting"][name].forced_value = value
    data.raw["bool-setting"][name].default_value = value
end

data.raw["bool-setting"]["sp-enable-spiderling"].default_value = false
lock_bool_setting("sp-enable-dock", true)
lock_bool_setting("sp-remove-military-requirement", false)
lock_bool_setting("spidertron-enhancements-increase-size", false)
