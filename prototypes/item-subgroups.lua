local letters = {
    "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"
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
    data.raw.item["maraxsis-coral"],
    data.raw.item["limestone"],
    data.raw.item["sand"],
    data.raw.item["maraxsis-glass-panes"],
    data.raw.item["maraxsis-fish-food"],
    data.raw.capsule["maraxsis-tropical-fish"],
    data.raw.item["maraxsis-microplastics"],
    data.raw.recipe["maraxsis-carbon"],
    data.raw.recipe["maraxsis-geothermal-sulfur"],
    data.raw.item["maraxsis-wyrm-specimen"],
    data.raw.item["maraxsis-wyrm-confinement-cell"],
    data.raw.item["maraxsis-super-sealant-substance"],
    data.raw.recipe["maraxsis-atmosphere"],
    data.raw.recipe["maraxsis-liquid-atmosphere-decompression"],
    data.raw.recipe["maraxsis-liquid-atmosphere"],
})

make_subgroup("salt", "gf", "intermediate-products", {
    data.raw.item["salt"],
    data.raw.recipe["salt"],
    data.raw.recipe["maraxsis-brackish-water"],
    data.raw.recipe["maraxsis-water"],
    data.raw.item["maraxsis-salt-filter"],
    data.raw.recipe["maraxsis-salt-filter"],
    data.raw.item["maraxsis-saturated-salt-filter"],
    data.raw.recipe["maraxsis-saturated-salt-filter"],
    data.raw.recipe["maraxsis-hydrolox-rocket-fuel"],
    data.raw.item["msr-fuel-cell"],
    data.raw.recipe["msr-fuel-cell"],
})

make_subgroup("maraxsis-machines", "fh", "logistics", {
    data.raw.item["maraxsis-pressure-dome"],
    data.raw.lamp["maraxsis-pressure-dome-lamp"],
    data.raw["constant-combinator"]["maraxsis-pressure-dome-combinator"],
    data.raw.item["maraxsis-empty-research-vessel"],
    data.raw["simple-entity"]["maraxsis-water-shader-32-1-1"],
})

local function order_subgroup(prototype, name, order, subgroup)
    local prototype = data.raw[prototype][name]
    if not prototype then error("no such prototype: " .. type .. "." .. name) end
    prototype.order = order
    prototype.subgroup = subgroup
end

order_subgroup("item-with-entity-data", "maraxsis-diesel-submarine", "b[personal-transport]-c[spidertron]-b[diesel-submarine]", "transport")
order_subgroup("item-with-entity-data", "maraxsis-nuclear-submarine", "b[personal-transport]-c[spidertron]-c[nuclear-submarine]", "transport")
order_subgroup("item", "sp-spidertron-dock", "b[personal-transport]-c[spidertron]-d[spidertron-dock]", "transport")
order_subgroup("item", "maraxsis-hydro-plant", "hi[hydro-plant]", "production-machine")
order_subgroup("item", "maraxsis-fishing-tower", data.raw.item["agricultural-tower"].order .. "-ag[fishing-tower]", data.raw.item["agricultural-tower"].subgroup)
order_subgroup("item", "maraxsis-sonar", "d[radar]-b[sonar]-a[sonar]", data.raw.item.radar.subgroup)
order_subgroup("lamp", "maraxsis-sonar-light-1", "d[radar]-b[sonar]-b[sonar-light-1]", data.raw.item.radar.subgroup)
order_subgroup("lamp", "maraxsis-sonar-light-2", "d[radar]-b[sonar]-c[sonar-light-2]", data.raw.item.radar.subgroup)
order_subgroup("item", "maraxsis-salt-reactor", "h[salt-reactor]-a[reactor]", "energy")
order_subgroup("item", "maraxsis-oversized-steam-turbine", "h[salt-reactor]-b[oversized-steam-turbine]", "energy")
order_subgroup("recipe", "molten-salt", "a[melting]-d[molten-salt]", "vulcanus-processes")

order_subgroup("fluid", "maraxsis-saline-water", "f[maraxsis-fluids]-a[saline-water]", "fluid")
order_subgroup("fluid", "maraxsis-brackish-water", "f[maraxsis-fluids]-b[brackish-water]", "fluid")
order_subgroup("fluid", "oxygen", "f[maraxsis-fluids]-c[oxygen]", "fluid")
order_subgroup("fluid", "hydrogen", "f[maraxsis-fluids]-d[hydrogen]", "fluid")
order_subgroup("fluid", "maraxsis-atmosphere", "f[maraxsis-fluids]-f[atmosphere]", "fluid")
order_subgroup("fluid", "maraxsis-liquid-atmosphere", "f[maraxsis-fluids]-f[liquid-atmosphere]", "fluid")
order_subgroup("fluid", "molten-salt", "b[new-fluid]-b[vulcanus]-c[molten-salt]", "fluid")
order_subgroup("fluid", "maraxsis-supercritical-steam", "f[maraxsis-fluids]-h[maraxsis-supercritical-steam]", "fluid")
order_subgroup("capsule", "maraxsis-big-cliff-explosives", "e[big-cliff-explosives]", data.raw.capsule["cliff-explosives"].subgroup)
order_subgroup("ammo", "maraxsis-fat-man", "e[maraxsis-fat-man]", data.raw.ammo["artillery-shell"].subgroup)
order_subgroup("resource", "maraxsis-coral", "x[maraxsis-coral]", "mineable-fluids")
order_subgroup("item", "maraxsis-conduit", data.raw.item.beacon.order .. "a[maraxsis-conduit]", data.raw.item.beacon.subgroup)

require "compat.schall-transport-group"
