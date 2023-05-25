-- player_test.lua
local Event = require('events')
local world = require('world')
local collisions = require('collisions')
local Player = {}

Player.__index = Player
function Player:new()
    local player = {
        x = math.floor((world.mapWidth * world.tileSize  / 2) + 100),
        y = math.floor(world.mapHeight * world.tileSize / 2),
        speed = 100,
        size = 32,
        health = 100,
        damageCooldown = 0,
        class = "default",
        attackCooldown = 2,
        inTown = false,
        inventory = {
            lootCount = {}
        },
        animations = {
            walking = {}
        },
        current_animation = nil,
        current_frame = 1,
        animation_speed = 1,
        scale = 2,
		inputAttackMap = {
            ['left-click'] = 'ArrowAttack',
            ['right-click'] = 'swordSlash',
            ['q'] = 'spellCast1',
            ['e'] = 'spellCast2',
            -- and so on...
        },
		attackCooldowns = {
            ['ArrowAttack'] = 2,
            ['swordSlash'] = 2,
            ['spellCast1'] = 2,
            ['spellCast2'] = 2,
            -- and so on...
        },
        attackEvent = Event.new(),
        enterTownEvent = Event.new(),
        exitTownEvent = Event.new()
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
function Player:update(dt, camera, enemies)
     -- Movement, Damage, and Attack logic remains the same...
    local new_x = self.x
    local new_y = self.y
    
    if love.keyboard.isDown('w') then
        new_y = self.y - self.speed * dt
    end
    if love.keyboard.isDown('a') then
        new_x = self.x - self.speed * dt
    end
    if love.keyboard.isDown('s') then
        new_y = self.y + self.speed * dt
    end
    if love.keyboard.isDown('d') then
        new_x = self.x + self.speed * dt
    end
	self.attackData.targets = enemies.list
    -- Check for collisions with walls
    local collided = false
    for _, wall in ipairs(world.walls) do    
        if collisions.checkRectangleCollision(new_x - self.size / 2, new_y - self.size / 2, self.size, self.size, wall.x, wall.y, wall.width, wall.height) then
            collided = true
            break
        end
    end
        
    -- Only update position if no collision
    if not collided then
        self.x = new_x
        self.y = new_y
    end
	
    self.damageCooldown = math.max(0, self.damageCooldown - dt)
	
	 -- Update attack cooldowns
    for attackType, cooldown in pairs(self.attackCooldowns) do
        if cooldown > 0 then
            self.attackCooldowns[attackType] = cooldown - dt
        end
    end

		-- Check for attack inputs
	for input, attackType in pairs(self.inputAttackMap) do
		if self:isInputActive(input) then
			if self.attackCooldowns[attackType] <= 0 then
				self:performAttack(attackType, dt, enemies)
				self.attackCooldowns[attackType] = self.attackCooldown -- Reset the attack cooldown to its specific time
			end
		end
	end

	-- Execute the arrow attack
	
	local mouseX, mouseY = love.mouse.getPosition()
	
	-- Convert from window coordinates to world coordinates
	mouseX = mouseX + camera.x
	mouseY = mouseY + camera.y
	local playerX, playerY = self.x, self.y

	-- Calculate the direction vector
	local direction = {
		x = mouseX - playerX,
		y = mouseY - playerY
	}

	-- Normalize the direction vector
	local magnitude = math.sqrt(direction.x^2 + direction.y^2)
	if magnitude > 0 then
		direction.x = direction.x / magnitude
		direction.y = direction.y / magnitude
	end

	self.attackData.speed = 40
	self.attackData.damage = 5
	self.attackData.direction = direction

    -- Animation logic
    self.current_frame = self.current_frame + self.animation_speed * dt
    if self.current_frame > #self.current_animation then
        self.current_frame = 1
    end

    -- Update collision logic
    local isInTown = false
    for _, townArea in ipairs(world.townAreas) do
        if self.x >= townArea.x and self.y >= townArea.y and
           self.x <= townArea.x + townArea.width and self.y <= townArea.y + townArea.height then
            isInTown = true
            break
        end
    end

    if isInTown and not self.inTown then
        self.enterTownEvent:emit(self.x, self.y)
        self.inTown = true
    elseif not isInTown and self.inTown then
        self.exitTownEvent:emit(self.x, self.y)
        self.inTown = false
    end
	
--

end

function Player:draw()
    -- draw current frame
    local spriteWidth = self.current_animation[math.floor(self.current_frame)]:getWidth()
    local spriteHeight = self.current_animation[math.floor(self.current_frame)]:getHeight()
    love.graphics.draw(
        self.current_animation[math.floor(self.current_frame)], 
        self.x - (spriteWidth * self.scale) / 2, 
        self.y - (spriteHeight * self.scale) / 2, 
        0, 
        self.scale, 
        self.scale
    )
end

function Player:takeDamage(amount)
    if self.damageCooldown <= 0 then
        self.health = self.health - amount
        self.damageCooldown = 0.5
    end
end

function Player:performAttack(attackType, dt, enemies)
   self.attackEvent:emit(self.attackData)
end


local mouseState = {
    ['left-click'] = false,
    ['right-click'] = false
}

function Player:isInputActive(input)
    if input == 'left-click' then
        local isPressed = love.mouse.isDown(1)
        local wasPressed = mouseState['left-click']
        mouseState['left-click'] = isPressed
        return isPressed and not wasPressed
    elseif input == 'right-click' then
        local isPressed = love.mouse.isDown(2)
        local wasPressed = mouseState['right-click']
        mouseState['right-click'] = isPressed
        return isPressed and not wasPressed
    else
        return love.keyboard.isDown(input)
    end
end

function Player:collidesWithWall(x, y)
    for _, wall in ipairs(world.walls) do
        if collisions.checkRectangleCollision(x, y, self.spriteWidth, self.spriteHeight, wall.x, wall.y, wall.width, wall.height) then
            return true
        end
    end
    return false
end

return Player
