--playState.lua
local world = require('world')
local Player = require('player')
local enemies = require('enemies')
local bullets = require('basic_attacks.bullets')
local visual_effects = require('visual_effects')
local projectiles = require('projectiles')
local NPC = require('NPC')
local playState = {}
local npc
local ui = require('ui')
local camera = require('camera')
local LootDrop = require('loot')
local LootManager = require('loot_manager')
local lootManager

local EnemyCamp = require('enemy_camp')

function playState:load()
-- Set the current state to the menu state
    world:load()
    _G.player = Player:new() 
    enemies:load()
	for _, enemySpawnPoint in ipairs(world.enemySpawnPoints) do
        enemies:spawn(enemySpawnPoint.x, enemySpawnPoint.y)
    end
    npc = NPC:new(100*32, 100*32, love.graphics.newImage("npc.png"))
    bullets:load()
    -- Store the enemy camp in the world
    for _, enemySpawnPoint in ipairs(world.enemySpawnPoints) do
        enemies:spawn(enemySpawnPoint.x, enemySpawnPoint.y)
    end

    lootDrops = {}
    roundTimer = 0
    shopItems = {
        {name = "Sword", price = 100},
        {name = "Shield", price = 150},
        {name = "Potion", price = 50}
    }
	lootManager = LootManager:new()

	-- Register a handler for the 'enemyDeath' event
	enemies.enemyDeathEvent:subscribe(function(enemy)
		lootManager:generate(enemy.x, enemy.y)
		print('made loot')
	end)

end

function playState:update(dt)
	roundTimer = roundTimer + dt
	
	if player.health <= 0 then
		self.currentState = gameoverState
	end
	
	local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
	
	player:update(dt)
	camera.x = player.x - screenWidth / 2
    camera.y = player.y - screenHeight / 2

    local mapWidthLimit = world.mapWidth * world.tileSize - screenWidth
    local mapHeightLimit = world.mapHeight * world.tileSize - screenHeight
	
	camera.x = math.max(0, math.min(camera.x, mapWidthLimit))
    camera.y = math.max(0, math.min(camera.y, mapHeightLimit))
	
	enemies:update(dt)
	projectiles:update(dt, enemies)
	npc:update(dt)
	for _, lootDrop in ipairs(lootManager.lootDrops) do
        lootDrop:update(dt)
    end
	visual_effects:update(dt)
	
	for i = #lootManager.lootDrops, 1, -1 do
        local lootDrop = lootManager.lootDrops[i]
        if math.abs(player.x - lootDrop.x) < player.size and math.abs(player.y - lootDrop.y) < player.size then
            player.inventory.lootCount[lootDrop.item.name] = (player.inventory.lootCount[lootDrop.item.name] or 0) + 1
            table.remove(lootManager.lootDrops, i)
        end
    end
end

function playState:draw()
  -- 'play' specific draw logic
  	world:draw(camera)
	love.graphics.push()
	love.graphics.translate(-camera.x, -camera.y)
	-- code for play state draw
	player:draw()
	enemies:draw()
	bullets:draw()
	npc:draw()

	if npc.isShopOpen then  -- add this condition
		ui:drawShop(npc, shopItems)
	end

	for _, lootDrop in ipairs(lootManager.lootDrops) do
        lootDrop:draw()
    end
	love.graphics.setColor(0, 0, 0)
	visual_effects:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.pop()
	ui:drawInGameUI(player, roundTimer)
	ui:drawHealthBar(player)

end

return playState