-- event.lua
local Event = {}
Event.__index = Event

function Event.new()
    local self = setmetatable({}, Event)
    self.listeners = {}
    return self
end

function Event:subscribe(listener)
    self.listeners[listener] = true
end

function Event:unsubscribe(listener)
    self.listeners[listener] = nil
end

function Event:emit(...)
    for listener in pairs(self.listeners) do
        listener(...)
    end
end

return Event
