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
    local newProjectile = Projectile.new(self.attacker, self.speed, self.direction, self.sprite)
end

return ProjectileComponent
