--collision_component.lua
CollisionComponent = Class{__includes = AttackComponent}
local collisions = require('collisions')
function CollisionComponent:init(width, height, damageComponent)
  self.width = width
  self.height = height
  self.damageComponent = damageComponent
end

function CollisionComponent:execute(attacker, target)
  -- use your existing collision function
  if collisions.checkRectangleCollision(
    attacker.x, attacker.y, self.width, self.height,
    target.x, target.y, target.width, target.height
  ) then
    self.damageComponent:execute(attacker, target)
  end
end
