--playState.lua
local world = require('world')
local Player = require('player')
local enemies = require('enemies')
local NPC = require('NPC')
local playState = {}
local npc
local ui = require('ui')
local camera = require('camera')
local LootDrop = require('loot')
local LootManager = require('loot_manager')
local lootManager

local quests_table = require('quests.quests_table')

local gamestate = {}
local quests = {}

function playState:load()
    -- Set the current state to the menu state
    world:load()
    player = Player:new() 
    enemies:load()
	
	for _, enemySpawnPoint in ipairs(world.enemySpawnPoints) do
        enemies:spawn(enemySpawnPoint.x, enemySpawnPoint.y)
    end
	self.npcs = {}

    for _, npcSpawnPoint in ipairs(world.npcSpawnPoints) do
		print(npcSpawnPoint.x)
		local npc = NPC:new(npcSpawnPoint.x, npcSpawnPoint.y, love.graphics.newImage("npc.png"))
		table.insert(self.npcs, npc) -- Store NPCs in the npcs table
	end
    lootDrops = {}
    roundTimer = 0
    shopItems = {
        {name = "Sword", price = 100},
        {name = "Shield", price = 150},
        {name = "Potion", price = 50}
    }
	
	-- At the start of the game or when loading a save, create quest instances
	for _, quest in ipairs(quests_table) do
		table.insert(quests, quest)
	end

	lootManager = LootManager:new()
	-- Register a handler for the 'enemyDeath' event
	enemies.enemyDeathEvent:subscribe(function(enemy)
		lootManager:generate(enemy.x, enemy.y)
	end)
end


function playState:update(dt)
	roundTimer = roundTimer + dt
	
	if player.health <= 0 then
		self.currentState = gameoverState
	end
	
	local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
	
	player:update(dt, camera)
	camera.x = player.x - screenWidth / 2
    camera.y = player.y - screenHeight / 2

    local mapWidthLimit = world.mapWidth * world.tileSize - screenWidth
    local mapHeightLimit = world.mapHeight * world.tileSize - screenHeight
	
	camera.x = math.max(0, math.min(camera.x, mapWidthLimit))
    camera.y = math.max(0, math.min(camera.y, mapHeightLimit))
	
	enemies:update(dt)
	for _, npc in ipairs(self.npcs) do
		npc:update(dt)
	end
	for _, lootDrop in ipairs(lootManager.lootDrops) do
        lootDrop:update(dt)
    end
		
	-- During game updates, check whether any quests can be assigned or completed
	for _, quest in ipairs(quests) do
		if quest.status == "Not Assigned" and quest:canAssign(player) then
			quest:assign(player)
		elseif quest.status == "Assigned" and quest:canComplete(player) then
			quest:complete(player)
		end
	end

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
	for _, npc in ipairs(self.npcs) do
        npc:draw() -- This calls the draw function of each NPC
		if npc.isShopOpen then  -- add this condition
			ui:drawShop(npc, shopItems)
		end
    end

	for _, lootDrop in ipairs(lootManager.lootDrops) do
        lootDrop:draw()
    end
	love.graphics.pop()
	ui:drawInGameUI(player, roundTimer)
	ui:drawHealthBar(player)

end

return playState