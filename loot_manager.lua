--loot_manager.lua

local LootDrop = require('loot')

local LootManager = {}

function LootManager:new()
    local newObj = {
        lootDrops = {},  -- you can store your loot drops in here if you want to
    }
    self.__index = self
    return setmetatable(newObj, self)
end

function LootManager:generate(x, y)
    local lootDrop = LootDrop:new(x, y)
    table.insert(self.lootDrops, lootDrop)
    return lootDrop
end

return LootManager
