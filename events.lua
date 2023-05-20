-- event.lua
local Event = {}
Event.__index = Event

function Event.new()
    local self = setmetatable({}, Event)
    self.listeners = {}
    self.callbacks = {}  -- initialize callbacks table
    return self
end


function Event:subscribe(listener)
    self.listeners[listener] = true
end

function Event:unsubscribe(listener)
    self.listeners[listener] = nil
end

function Event:emit(...)
    -- Handle named listeners
    for listener in pairs(self.listeners) do
        if type(listener) == "function" then
            listener(...)
        end
    end

    -- Handle anonymous callbacks
    for _, callback in ipairs(self.callbacks) do
        callback(...)
    end
end


function Event:listen(callback)
    table.insert(self.callbacks, callback)
end


return Event
