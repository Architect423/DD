local Event = require('events')
local world = require('world')
local town = require('town')
local ui = require('ui')
local NPC = {}
NPC.__index = NPC

function NPC:new(x, y, sprite)
    local npc = {
        x = x,
        y = y,
        sprite = sprite,
        size = 32,
		isShopOpen = false
    }

    setmetatable(npc, self)
    return npc
end

function NPC:update(dt)
     -- Calculate distance to player
    local distToPlayer = math.sqrt((player.x - self.x)^2 + (player.y - self.y)^2)

      -- Check if player is within 100 units and if "e" is pressed
    if distToPlayer <= 100 and love.keyboard.isDown("e") then
        self.isShopOpen = true
    else
        self.isShopOpen = false
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
