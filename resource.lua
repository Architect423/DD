-- resource.lua

local Resource = {}
Resource.__index = Resource

function Resource:new(name, requiredTool, durability, loot)
    local resource = {
        name = name,
        requiredTool = requiredTool,
        durability = durability,
        harvestProgress = 0,
        loot = loot or {}
    }
    setmetatable(resource, self)
    return resource
end

function Resource:harvest(player)
    if player.equippedTool == self.requiredTool then
        self.harvestProgress = self.harvestProgress + player.equippedTool.efficiency
        if self.harvestProgress >= self.durability then
            self.harvestProgress = 0
            self:dropLoot(player)
        end
    else
        print("You need a " .. self.requiredTool .. " to harvest " .. self.name)
    end
end

function Resource:dropLoot(player)
    print("You have harvested the " .. self.name)
    for loot, quantity in pairs(self.loot) do
        player:receiveLoot(loot, quantity)
    end
    self.loot = {}
end

function Resource:draw(x, y)
    -- Assume you are using love2d to draw
    love.graphics.rectangle("line", x, y, 100, 10)  -- Draw the outline of the progress bar
    love.graphics.rectangle("fill", x, y, (self.harvestProgress / self.durability) * 100, 10)  -- Fill in the progress bar based on harvest progress
end

return Resource
