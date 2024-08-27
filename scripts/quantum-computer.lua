local UPDATE_RATE = 3 -- ticks
local UPDATE_BUCKETS = 20 -- 20 buckets * 3 ticks per bucket update = 1 second crafting time

h2o.on_event('on_init', function()
    global.quantum_computers = global.quantum_computers or {}

    if not global.quantum_computers_by_tick then
        global.quantum_computers_by_tick = {}
        for i = 1, UPDATE_BUCKETS do
            global.quantum_computers_by_tick[i] = {}
        end
    end
end)

local function generate_new_secret()
    return math.random(1, 64)
end

local function get_smallest_bucket_index()
    local smallest_bucket_index = 1
    local smallest_bucket_size = math.huge
    for i, bucket in pairs(global.quantum_computers_by_tick) do
        if #bucket < smallest_bucket_size then
            smallest_bucket_size = #bucket
            smallest_bucket_index = i
        end
    end
    return smallest_bucket_index
end    

h2o.on_event('on_built', function(event)
    local entity = event.entity or event.created_entity
    if not entity.valid then return end
    if entity.name ~= 'h2o-quantum-computer' then return end

    entity.active = false
    entity.operable = false
    
    local quantum_computer_data = {
        entity = entity,
        unit_number = entity.unit_number,
        previous_experiment = 0,
        secret = generate_new_secret()
    }

    global.quantum_computers[entity.unit_number] = quantum_computer_data
    local bucket_index = get_smallest_bucket_index()
    table.insert(global.quantum_computers_by_tick[bucket_index], quantum_computer_data)
end)

--- invariant: quantum_computer_data.entity.valid
local function update_quantum_computer(quantum_computer_data)
    game.print('Updating quantum computer with secret ' .. quantum_computer_data.secret)
end

h2o.on_nth_tick(UPDATE_RATE, function()
    local bucket_index = math.floor(game.tick / UPDATE_RATE) % UPDATE_BUCKETS + 1
    local bucket = global.quantum_computers_by_tick[bucket_index]
    
    for i, quantum_computer_data in pairs(bucket) do
        local entity = quantum_computer_data.entity
        if not entity.valid then
            global.quantum_computers[quantum_computer_data.unit_number] = nil
            table.remove(bucket, i)
            break
        end
        update_quantum_computer(quantum_computer_data)
    end
end)