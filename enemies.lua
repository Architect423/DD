-- enemies.lua
local attacks = require('basic_attacks.attacks')
local enemy_behaviors = require('enemy_behaviors')
local Event = require('events')
local Enemy = require('enemy')  -- This is how you include the Enemy module

local enemies = {}
enemies.list = {}
enemies.enemyDeathEvent = Event.new()

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
            enemy.state = 'deaggro'
        end
    end)
	
end

-- Spawn function
function enemies:spawn(x, y)
    local enemy = Enemy.new(
        x, y, 
        self.size, 
        self.health * (self.healthScaling / 1000), 
        self.damage * (self.damageScaling / 1000), 
        self.speed * (self.speedScaling / 1000), 
        self.animations
    )

    table.insert(self.list, enemy)
end


function enemies:update(dt)
	
	self.healthScaling = self.healthScaling + .1 -- Increase enemy health by 10% per spawn
    self.damageScaling = self.damageScaling + .1 -- Increase enemy damage by 10% per spawn
    self.speedScaling = self.speedScaling + 1 -- Increase enemy speed by 10% per spawn
	
	for i, enemy in ipairs(self.list) do
        enemy_behaviors[enemy.state](enemy_behaviors, enemy, player, dt)  -- Apply behavior based on state
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
    for i, enemy in ipairs(self.list) do
        if self.current_animation and self.current_animation[math.floor(self.current_frame)] then
            -- Get the dimensions of the current animation frame
            local spriteWidth = self.current_animation[math.floor(self.current_frame)]:getWidth()
            local spriteHeight = self.current_animation[math.floor(self.current_frame)]:getHeight()

            -- Calculate the position to draw the sprite so that it aligns with the hitbox
            love.graphics.draw(
                self.current_animation[math.floor(self.current_frame)], 
                enemy.x - (spriteWidth * self.scale) / 2, 
                enemy.y - (spriteHeight * self.scale) / 2, 
                0, 
                self.scale, 
                self.scale
            )
        end
    end

    love.graphics.setColor(1, 1, 1)
end


function enemies:handleAttack(attack, x, y)
    -- Handle different types of attack
    if attack.effect then
        attack.effect(attack, self, player.x, player.y)
    end
end

function enemies:load()
    -- Size variables
    self.size = 32
    self.scale = 2

    -- Spawn variables
    self.spawnRate = 2
    self.spawnTimer = 0
    self.spawnDistance = 200

    -- Stats
    self.health = 20
    self.speed = 50
    self.damage = 10

    -- Scaling factors
    self.healthScaling = 1000 
    self.damageScaling = 1000
    self.speedScaling = 1000

    -- State and range variables
    self.state = 'idle'
    self.aggroRange = 200
    self.deaggroRange = 500

    -- Animation variables
    self.current_frame = 1
    self.animation_speed = 1
    self.animations = {walking = {}}
    self.current_animation = self.animations.walking

    -- Load animation images
    for i = 0, 3 do
        self.animations.walking[i] = love.graphics.newImage("orc/run/orc_warrior_run_anim_f" .. i .. ".png")
    end
	
    subscribeEvents()
end


return enemies
