local letters = {
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l"
}

local function make_subgroup(subgroup_name, subgroup_order, group, members)
    data:extend {{
        type = "item-subgroup",
        name = subgroup_name,
        group = group,
        order = subgroup_order,
    }}

    for i, prototype in pairs(members) do
        local order_letter = letters[i] or error("not enough letters")
        local order = order_letter .. "[" .. prototype.name .. "]"
        prototype.order = order
        prototype.subgroup = subgroup_name
    end
end

make_subgroup("maraxsis-intermediants", "ge", "intermediate-products", {
    data.raw.recipe["maraxsis-saline-electrolysis"],
    data.raw.item["limestone"],
    data.raw.item["sand"],
    data.raw.item["maraxsis-glass-panes"],
    data.raw.item["maraxsis-saturated-salt-filter"],
    data.raw.recipe["maraxsis-saturated-salt-filter"],
    data.raw.item["maraxsis-salt-filter"],
    data.raw.recipe["maraxsis-salt-filter"],
    data.raw.capsule["maraxsis-tropical-fish"],
    data.raw.item["maraxsis-microplastics"],
    data.raw.item["maraxsis-wyrm-specimen"],
    data.raw.item["maraxsis-wyrm-confinement-cell"],
})

make_subgroup("maraxsis-machines", "ee", "production", {
    data.raw["item-with-entity-data"]["maraxsis-diesel-submarine"],
    data.raw["item-with-entity-data"]["maraxsis-nuclear-submarine"],
    data.raw["simple-entity"]["maraxsis-water-shader-32-1-1"],
    data.raw.item["maraxsis-hydro-plant"],
    data.raw.item["maraxsis-sonar"],
    data.raw.lamp["maraxsis-sonar-light-1"],
    data.raw.lamp["maraxsis-sonar-light-2"],
    data.raw.item["maraxsis-pressure-dome"],
    data.raw.lamp["maraxsis-pressure-dome-lamp"],
    data.raw["constant-combinator"]["maraxsis-pressure-dome-combinator"],
})

data.raw.fluid["saline-water"].order = "f[maraxsis-fluids]-a[saline-water]"
data.raw.fluid["brackish-water"].order = "f[maraxsis-fluids]-b[brackish-water]"
data.raw.fluid["oxygen"].order = "f[maraxsis-fluids]-c[oxygen]"
data.raw.fluid["hydrogen"].order = "f[maraxsis-fluids]-d[hydrogen]"
data.raw.fluid["maraxsis-atmosphere"].order = "f[maraxsis-fluids]-f[atmosphere]"

data.raw.capsule["maraxsis-big-cliff-explosives"].subgroup = data.raw.capsule["cliff-explosives"].subgroup
data.raw.capsule["maraxsis-big-cliff-explosives"].order = "e[big-cliff-explosives]"
