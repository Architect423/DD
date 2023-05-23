--arrow_attack.lua
local ProjectileComponent = require('attacks.projectile_component')
local DamageComponent = require('attacks.damage_component')

local ArrowAttack = {}

function ArrowAttack:new(attacker, sprite)
  local instance = {
    attacker = attacker,
    sprite = love.graphics.newImage(sprite),
    components = {}
  }
  
  setmetatable(instance, self)
  self.__index = self

  -- Add the ProjectileComponent and DamageComponent
  instance:addComponent(ProjectileComponent:new(attacker, speed, direction, sprite))
  instance:addComponent(DamageComponent:new(damage))
  return instance
end

function ArrowAttack:addComponent(component)
  -- assuming a components table exists to hold components
  self.components = self.components or {}
  table.insert(self.components, component)
end

function ArrowAttack:execute(attacker, direction, speed, damage, targets)
  local attackData = {
    attacker = attacker,
    direction = direction,
    speed = speed,
    damage = damage,
    sprite = self.sprite,
    targets = targets
  }
  
  -- Retrieve the list of hit targets from the CollisionComponent
  local hitTargets = {}
  for _, component in ipairs(self.components) do
    if getmetatable(component).__index == CollisionComponent then
      hitTargets = component:execute(attackData)
    end
  end

  -- Execute other components only for the hit targets
  attackData.targets = hitTargets
  for _, component in ipairs(self.components) do
    if getmetatable(component).__index ~= CollisionComponent then
      component:execute(attackData)
    end
  end
end



-- Rest of the ArrowAttack methods...

return ArrowAttack