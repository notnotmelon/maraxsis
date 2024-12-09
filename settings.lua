data:extend {{
    type = "double-setting",
    name = "maraxsis-water-opacity",
    setting_type = "startup",
    default_value = 255,
    minimum_value = 0,
    maximum_value = 255,
    order = "a"
}}

if mods["no-quality"] then return end

data:extend {{
    type = "bool-setting",
    name = "maraxsis-easy-mode",
    setting_type = "startup",
    default_value = false,
    order = "b"
}}
