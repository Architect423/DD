-- loot.lua
local LootDrop = {}
LootDrop.__index = LootDrop
local lootItems = require('loot_table')  -- import the loot table

function LootDrop:new(x, y)
    local obj = {}
    setmetatable(obj, LootDrop)
    obj.x = x
    obj.y = y
    obj.item = LootDrop:generateItem()
    return obj
end

function LootDrop:generateItem()
    -- Calculate total rarity
    local totalRarity = 0
    for _, item in pairs(lootItems) do
        totalRarity = totalRarity + item.rarity
    end
    -- Generate a random number
    local rand = love.math.random() * totalRarity
    -- Select the item
    for _, item in pairs(lootItems) do
        if rand < item.rarity then
            return item
        end
        rand = rand - item.rarity
    end
end

function LootDrop:drawOutline(size, outlineSize)
    -- Draw black outline
    love.graphics.setColor(0, 0, 0)  -- Black
    if self.item.shape == 'triangle' then
        love.graphics.polygon('line', 
            self.x, self.y - outlineSize,  -- Top point
            self.x - outlineSize, self.y + outlineSize,  -- Bottom left point
            self.x + outlineSize, self.y + outlineSize)  -- Bottom right point
    elseif self.item.shape == 'square' then
        love.graphics.rectangle('line', self.x - outlineSize / 2, self.y - outlineSize / 2, outlineSize, outlineSize)
    elseif self.item.shape == 'circle' then
        love.graphics.circle('line', self.x, self.y, outlineSize)
    end
end

function LootDrop:drawShape(size)
    -- Assign color based on item
    love.graphics.setColor(self.item.color)
    if self.item.shape == 'triangle' then
        love.graphics.polygon('fill', 
            self.x, self.y - size,  -- Top point
            self.x - size, self.y + size,  -- Bottom left point
            self.x + size, self.y + size)  -- Bottom right point
    elseif self.item.shape == 'square' then
        love.graphics.rectangle('fill', self.x - size / 2, self.y - size / 2, size, size)
    elseif self.item.shape == 'circle' then
        love.graphics.circle('fill', self.x, self.y, size)
    end
end

function LootDrop:draw()
    local size = 10  -- size of the shape
    local outlineSize = size + 2  -- size of the outline
    self:drawOutline(size, outlineSize)
    self:drawShape(size)
end


return LootDrop
