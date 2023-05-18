-- projectiles.lua
local projectiles = {}
projectiles.list = {}

function projectiles:create(type, x, y, dirX, dirY, range, damage, speed)
    local projectile = {type = type, x = x, y = y, dirX = dirX, dirY = dirY, range = range, damage = damage, speed = speed, originX = x, originY = y}
    table.insert(self.list, projectile)
end

function projectiles:update(dt, enemies)
    for i = #self.list, 1, -1 do
        local projectile = self.list[i]
        -- Move projectile
        projectile.x = projectile.x + projectile.dirX * projectile.speed * dt
        projectile.y = projectile.y + projectile.dirY * projectile.speed * dt
        -- Check for collisions with enemies
        for _, enemy in ipairs(enemies.list) do
            local dx = enemy.x - projectile.x
            local dy = enemy.y - projectile.y
            local distance = math.sqrt(dx * dx + dy * dy)
            if distance <= enemies.size / 2 then
                enemy:takeDamage(projectile.damage)
                table.remove(self.list, i)
                break
            end
        end
        -- Check if projectile has exceeded its range
        if (projectile.x - projectile.originX)^2 + (projectile.y - projectile.originY)^2 > projectile.range^2 then
            table.remove(self.list, i)
        end
    end
end

return projectiles
