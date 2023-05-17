-- bullets.lua
local enemies = require('enemies')
local bullets = {}
bullets.list = {}

function bullets:load()
    self.speed = 5
    self.size = 8
end

function bullets:update(dt)
    for i=#self.list, 1, -1 do
        local bullet = self.list[i]
        bullet.x = bullet.x + bullet.dx * self.speed * dt
        bullet.y = bullet.y + bullet.dy * self.speed * dt

        -- Remove the bullet if it goes off screen
        if bullet.x < 0 or bullet.y < 0 or bullet.x > love.graphics.getWidth() or bullet.y > love.graphics.getHeight() then
            table.remove(self.list, i)
        else
            -- Check for collision with enemies
            for j=#enemies.list, 1, -1 do
                local enemy = enemies.list[j]
                if math.abs(bullet.x - enemy.x) < enemies.size and math.abs(bullet.y - enemy.y) < enemies.size then
                    table.remove(self.list, i)
                    enemy.health = enemy.health - 10
                    if enemy.health <= 0 then
                        table.remove(enemies.list, j)
                    end
                    break
                end
            end
        end
    end
end

function bullets:draw()
    love.graphics.setColor(1, 1, 0)
    for i, bullet in ipairs(self.list) do
        love.graphics.rectangle('fill', bullet.x, bullet.y, self.size, self.size)
    end
	love.graphics.setColor(1, 1, 1)
	end

function bullets:fire(sx, sy, dx, dy)
    table.insert(self.list, {x = sx, y = sy, dx = dx, dy = dy})
	print('bullet shot')
end



return bullets
