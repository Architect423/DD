-- enemies.lua

local attacks = require('basic_attacks.attacks')
local enemy_behaviors = require('enemy_behaviors')
local world = require('world')
local enemies = {}
local LootDrop = require('loot')
enemies.list = {}

function enemies:load()
    self.size = 32  -- size of the enemy, also used as the hitbox size
    self.spawnRate = 2
    self.spawnTimer = 0
    self.health = 20
    self.speed = 50
    self.spawnDistance = 200
	self.damage = 10
	-- Define enemy scaling properties
    self.healthScaling = 1000 -- Increase enemy health by 10% per spawn
    self.damageScaling = 1000 -- Increase enemy damage by 10% per spawn
    self.speedScaling = 1000 -- Increase enemy speed by 10% per spawn
	
    self.current_frame = 1
    self.animation_speed = 1
    self.scale = 2
	self.animations = {
            walking = {}
        }
	self.current_animation = self.animations.walking
	for i = 0, 3 do
        enemies.animations.walking[i] = love.graphics.newImage("orc/run/orc_warrior_run_anim_f" .. i .. ".png")
    end
	
    player.attackEvent:subscribe(function(attackName, x, y)
        local attack = attacks[attackName]
        if attack then
            self:handleAttack(attack, x, y)
        end
    end)
	
	player.enterTownEvent:subscribe(function(x, y)
        for i, enemy in ipairs(self.list) do
            enemy.state = 'idle'
        end
    end)
	
	player.exitTownEvent:subscribe(function(x, y)
        for i, enemy in ipairs(self.list) do
            enemy.state = 'pursuit'
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
   -- Remove dead enemies
	for i = #self.list, 1, -1 do
		if self.list[i].health <= 0 then
			-- Generate a loot drop
			local lootDrop = LootDrop:new(self.list[i].x, self.list[i].y)
			-- Insert it into the global loot drops table
			table.insert(lootDrops, lootDrop)
			-- Remove the enemy from the list
			table.remove(self.list, i)
		end
	end

end


function enemies:spawn()
    -- Generate a random distance and angle
    local distance = love.math.random(self.spawnDistance, self.spawnDistance + 100)  -- Distance will be between spawnDistance and spawnDistance + 100
    local angle = love.math.random() * 2 * math.pi  -- Angle will be between 0 and 2*pi (full circle)

    -- Convert polar to Cartesian coordinates
    local x = player.x + distance * math.cos(angle)
    local y = player.y + distance * math.sin(angle)
	x = math.max(0, math.min(x, world.mapWidth))
	y = math.max(0, math.min(y, world.mapHeight))


    -- Create enemy
    local enemy = {
        x = x,
        y = y,
		state = 'pursuit',
        size = self.size,
        health = self.health * (self.healthScaling / 1000),
        damage = self.damage * (self.damageScaling / 1000),
        speed = self.speed * (self.speedScaling / 1000)
    }
    function enemy:takeDamage(amount)
        self.health = self.health - amount
    end
    table.insert(self.list, enemy)
end



function enemies:draw()
    love.graphics.setColor(1, 0, 0)
    for i, enemy in ipairs(self.list) do
        love.graphics.rectangle('fill', enemy.x - self.size / 2, enemy.y - self.size / 2, self.size, self.size)
		local scale = 2
		love.graphics.draw(self.current_animation[math.floor(self.current_frame)], enemy.x - (self.size * scale) / 2, enemy.y - (self.size * scale) / 2, 0, scale, scale)
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


return enemies
