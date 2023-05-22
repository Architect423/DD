-- quest.lua
local Quest = {}
Quest.__index = Quest

function Quest:new(title, description, canAssign, canComplete)
    local q = {}
    setmetatable(q, Quest)
    q.title = title
    q.description = description
    q.status = "Not Assigned"
    q.canAssign = canAssign
    q.canComplete = canComplete
    return q
end

function Quest:assign(player)
    assert(self.status == "Not Assigned", "Quest must be 'Not Assigned' to be assigned")
    assert(self.canAssign(player), "Quest assign condition not met")
    self.status = "Assigned"
end

function Quest:complete(player)
    assert(self.status == "Assigned", "Quest must be 'Assigned' to be completed")
    assert(self.canComplete(player), "Quest completion condition not met")
    self.status = "Complete"
end

return Quest
