-- enemy_behaviors.lua

local behaviors = {}

function behaviors:pursuit(enemy, player, dt)
    local dx = player.x - enemy.x
    local dy = player.y - enemy.y
    local distance = math.sqrt(dx * dx + dy * dy)

    enemy.x = enemy.x + dx / distance * enemy.speed * dt
    enemy.y = enemy.y + dy / distance * enemy.speed * dt
    -- Check collision with player
    if distance < player.size / 2 + enemy.size / 2 then
        player:takeDamage(enemy.damage)
    end
end

return behaviors
