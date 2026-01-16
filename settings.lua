data:extend {{
    type = "double-setting",
    name = "maraxsis-water-opacity",
    setting_type = "startup",
    default_value = 255,
    minimum_value = 0,
    maximum_value = 255,
    order = "b"
}}

data:extend {{
    type = "bool-setting",
    name = "maraxsis-add-hydraulic-science",
    setting_type = "startup",
    default_value = true,
    order = "a"
}}

data:extend {{
    type = "bool-setting",
    name = "maraxsis-flare-stack-compat",
    setting_type = "startup",
    default_value = true,
    hidden = not mods["Flare Stack"],
    order = "a"
}}
