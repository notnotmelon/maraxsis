--trench indestructible wall
local tint = {r = 0.2, g = 0.2, b = 0.3}
for rock, type in pairs {
    ['rock-huge'] = 'simple-entity',
} do
    local entity = table.deepcopy(data.raw[type][rock])
    entity.name = entity.name .. '-trench-wall'
    entity.localised_name = {'entity-name.trench-wall'}
    entity.minable = nil
    for _, picture in pairs(entity.pictures) do
        picture.tint = tint
        picture.scale = 1.5
        picture.hr_version.tint = tint
        picture.hr_version.scale = 1.5
    end
    entity.selectable_in_game = false
    entity.map_color = {0, 0, 0}
    entity.script_autoplace = true
    entity.render_layer = 'higher-object-under'
    data:extend {entity}
end
