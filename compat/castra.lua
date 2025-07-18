local landing_pad_capacity = data.raw.technology["cargo-landing-pad-capacity"]
if not landing_pad_capacity then return end

landing_pad_capacity.unit.ingredients = table.dedupe(landing_pad_capacity.unit.ingredients)