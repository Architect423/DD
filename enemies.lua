-- enemies.lua
local attacks = require('basic_attacks.attacks')
local enemy_behaviors = require('enemy_behaviors')
local Event = require('events')

local enemies = {}
enemies.list = {}
enemies.enemyDeathEvent = Event.new()

-- Moved the properties and methods related to individual enemies to the Enemy class
local function Enemy(x, y, size, health, damage, speed, animations)
    local enemy = {
        x = x,
        y = y,
		state = 'pursuit',
        size = size,
        health = health,
        damage = damage,
        speed = speed,
        animations = animations or {},  -- If animations parameter is nil, use empty table
		takeDamage = function(self, amount)
            self.health = self.health - amount
        end
    }
    enemy.current_animation = enemy.animations.walking
    return enemy
end


-- Event subscription
local function subscribeEvents()
	player.attackEvent:subscribe(function(attackName, x, y)
        local attack = attacks[attackName]
        if attack then
            enemies:handleAttack(attack, x, y)
        end
    end)
	
	player.enterTownEvent:subscribe(function(x, y)
        for i, enemy in ipairs(enemies.list) do
            enemy.state = 'idle'
        end
    end)
	
	player.exitTownEvent:subscribe(function(x, y)
        for i, enemy in ipairs(enemies.list) do
            enemy.state = 'pursuit'
        end
    end)
end

-- Spawn function
function enemies:spawn(x, y)

    local enemy = Enemy(x, y, self.size, self.health * (self.healthScaling / 1000), self.damage * (self.damageScaling / 1000), self.speed * (self.speedScaling / 1000), self.animations)

    table.insert(self.list, enemy)
end

function enemies:update(dt)
	
	self.healthScaling = self.healthScaling + .1 -- Increase enemy health by 10% per spawn
    self.damageScaling = self.damageScaling + .1 -- Increase enemy damage by 10% per spawn
    self.speedScaling = self.speedScaling + 1 -- Increase enemy speed by 10% per spawn
	if player.inTown == false then
		for i, enemy in ipairs(self.list) do

			enemy_behaviors:pursuit(enemy, player, dt)  -- Apply pursuit behavior
			end
    end
	
	self.current_frame = self.current_frame + self.animation_speed * dt
    if self.current_frame > #self.current_animation then
        self.current_frame = 1
    end

   -- Remove dead enemies
	for i = #self.list, 1, -1 do
        if self.list[i].health <= 0 then
            -- Dispatch enemy death event
            self.enemyDeathEvent:emit(self.list[i]) -- Emit the event passing the enemy object
            -- Remove the enemy from the list
            table.remove(self.list, i)
        end
    end

end

function enemies:draw()
    love.graphics.setColor(1, 0, 0)
    for i, enemy in ipairs(self.list) do
        love.graphics.rectangle('fill', enemy.x - self.size / 2, enemy.y - self.size / 2, self.size, self.size)
		local scale = 2
		if self.current_animation and self.current_animation[math.floor(self.current_frame)] then
			love.graphics.draw(self.current_animation[math.floor(self.current_frame)], enemy.x - (self.size * scale) / 2, enemy.y - (self.size * scale) / 2, 0, scale, scale)
		end

    end
    love.graphics.setColor(1, 1, 1)
	-- draw current frame
	
end

function enemies:handleAttack(attack, x, y)
    -- Handle different types of attack
    if attack.effect then
        attack.effect(attack, self, player.x, player.y)
    end
end

function enemies:load()
    self.size = 32  
    self.spawnRate = 2
    self.spawnTimer = 0
    self.health = 20
    self.speed = 50
    self.spawnDistance = 200
	self.damage = 10
	
    self.healthScaling = 1000 
    self.damageScaling = 1000
    self.speedScaling = 1000
	
    self.current_frame = 1
    self.animation_speed = 1
    self.scale = 2
	self.animations = {walking = {}}
	self.current_animation = self.animations.walking
	for i = 0, 3 do
        enemies.animations.walking[i] = love.graphics.newImage("orc/run/orc_warrior_run_anim_f" .. i .. ".png")
    end
	
    subscribeEvents()
end

return enemies
