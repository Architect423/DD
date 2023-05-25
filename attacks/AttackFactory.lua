--AttackFactory.lua

ProjectileComponent = require("attacks.projectile_component")
CollisionComponent = require("attacks.collision_component")
DamageComponent = require("attacks.damage_component")


local AttackFactory = {}
AttackFactory.__index = AttackFactory

function AttackFactory:new()
    local newAttackFactory = {}
    setmetatable(newAttackFactory, AttackFactory)
    return newAttackFactory
end

function AttackFactory:createArrowAttack()
	local arrowAttack = {}
    -- local arrowAttack = ProjectileComponent:new(CollisionComponent:new(DamageComponent:new()))
	local projectileComponent = ProjectileComponent:new()
	local collisionComponent = CollisionComponent:new(100, 100)
	local damageComponent = DamageComponent:new(100)

	projectileComponent.nextComponent = collisionComponent
	collisionComponent.nextComponent = damageComponent

	arrowAttack.currentComponent = projectileComponent
    return arrowAttack
end

return AttackFactory
