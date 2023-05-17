-- enemies.lua
local player = require('player')

local enemies = {}
enemies.list = {}

function enemies:load()
    self.size = 32
    self.spawnRate = 2
    self.spawnTimer = 0
    self.health = 20
	self.speed = 50
	self.spawnDistance = 200
	
	 player.attackEvent:subscribe(function(attackType, x, y, range, damage)
        if attackType == 'axeSwing' then
            self:handleAxeSwing(x, y, range, damage)
        elseif attackType == 'chainLightning' then
            self:handleChainLightning(x, y, range, damage)
        elseif attackType == 'shootArrow' then
            self:handleShootArrow(x, y, range, damage)
        end
    end)
end

function enemies:update(dt)
    -- Update spawn timer
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer >= self.spawnRate then
        self.spawnTimer = 0
        self:spawn()
    end

    for i, enemy in ipairs(self.list) do
        -- Move enemy towards player
        local angle = math.atan2(player.y - enemy.y, player.x - enemy.x)
        enemy.x = enemy.x + math.cos(angle) * self.speed * dt
        enemy.y = enemy.y + math.sin(angle) * self.speed * dt

        -- Check collision with player
        if math.abs(enemy.x - player.x) < player.size and math.abs(enemy.y - player.y) < player.size then
            player:takeDamage(10)
        end
    end
	
	-- Remove dead enemies
    for i = #self.list, 1, -1 do
        if self.list[i].health <= 0 then
            table.remove(self.list, i)
        end
    end
end


function enemies:spawn()
    local x, y
    repeat
        x = love.math.random(0, love.graphics.getWidth())
        y = love.math.random(0, love.graphics.getHeight())
    until (x - player.x)^2 + (y - player.y)^2 >= (self.size + player.size)^2
    local enemy = {x = x, y = y, health = self.health}
    function enemy:takeDamage(amount)
        self.health = self.health - amount
    end
    table.insert(self.list, enemy)
end


function enemies:draw()
    love.graphics.setColor(1, 0, 0)
    for i, enemy in ipairs(self.list) do
        love.graphics.rectangle('fill', enemy.x - self.size / 2, enemy.y - self.size / 2, self.size, self.size)
    end
    love.graphics.setColor(1, 1, 1)
end

function enemies:handleChainLightning(x, y, range, damage)
    local enemiesHit = {}
    table.insert(player.lightningStrikes, {x = x, y = y, life = 0.2})  -- Add this line
    for _, enemy in ipairs(self.list) do
        local dx = enemy.x - x
        local dy = enemy.y - y
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance <= range and not enemiesHit[enemy] then
            enemy:takeDamage(damage)
            enemiesHit[enemy] = true
            table.insert(player.lightningStrikes, {x = enemy.x, y = enemy.y, life = 0.2})  -- Add this line
        end
    end
end

function enemies:handleAxeSwing(x, y, range, damage)
    for _, enemy in ipairs(self.list) do
        local dx = enemy.x - x
        local dy = enemy.y - y
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance <= range then
            enemy:takeDamage(damage)
        end
    end
end

function enemies:handleShootArrow(x, y, range, damage)
    local bullets = require('basic_attacks.bullets')
    local mouseX, mouseY = love.mouse.getPosition()
    local angle = math.atan2(mouseY - y, mouseX - x)
    local bulletSpeed = 500

    local dx = bulletSpeed * math.cos(angle)
    local dy = bulletSpeed * math.sin(angle)

    bullets:fire(x, y, dx, dy)
end

return enemies




