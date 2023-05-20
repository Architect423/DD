-- enemy_behaviors.lua

local behaviors = {}

-- Idle behavior
function behaviors:idle(enemy, player, dt)
    local dx = player.x - enemy.x
    local dy = player.y - enemy.y
    local distance = math.sqrt(dx * dx + dy * dy)
    -- Transition condition from idle to aggro
    if distance < enemy.aggroRange then
        enemy.state = 'aggro'
    end
end

-- Aggro behavior
function behaviors:aggro(enemy, player, dt)
    local dx = player.x - enemy.x
    local dy = player.y - enemy.y
    local distance = math.sqrt(dx * dx + dy * dy)
    enemy.x = enemy.x + dx / distance * enemy.speed * dt
    enemy.y = enemy.y + dy / distance * enemy.speed * dt
    -- Check collision with player
    if enemy:checkCollision(player) then
        player:takeDamage(enemy.damage)
    end
    -- Transition condition from aggro to deaggro
    if distance > enemy.deaggroRange then
        enemy.state = 'deaggro'
    end
end

-- Deaggro behavior
function behaviors:deaggro(enemy, player, dt)
    -- Move enemy back to prime location
    local dx = enemy.primeLocation.x - enemy.x
    local dy = enemy.primeLocation.y - enemy.y
    local distance = math.sqrt(dx * dx + dy * dy)
    enemy.x = enemy.x + dx / distance * enemy.speed * dt
    enemy.y = enemy.y + dy / distance * enemy.speed * dt
    -- Transition condition from deaggro to idle
    if distance < 1 then -- Choose an appropriate small number for distance check
        enemy.state = 'idle'
    end
end

return behaviors
