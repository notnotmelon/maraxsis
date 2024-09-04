local letters = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l'
}

local function make_subgroup(subgroup_name, subgroup_order, group, members)
    data:extend {{
        type = 'item-subgroup',
        name = subgroup_name,
        group = group,
        order = subgroup_order,
    }}

    for i, prototype in pairs(members) do
        local order_letter = letters[i] or error('not enough letters')
        local order = order_letter .. '[' .. prototype.name .. ']'
        prototype.order = order
        prototype.subgroup = subgroup_name
    end
end

make_subgroup('h2o-maraxsis-intermediants', 'ge', 'intermediate-products', {
    data.raw.recipe['h2o-saline-electrolysis'],
    data.raw.item['limestone'],
    data.raw.item['sand'],
    data.raw.item['h2o-glass-panes'],
    data.raw.item['h2o-saturated-salt-filter'],
    data.raw.item['h2o-salt-filter'],
    data.raw.capsule['h2o-tropical-fish'],
    data.raw.item['h2o-microplastics'],
    data.raw.item['h2o-wyrm-specimen'],
    data.raw.item['h2o-wyrm-confinement-cell'],
})

make_subgroup('h2o-quarkals', 'gf', 'intermediate-products', {
    data.raw.item['h2o-up-coral'],
    data.raw.item['h2o-down-coral'],
    data.raw.item['h2o-top-coral'],
    data.raw.item['h2o-bottom-coral'],
    data.raw.item['h2o-strange-coral'],
    data.raw.item['h2o-charm-coral'],
    data.raw.item['h2o-heart-of-the-sea'],
})

make_subgroup('h2o-machines', 'ee', 'production', {
    data.raw['simple-entity']['h2o-water-shader-32-1-1'],
    data.raw.item['h2o-hydro-plant'],
    data.raw.item['h2o-sonar'],
    data.raw.lamp['h2o-sonar-light-1'],
    data.raw.lamp['h2o-sonar-light-2'],
    data.raw.item['h2o-quantum-computer'],
    data.raw.item['h2o-pressure-dome'],
    data.raw.lamp['h2o-pressure-dome-lamp'],
    data.raw['constant-combinator']['h2o-pressure-dome-combinator'],
})

make_subgroup('h2o-submarine', 'fe', 'logistics', {
    data.raw.item['h2o-diesel-submarine'],
    data.raw.item['h2o-nuclear-submarine'],
    data.raw.item['h2o-waterway'],
})

data.raw.fluid['saline-water'].order = 'f[maraxsis-fluids]-a[saline-water]'
data.raw.fluid['brackish-water'].order = 'f[maraxsis-fluids]-b[brackish-water]'
data.raw.fluid['oxygen'].order = 'f[maraxsis-fluids]-c[oxygen]'
data.raw.fluid['hydrogen'].order = 'f[maraxsis-fluids]-d[hydrogen]'
data.raw.fluid['chlorine'].order = 'f[maraxsis-fluids]-e[chlorine]'
data.raw.fluid['h2o-atmosphere'].order = 'f[maraxsis-fluids]-f[atmosphere]'

data.raw.capsule['h2o-big-cliff-explosives'].subgroup = data.raw.capsule['cliff-explosives'].subgroup
data.raw.capsule['h2o-big-cliff-explosives'].order = 'e[big-cliff-explosives]'
