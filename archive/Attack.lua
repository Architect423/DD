-- Attack.lua
local Attack = {}
Attack.__index = Attack

function Attack:new(data)
    local instance = {
        cooldown = data.cooldown,
        range = data.range,
        damage = data.damage,
        effect = data.effect,
        targetMethod = data.targetMethod,
    }
    setmetatable(instance, Attack)
    return instance
end

function Attack:checkInterlocks(attacker, dt)
    if attacker.attackCooldownTimers[self] > 0 then
        attacker.attackCooldownTimers[self] = attacker.attackCooldownTimers[self] - dt
    end
end

function Attack:findTargets(attacker, targets, attack)
    local foundTargets = {}

    -- Implement target finding logic based on the specified targetMethod
    if self.targetMethod == "polygon" then
        -- Implement your polygon-based target finding logic here
        for _, target in ipairs(targets) do
            -- Check if target is within the range
            if math.sqrt((target.x - attacker.x) ^ 2 + (target.y - attacker.y) ^ 2) <= self.range then
                table.insert(foundTargets, target)
            end
        end
    elseif self.targetMethod == "collision" then
        -- Collision-based target finding logic
        -- Implement your collision-based target finding logic here
    end

    return foundTargets
end

function Attack:performAttack(attacker, targets, dt)
    if self:checkInterlocks(attacker, dt) then
		print('we in')
        local foundTargets = self:findTargets(attacker, targets)
        self.effect(self, attacker, attacker.x, attacker.y)
    end
end

return Attack