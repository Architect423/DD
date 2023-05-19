--gamestate.lua
local gamestate = {}
local world = require('world')
local Player = require('player')
local enemies = require('enemies')
local bullets = require('basic_attacks.bullets')
local visual_effects = require('visual_effects')
local projectiles = require('projectiles')
local roundTime = 1
local roundTimer = roundTime
local ui = require('ui')
local camera = require('camera')
local loot = require('loot')
local NPC = require('NPC')

local npc

function gamestate:load()
    world:load()
    _G.player = Player:new() 
    enemies:load()
	npc = NPC:new(100*32, 100*32, love.graphics.newImage("npc.png"))
	bullets:load()

	
	-- Add game state for class selection
    self.currentState = 'menu'
	lootDrops = {}
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
        roundTimer = roundTimer + dt
        if player.health <= 0 then
            self.currentState = 'gameover'
        end
        player:update(dt)
		camera.x = player.x - love.graphics.getWidth() / 2
		camera.y = player.y - love.graphics.getHeight() / 2

				-- Constrain the camera to the world boundaries
		camera.x = math.max(0, math.min(camera.x, world.mapWidth * world.tileSize - love.graphics.getWidth()))
		camera.y = math.max(0, math.min(camera.y, world.mapHeight * world.tileSize - love.graphics.getHeight()))
        enemies:update(dt)
        projectiles:update(dt, enemies)
		npc:update(dt)
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

shopItems = {
    {name = "Sword", price = 100},
    {name = "Shield", price = 150},
    {name = "Potion", price = 50}
}

function gamestate:draw()
    if self.currentState == 'play' then
		love.graphics.push()
		love.graphics.translate(-camera.x, -camera.y)
        -- code for play state draw
		world:draw()
        player:draw()
        enemies:draw()
        bullets:draw()
		npc:draw()
		
		if npc.isShopOpen then  -- add this condition
			ui:drawShop(npc, shopItems)
        end

		for _, lootDrop in pairs(lootDrops) do
			lootDrop:draw()
		end
		love.graphics.setColor(0, 0, 0)
		visual_effects:draw()
		ui:debug()
		love.graphics.setColor(0, 0, 0)
		love.graphics.pop()
		ui:drawInGameUI(player, roundTimer)
		ui:drawHealthBar(player)


    elseif self.currentState == 'menu' then
        -- code for menu state draw
		ui:drawMenu()
    elseif self.currentState == 'classSelect' then
        ui:drawClassSelection(classes, selectedClassIndex)
    elseif self.currentState == 'gameover' then
        -- code for gameover state draw
		ui:drawGameOver()
	end
end

function gamestate:changeState(newState)
    self.currentState = newState
end

return gamestate