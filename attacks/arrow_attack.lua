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

function ArrowAttack:execute(attacker, direction, speed, damage)
  local attackData = {
    attacker = attacker,
    direction = direction,
    speed = speed,
    damage = damage,
    sprite = self.sprite
  }
  
  for _, component in ipairs(self.components) do
    component:execute(attackData)
  end
end




-- Rest of the ArrowAttack methods...

return ArrowAttack