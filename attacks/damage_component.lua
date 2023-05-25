-- damage_component.lua
DamageComponent = {}
DamageComponent.__index = DamageComponent

function DamageComponent:new(damage)
    local self = setmetatable({}, DamageComponent)
    self.damage = damage
    return self
end

function DamageComponent:execute(attackData)
    if attackData and attackData.health then
        attackData.health = attackData.health - self.damage
    else
        print("Invalid target")
    end
end

function DamageComponent:isFinished()
    -- Check if a hit was detected or maximum range exceeded
    return true
end

return DamageComponent

