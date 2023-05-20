local Event = require('events')
local world = require('world')
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
        -- Check if the shop is already open
        if not self.isShopOpen then
            self.isShopOpen = true
        end
    else
        -- Check if the shop is currently open and if any of the conditions to close it are met
        if self.isShopOpen and (love.keyboard.isDown("e") or love.keyboard.isDown("escape") or love.keyboard.isDown("w", "a", "s", "d")) then
            self.isShopOpen = false
        end
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
