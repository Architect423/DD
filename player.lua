-- player.lua
local Event = require('events')
local lightning = require('basic_attacks.lightning')  -- Add this line
local axeswing = require('basic_attacks.axeswing')  -- Add this line
local player = {}
player.axeSwings = {}
player.lightningStrikes = {}
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
	
	for i = #self.axeSwings, 1, -1 do
        local swing = self.axeSwings[i]
        swing.life = swing.life - dt
        if swing.life <= 0 then
            table.remove(self.axeSwings, i)
        end
    end
    lightning:update(dt, self.x, self.y)  -- Modify this line
    axeswing:update(dt, self.x, self.y)  -- Modify this line
end


function player:draw()
    -- Set color based on class
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x - self.size / 2, self.y - self.size / 2, self.size, self.size)
    love.graphics.setColor(1, 1, 1)  -- Reset color to default (white)
	player:drawAxeSwings()
	player:drawLightningStrikes()
    love.graphics.rectangle('fill', 10, 10, self.health, 10)  -- Health bar
	lightning:draw(self.x, self.y)  -- Modify this line
    axeswing:draw(self.x, self.y)  -- Modify this line
	
end

function player:takeDamage(amount)
    if self.damageCooldown <= 0 then
        self.health = self.health - amount
        self.damageCooldown = 0.5
	end
end

function player:performAxeSwing()
    if self.attackCooldown <= 0 then
        self.attackCooldown = self.attackDuration
        local swing = {x = self.x, y = self.y, life = 0.2, range = self.attackRange}  -- Include range here
        table.insert(self.axeSwings, swing)  -- life in seconds
        self.attackEvent:emit('axeSwing', self.x, self.y, self.attackRange, self.attackDamage)  -- Modify this line
    end
end



-- player.lua
function player:drawAxeSwings()
    for _, swing in ipairs(self.axeSwings) do
        love.graphics.setColor(1, 1, 1, swing.life * 5)  -- The *5 makes the swing fade out quickly
        love.graphics.circle('line', swing.x, swing.y, self.attackRange)
    end
end

function player:drawLightningStrikes() -- Add this function
    for i, strike in ipairs(self.lightningStrikes) do
        love.graphics.setColor(0, 0, 1, strike.life * 5)  -- The *5 makes the strike fade out quickly
        if i < #self.lightningStrikes then
            local nextStrike = self.lightningStrikes[i + 1]
            love.graphics.line(strike.x, strike.y, nextStrike.x, nextStrike.y)
        end
    end
end



function player:castChainLightning()
    self.attackEvent:emit('chainLightning', self.x, self.y, self.attackRange, self.attackDamage)
end

function player:shootArrow()
    self.attackEvent:emit('shootArrow', self.x, self.y, self.attackRange, self.attackDamage)
end

return player


