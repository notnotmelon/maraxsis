require "prototypes.collision-mask"
require "prototypes.swimming"

data.raw["technology"]["maraxsis-promethium-productivity"].unit.ingredients = table.deepcopy(data.raw["technology"]["research-productivity"].unit.ingredients)

data.raw.radar["maraxsis-sonar"].next_upgrade = nil -- fix crash with 5dim