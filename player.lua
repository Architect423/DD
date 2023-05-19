-- player_test.lua
local Event = require('events')
local attacks = require('basic_attacks.attacks')
local world = require('world')
local town = require('town')
local LootDrop = require('loot')

local Player = {}
Player.__index = Player

function Player:new()
    local player = {
        x = math.floor(world.mapWidth * world.tileSize  / 2),
        y = math.floor(world.mapHeight * world.tileSize / 2),
        speed = 100,
        size = 32,
        health = 100,
        damageCooldown = 0,
        class = "default",
        attackCooldown = 0,
        attackRange = 100,
        attackDamage = 10,
        inTown = false,
        inventory = {
            lootCount = {}
        },
        currentAttack = 'axeSwing',
        animations = {
            walking = {}
        },
        current_animation = nil,
        current_frame = 1,
        animation_speed = 1,
        scale = 2,
        attackEvent = Event.new(),
        enterTownEvent = Event.new(),
        exitTownEvent = Event.new(),
		playerInteractionEvent = Event.new()

    }

    -- Load walking animation
    for i = 0, 3 do
        player.animations.walking[i] = love.graphics.newImage("wizard/run/m/wizzard_m_run_anim_f" .. i .. ".png")
    end

    -- Set the current animation to walking
    player.current_animation = player.animations.walking

    setmetatable(player, self)
    return player
end

function Player:update(dt)
    -- Movement, Damage, and Attack logic remains the same...
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
    -- Animation logic
    self.current_frame = self.current_frame + self.animation_speed * dt
    if self.current_frame > #self.current_animation then
        self.current_frame = 1
    end

    -- Collision logic and Loot Pickup
    if self.x >= town.x1 and self.y >= town.y1 and self.x <= town.x2 and self.y <= town.y2 then
        self.enterTownEvent:emit(self.x, self.y)
        self.inTown = true
    else
        self.exitTownEvent:emit(self.x, self.y)
        self.inTown = false
    end

    for i = #lootDrops, 1, -1 do
        local lootDrop = lootDrops[i]
        if math.abs(self.x - lootDrop.x) < self.size and math.abs(self.y - lootDrop.y) < self.size then
            self.inventory.lootCount[lootDrop.item.name] = (self.inventory.lootCount[lootDrop.item.name] or 0) + 1
            table.remove(lootDrops, i)
        end
    end
end

function Player:draw()
    -- Set color based on class
    love.graphics.setColor(player.color)
    love.graphics.rectangle('fill', self.x - self.size / 2, self.y - self.size / 2, self.size, self.size)

    -- Set color to white
    love.graphics.setColor(1, 1, 1)

    -- draw current frame
	local scale = 2
    love.graphics.draw(self.current_animation[math.floor(self.current_frame)], self.x - (self.size * scale) / 2, self.y - (self.size * scale) / 2, 0, scale, scale)

end

function Player:takeDamage(amount)
    if self.damageCooldown <= 0 then
        self.health = self.health - amount
        self.damageCooldown = 0.5
    end
end

function Player:performAttack(attackType)
    local attack = attacks[attackType]
    if attack and self.attackCooldown <= 0 then
        self.attackCooldown = attack.cooldown
        self.attackEvent:emit(attackType, self.x, self.y)

        -- Additional attack-specific logic if needed
        if attackType == "lightning" then
            -- Handle lightning attack logic
            -- ...
        elseif attackType == "axeswing" then
            -- Handle axeswing attack logic
            -- ...
        end
    end
end

return Player
