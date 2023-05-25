--collision_component.lua
-- collision_component.lua
local collisions = require('collisions')

CollisionComponent = {}
CollisionComponent.__index = CollisionComponent

function CollisionComponent:new(width, height)
  local instance = setmetatable({}, self)
  instance.width = width
  instance.height = height
  instance.hitTargets = {}
  return instance
end

function CollisionComponent:execute(attackData)
    self.width = 100
    self.height = 100
	attackData.range = 100
    local hitTargets = {}

    for _, target in ipairs(attackData.targets) do
        if collisions.checkRectangleCollision(
            attackData.attacker.x, attackData.attacker.y, self.width, self.height,
            target.x, target.y, target.size, target.size
        ) then
            table.insert(hitTargets, target)
            attackData.attacker:remove()
            print('Target hit')
        end
    end
    self.hitTargets = hitTargets

    -- Check if the projectile has exceeded its range
    if attackData.attacker:distanceTraveled() > attackData.range then
        attackData.attacker:remove()
        print('Projectile exceeded its range')
		self.nextComponent = nil
    end

    if #hitTargets > 0 and self.nextComponent then
        attackData.hitTargets = self.hitTargets
        print(self.nextComponent)
        for _, target in ipairs(hitTargets) do
            self.nextComponent:execute(target)
        end
    end
end


function CollisionComponent:isFinished()
    -- Check if a hit was detected or maximum range exceeded
    return #self.hitTargets > 0
end

return CollisionComponent

