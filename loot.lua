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
    obj.animation = LootDrop:loadAnimation(obj.item)  -- Load the animation
    obj.frame = 1  -- Current frame of the animation
    obj.frameTime = 0  -- Time since the last frame change
    return obj
end

function LootDrop:loadAnimation(item)
    local frames = {}
    local i = 0
    while true do
        local frameName = 'coin/coin_anim_f' .. i .. '.png'
        if love.filesystem.getInfo(frameName) then
            frames[#frames + 1] = love.graphics.newImage(frameName)
            i = i + 1
        else
            break
        end
    end
    return frames
end

function LootDrop:update(dt)
    self.frameTime = self.frameTime + dt
    if self.frameTime >= 0.1 then  -- Change frames every 0.1 seconds
        self.frame = self.frame % #self.animation + 1
        self.frameTime = 0
    end
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
    love.graphics.draw(self.animation[self.frame], self.x, self.y, 0, 2, 2)
end


return LootDrop
