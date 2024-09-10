local events = {}

---Drop-in replacement for script.on_event however it supports multiple handlers per event. You can also use 'on_built' 'on_destroyed' and 'on_init' as shortcuts for multiple events.
---@param event defines.events|defines.events[]|string
---@param f function
h2o.on_event = function(event, f)
	if event == 'on_built' then
		h2o.on_event({defines.events.on_built_entity,
			defines.events.on_robot_built_entity,
			defines.events.script_raised_built,
			defines.events.script_raised_revive
		}, f)
		return
	end
	if event == 'on_destroyed' then
		h2o.on_event({
			defines.events.on_player_mined_entity,
			defines.events.on_robot_mined_entity,
			defines.events.on_entity_died,
			defines.events.script_raised_destroy
		}, f)
		return
	end
	for _, event in pairs(type(event) == 'table' and event or {event}) do
		event = tostring(event)
		events[event] = events[event] or {}
		table.insert(events[event], f)
	end
end

h2o.on_nth_tick = function(event, f)
	events[event] = events[event] or {}
	table.insert(events[event], f)
end

local function one_function_from_many(functions)
	local l = #functions
	if l == 1 then return functions[1] end

	return function(arg)
		for i = 1, l do
			functions[i](arg)
		end
	end
end

local powers_of_two = {}
for i = 0, 20 do
	powers_of_two[i] = 2 ^ i
end

local finalized = false
h2o.finalize_events = function()
	if finalized then error('Events already finalized') end
	local i = 0
	for event, functions in pairs(events) do
		local f = one_function_from_many(functions)
		if type(event) == 'number' then
			script.on_nth_tick(event, f)
		elseif event == 'on_init' then
			script.on_init(f)
			script.on_configuration_changed(f)
		else
			script.on_event(tonumber(event) or event, f)
		end
		i = i + 1
	end
	finalized = true
	log('Finalized ' .. i .. ' events for ' .. script.mod_name)
end

_G.gui_events = {
	[defines.events.on_gui_click] = {},
	[defines.events.on_gui_confirmed] = {},
	[defines.events.on_gui_text_changed] = {},
	[defines.events.on_gui_checked_state_changed] = {},
	[defines.events.on_gui_selection_state_changed] = {},
	[defines.events.on_gui_checked_state_changed] = {},
	[defines.events.on_gui_elem_changed] = {},
	[defines.events.on_gui_value_changed] = {},
	[defines.events.on_gui_location_changed] = {},
	[defines.events.on_gui_selected_tab_changed] = {},
	[defines.events.on_gui_switch_state_changed] = {}
}
local function process_gui_event(event)
	if event.element and event.element.valid then
		for pattern, f in pairs(gui_events[event.name]) do
			if event.element.name:match(pattern) then f(event); return end
		end
	end
end

for event, _ in pairs(gui_events) do
	h2o.on_event(event, process_gui_event)
end

local delayed_functions = {}
---use this to execute a script after a delay
---example:
---h2o.register_delayed_function('my_delayed_func', function(param1, param2, param3) ... end)
---h2o.execute_later('my_delayed_func', 60, param1, param2, param3)
---The above code will execute my_delayed_func after waiting for 60 ticks
---@param function_key string
---@param ticks integer
---@param ... any
function h2o.execute_later(function_key, ticks, ...)
	local marked_for_death_render_object = rendering.draw_line {
		color = {0, 0, 0, 0},
		width = 0,
		filled = false,
		from = {0, 0},
		to = {0, 0},
		create_build_effect_smoke = false,
		surface = 'nauvis',
		time_to_live = ticks
	}
	global._delayed_functions = global._delayed_functions or {}
	global._delayed_functions[script.register_on_object_destroyed(marked_for_death_render_object)] = {function_key, {...}}
end

h2o.on_event(defines.events.on_object_destroyed, function(event)
	if not global._delayed_functions then return end
	local registration_number = event.registration_number
	local data = global._delayed_functions[registration_number]
	if not data then return end
	global._delayed_functions[registration_number] = nil

	local f = delayed_functions[data[1]]
	if not f then error('No function found for key: ' .. function_key) end
	f(table.unpack(data[2]))
end)

function h2o.register_delayed_function(key, func)
	delayed_functions[key] = func
end