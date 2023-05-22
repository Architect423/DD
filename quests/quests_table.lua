-- quests_table.lua
local Quest = require('quests.quest')

local quests = {}

-- Example quests
table.insert(quests, Quest:new(
    "Find the Sacred Artifact", 
    "Retrieve the Sacred Artifact from the Forbidden Forest.", 
    function(player) 
        -- Assign condition: player must have at least one gold
        -- Make sure player and player.inventory and player.inventory.lootCount are not nil before trying to access
        return player and player.inventory and player.inventory.lootCount and player.inventory.lootCount["Gold"] and player.inventory.lootCount["Gold"] >= 1
    end, 
    function(player)
        -- Completion condition: player must have the Sacred Artifact in their inventory
        -- Make sure player and player.inventory are not nil before trying to access
        return player and player.inventory and player.inventory["Sacred Artifact"] ~= nil
    end
))

-- More quests...

return quests
