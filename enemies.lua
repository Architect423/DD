-- enemies.lua
local player = require('player')
local attacks = require('basic_attacks.attacks')
local enemies = {}
enemies.list = {}

function enemies:load()
    self.size = 32  -- size of the enemy, also used as the hitbox size
    self.spawnRate = 2
    self.spawnTimer = 0
    self.health = 20
    self.speed = 50
    self.spawnDistance = 200
	
    player.attackEvent:subscribe(function(attackName, x, y)
        local attack = attacks[attackName]
        if attack then
            self:handleAttack(attack, x, y)
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
        local dx = player.x - enemy.x
        local dy = player.y - enemy.y
        local distance = math.sqrt(dx * dx + dy * dy)

        enemy.x = enemy.x + dx / distance * self.speed * dt
        enemy.y = enemy.y + dy / distance * self.speed * dt

        -- Check collision with player
        if distance < player.size / 2 + self.size / 2 then
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

function enemies:handleAttack(attack, x, y)
    -- Handle different types of attack
    if attack.effect then
        attack.effect(attack, self, player.x, player.y)
    end
end


return enemies
