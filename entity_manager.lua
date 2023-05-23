--entity_manager.lua
local Player = require('player')
local enemies = require('enemies')
local NPC = require('NPC')
local Projectile = require('components.projectile')
local CollisionComponent = require('attacks.collision_component')
local EntityManager = {}

function EntityManager:load(world)
    self.entities = {}

    -- create the player
    local player = Player:new() 
    self.player = player  -- store the player separately
    table.insert(self.entities, player)

    -- create the enemies
    enemies:load()
	self.enemies = {}
    for _, enemySpawnPoint in ipairs(world.enemySpawnPoints) do
        local enemy = enemies:spawn(enemySpawnPoint.x, enemySpawnPoint.y)
        table.insert(self.entities, enemy)
		table.insert(self.enemies, enemy)
    end

    -- create the npcs
    self.npcs = {}
    for _, npcSpawnPoint in ipairs(world.npcSpawnPoints) do
        local npc = NPC:new(npcSpawnPoint.x, npcSpawnPoint.y, love.graphics.newImage("npc.png"))
        table.insert(self.entities, npc)
        table.insert(self.npcs, npc)
    end
	
	 -- Create a new CollisionComponent instance
    self.collisionComponent = CollisionComponent:new(100, 100)
    return self
end

function EntityManager:getPlayer()
    return self.player
end

function EntityManager:getEnemies()
    return self.enemies
end

function EntityManager:getEntities()
    return self.entities
end

function EntityManager:getNPCs()
    return self.npcs
end

function EntityManager:update(dt)
	---ONLY DO IF PROJECTILES EXIST IN Projectile.projectiles
	for _, proj in ipairs(Projectile.projectiles) do
		local enemies = self:getEnemies()
		local attackData = {
			attacker = proj,
			targets = enemies
		}
		local hitTargets = self.collisionComponent:execute(attackData)
		for _, target in ipairs(hitTargets) do
			print(target)
		end
		for _, proj in ipairs(Projectile.projectiles) do
			proj:update(dt, hitTargets)
		end
	end
	
	
end

function EntityManager:draw()
	for _, proj in ipairs(Projectile.projectiles) do
		proj:draw()
	end
end

return EntityManager
