-- projectile_component.lua
local Projectile = require('components.projectile')

ProjectileComponent = {}
ProjectileComponent.__index = ProjectileComponent

function ProjectileComponent.new()
    local self = setmetatable({}, ProjectileComponent)
    return self
end

function ProjectileComponent:execute(attackData)
	self.attacker = attackData.attacker
	self.direction = attackData.direction
	self.speed = attackData.speed
	self.sprite = attackData.sprite
	print(attackData.attacker)
    local newProjectile = Projectile.new(self.attacker, self.speed, self.direction, self.sprite, self.targets)
	attackData.attacker = newProjectile
	print(attackData.attacker.x)
	print('created projectile')
	 -- Pass control to the next component
    if self.nextComponent then
        self.nextComponent:execute(attackData)
    end
end

function ProjectileComponent:isFinished()
    -- Check if a hit was detected or maximum range exceeded
    return true
end
return ProjectileComponent
