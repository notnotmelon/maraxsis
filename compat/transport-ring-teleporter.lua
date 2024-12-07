-- https://github.com/notnotmelon/maraxsis/issues/41
if not mods["transport-ring-teleporter"] then return end

for _, name in pairs {
    "ring-teleporter",
    "ring-teleporter-2",
    "ring-teleporter-placer",
    "ring-teleporter-back",
    "ring-teleporter-barrier",
    "ring-teleporter-sprite",
} do
    local ring_teleporter = data.raw["accumulator"][name] or data.raw["simple-entity-with-force"][name]
    if ring_teleporter then
        ring_teleporter.surface_conditions = ring_teleporter.surface_conditions or {}
        table.insert(ring_teleporter.surface_conditions, {
            property = "pressure",
            max = 50000,
            min = 0
        })
    end
end
