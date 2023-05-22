-- damage_component.lua
DamageComponent = {}
DamageComponent.__index = DamageComponent

function DamageComponent.new(damage)
    local self = setmetatable({}, DamageComponent)
    self.damage = damage
    return self
end

function DamageComponent:execute(attacker, target)
    -- logic to deal damage to the target
end

return DamageComponent
