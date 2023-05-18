--gamestate.lua
local gamestate = {}
local world = require('world')
local player = require('player')
local enemies = require('enemies')
local bullets = require('basic_attacks.bullets')
local visual_effects = require('visual_effects')
local projectiles = require('projectiles')
local roundTime = 60
local roundTimer = roundTime

function gamestate:load()
    world:load()
    player:load()
    enemies:load()
	bullets:load()

	
	-- Add game state for class selection
    self.currentState = 'menu'

    -- Define classes
    classes = {
    {name = 'Wizard', color = {0, 0, 1}, basic_attack = 'lightningStrike'},      -- Blue
    {name = 'Barbarian', color = {1, 0, 0}, basic_attack = 'axeSwing'},   -- Red
    {name = 'Ranger', color = {0, 1, 0}, basic_attack = 'arrowShoot'}       -- Green
	}

    selectedClassIndex = 1
end

local keyDelay = 0.2  -- Adjust this value to set the desired delay in seconds
local keyTimer = 0
local keyPressed = false

function gamestate:selectNextClass()
    selectedClassIndex = (selectedClassIndex % #classes) + 1
end

function gamestate:selectPreviousClass()
    selectedClassIndex = ((selectedClassIndex - 2 + #classes) % #classes) + 1
end

function gamestate:confirmClassSelection()
    local selectedClass = classes[selectedClassIndex]
    player.class = selectedClass.name
    player.color = selectedClass.color  -- Set the player color
	player.currentAttack = selectedClass.basic_attack
    self.currentState = 'play'
    print("Selected Class: " .. player.class)
    print("Selected Class Color: " .. selectedClass.color[1] .. ", " .. selectedClass.color[2] .. ", " .. selectedClass.color[3])
end

function gamestate:update(dt)
    keyTimer = keyTimer + dt
    if self.currentState == 'play' then
        roundTimer = roundTimer - dt
        if roundTimer <= 0 then
            self.currentState = 'gameover'
            roundTimer = roundTime
        end
        player:update(dt)
        enemies:update(dt)
        projectiles:update(dt, enemies)
		visual_effects:update(dt)
        if player.health <= 0 then
            self.currentState = 'gameover'
        end
    end
	
	if gameState == 'classSelect' then
        -- Check if enough time has passed since the last key press
        if keyTimer >= keyDelay then
            -- Move selection to the right
            if love.keyboard.isDown('right') then
				selectedClassIndex = (selectedClassIndex % #classes) + 1
				keyTimer = 0
				keyPressed = true
				end

            -- Move selection to the left
            if love.keyboard.isDown('left') then
				selectedClassIndex = ((selectedClassIndex - 2 + #classes) % #classes) + 1
				keyTimer = 0
				keyPressed = true
				end

            -- Select class and start playing
            if love.keyboard.isDown('up') then
                local selectedClass = classes[selectedClassIndex]
				player.class = selectedClass.name
                self.currentState = 'play'
				print("Selected Class: " .. player.class)
				print("Selected Class Color: " .. selectedClass.color[1] .. ", " .. selectedClass.color[2] .. ", " .. selectedClass.color[3])
            end
        end

        -- Reset the key press status
        if not love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
            keyPressed = false
        end
    end
end

function gamestate:draw()
    if self.currentState == 'play' then
        -- code for play state draw
		world:draw()
        player:draw()
        enemies:draw()
        bullets:draw()
		visual_effects:draw()
		love.graphics.setColor(1, 1, 1)
        love.graphics.print("Time: " .. math.ceil(roundTimer), love.graphics.getWidth() - 100, 10)
		if player.class == "Wizard" then
            love.graphics.print("Left-click to cast Chain Lightning", 10, 30)
        elseif player.class == "Barbarian" then
            love.graphics.print("Left-click to perform Axe Swing", 10, 30)
        elseif player.class == "Ranger" then
            love.graphics.print("Left-click to shoot Arrow", 10, 30)
        end
    elseif self.currentState == 'menu' then
        -- code for menu state draw
		love.graphics.printf("Press Enter to Start Game or Esc to Exit", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2, 100, 'center')
    elseif self.currentState == 'classSelect' then
        -- code for class select state draw
		love.graphics.print('Select your class:', 10, 10)
        for i, class in ipairs(classes) do
            love.graphics.setColor(class.color)
            love.graphics.print(class.name, 10, 30 * i + 10)
            if i == selectedClassIndex then
                love.graphics.print('<<', 200, 30 * i + 10)
            end
		end
    elseif self.currentState == 'gameover' then
        -- code for gameover state draw
		love.graphics.printf("Game Over! Press Enter to Restart or Esc to go to Main Menu", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2, 200, 'center')
	end
end

function gamestate:changeState(newState)
    self.currentState = newState
end

return gamestate