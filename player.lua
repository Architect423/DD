-- player.lua
local Event = require('events')
local lightning = require('basic_attacks.lightning')  -- Add this line
local axeswing = require('basic_attacks.axeswing')  -- Add this line
local attacks = require('basic_attacks.attacks')
local visual_effects = require('visual_effects')

local player = {}

player.attackEvent = Event.new()


function player:load()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.speed = 100
    self.size = 32
    self.health = 100
    self.damageCooldown = 0
	self.class = "default"  -- Default class
	self.attackCooldown = 0
	self.attackRange = 100
	self.attackDamage = 10
	self.currentAttack = 'axeSwing' -- Default attack
end

function player:update(dt)
    if love.keyboard.isDown('w') then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown('a') then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown('s') then
        self.y = self.y + self.speed * dt
    end
    if love.keyboard.isDown('d') then
        self.x = self.x + self.speed * dt
    end
    self.damageCooldown = math.max(0, self.damageCooldown - dt)
	
	if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end
	if love.mouse.isDown(1) and self.attackCooldown <= 0 then
		self:performAttack(self.currentAttack)
		end
end


function player:draw()
    -- Set color based on class
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x - self.size / 2, self.y - self.size / 2, self.size, self.size)
    love.graphics.setColor(1, 1, 1)  -- Reset color to default (white)
    love.graphics.rectangle('fill', 10, 10, self.health, 10)  -- Health bar
end

function player:takeDamage(amount)
    if self.damageCooldown <= 0 then
        self.health = self.health - amount
        self.damageCooldown = 0.5
	end
end

function player:performAttack(attackType)
    local attack = attacks[attackType]
    if attack and self.attackCooldown <= 0 then
        self.attackCooldown = attack.cooldown
        self.attackEvent:emit(attackType, self.x, self.y)

    end
end

return player


