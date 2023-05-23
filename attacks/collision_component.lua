--collision_component.lua
-- collision_component.lua
local collisions = require('collisions')

CollisionComponent = {}
CollisionComponent.__index = CollisionComponent

function CollisionComponent:new(width, height)
  local instance = setmetatable({}, self)
  instance.width = width
  instance.height = height
  return instance
end

function CollisionComponent:execute(attackData)
  local hitTargets = {}
  
  for _, target in ipairs(attackData.targets) do

    if collisions.checkRectangleCollision(
      attackData.attacker.x, attackData.attacker.y, self.width, self.height,
      target.x, target.y, target.size, target.size
    ) then
      table.insert(hitTargets, target)
      print('Target hit')
    else
      print('No collision detected')
    end
  end

  return hitTargets
end


return CollisionComponent

