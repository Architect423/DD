-- player.lua
local Event = require('events')
local lightning = require('basic_attacks.lightning')  -- Add this line
local axeswing = require('basic_attacks.axeswing')  -- Add this line
local attacks = require('basic_attacks.attacks')
local visual_effects = require('visual_effects')
local world = require('world')
local town = require('town')
local player = {}
local LootDrop = require('loot')

player.attackEvent = Event.new()
player.enterTownEvent = Event.new()
player.exitTownEvent = Event.new()

function player:load()
    self.x = math.floor(world.mapWidth * world.tileSize  / 2)
    self.y = math.floor(world.mapHeight * world.tileSize / 2)
    self.speed = 100
    self.size = 32
    self.health = 100
    self.damageCooldown = 0
	self.class = "default"  -- Default class
	self.attackCooldown = 0
	self.attackRange = 100
	self.attackDamage = 10
	self.inTown = 0
	self.inventory = {} -- player's inventory
	self.inventory = {
        lootCount = {}  -- Add this line
    }
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
	if self.x >= town.x1 and self.y >= town.y1 and self.x <= town.x2 and self.y <= town.y2 then
        self.enterTownEvent:emit(self.x, self.y)
		self.inTown = 1
	else
		self.exitTownEvent:emit(self.x, self.y)
		self.inTown = 0
    end
	
	for i = #lootDrops, 1, -1 do
        local lootDrop = lootDrops[i]
        -- Simplified collision check, you might want to replace this with your own collision detection logic
        if math.abs(self.x - lootDrop.x) < self.size and math.abs(self.y - lootDrop.y) < self.size then
            -- Add the loot item to the player's inventory
            table.insert(self.inventory, lootDrop.item)
			 -- Increase loot count
            self.inventory.lootCount[lootDrop.item.name] = (self.inventory.lootCount[lootDrop.item.name] or 0) + 1  -- Add this line
            -- Remove the loot drop from the world
            table.remove(lootDrops, i)
        end
    end
end


function player:draw()
    -- Set color based on class
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x - self.size / 2, self.y - self.size / 2, self.size, self.size)
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


