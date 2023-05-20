--enemy_camp.lua
local enemies = require('enemies')

local function EnemyCamp(world, x, y, width, height)
    local camp = {
        x = x,
        y = y,
        width = width,
        height = height,
        enemies = {},
    }

     for i = 1, 5 do
        enemies:spawn(world, x, y + i)
		print('spawning')
    end

    -- Method to check if a point is within the camp
    function camp:containsPoint(x, y)
        return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
    end

    -- Method to check if player is near the camp and spawn enemies if so
    function camp:checkPlayerNear(player)
        local playerNear = self:containsPoint(player.x, player.y)
        if playerNear then
            for i, enemy in ipairs(self.enemies) do
                -- Spawn each enemy if they're not already spawned
            end
        end
    end

    return camp
end

return EnemyCamp
