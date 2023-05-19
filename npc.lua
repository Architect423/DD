local Event = require('events')
local world = require('world')
local town = require('town')

local NPC = {}
NPC.__index = NPC

function NPC:new(x, y, sprite)
    local npc = {
        x = x,
        y = y,
        sprite = sprite,
        size = 32,
        inTown = false,
        shopMenuOpen = false,
        interactionEvent = Event.new(),
        enterTownEvent = Event.new(),
        exitTownEvent = Event.new()
    }

    setmetatable(npc, self)
    return npc
end

function NPC:update(dt)
    -- Collision logic
    if self.x >= town.x1 and self.y >= town.y1 and self.x <= town.x2 and self.y <= town.y2 then
        self.enterTownEvent:emit(self.x, self.y)
        self.inTown = true
    else
        self.exitTownEvent:emit(self.x, self.y)
        self.inTown = false
    end
end

function NPC:draw()
    -- Draw the NPC sprite
	scale = 2
    love.graphics.draw(self.sprite, self.x - self.size / 2, self.y - self.size / 2, 0, scale, scale)
end

function NPC:interact()
    if self.inTown then
        self.shopMenuOpen = true
        self.interactionEvent:emit()
    end
end

return NPC
