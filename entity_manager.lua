--entity_manager.lua
local Player = require('player')
local enemies = require('enemies')
local NPC = require('NPC')
local Projectile = require('components.projectile')
local DamageComponent = require('attacks.damage_component')
local CollisionComponent = require('attacks.collision_component')
local AttackFactory = require('attacks.AttackFactory')
local EntityManager = {}

function EntityManager:load(world)
    self.entities = {}

    -- create the player
    local player = Player:new() 
    self.player = player  -- store the player separately
    table.insert(self.entities, player)
	player.attackEvent:listen(function(attackData)
        self:handlePlayerAttack(attackData)
    end)
	attackFactory = AttackFactory:new()
	player.arrowAttack = attackFactory:createArrowAttack()
    -- create the enemies
    enemies:load()
	self.enemies = {}
	player.attackData = {
        attacker = player,
        direction = direction,
        speed = speed,
        damage = damage,
        sprite = love.graphics.newImage('sprite.png'),
		targets = enemies.list
    }
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
	self.activeAttacks = {}
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

	for _, proj in ipairs(Projectile.projectiles) do
		proj:update(dt)
	end
	
	local mouseX, mouseY = love.mouse.getPosition()
		
	-- Convert from window coordinates to world coordinates
	mouseX = mouseX + camera.x
	mouseY = mouseY + camera.y
	local playerX, playerY = self.player.x, self.player.y

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
	
	for i = #self.activeAttacks, 1, -1 do
        local attack = self.activeAttacks[i]
        attack.currentComponent:execute(self.activeAttacks[i].attackData)
        if attack.currentComponent:isFinished() then
            if attack.currentComponent.nextComponent then
                print('changing components')
                attack.currentComponent = attack.currentComponent.nextComponent
            else
                -- No next component, remove the attack from active attacks
                print('attack finished')
                table.remove(self.activeAttacks, i)
            end
        end
    end
end

function EntityManager:draw()
	for _, proj in ipairs(Projectile.projectiles) do
		proj:draw()
	end
end

function EntityManager:handlePlayerAttack(attackData)

	local attackInstance = attackFactory:createArrowAttack()
	attackData.attacker = self.player
	attackInstance.attackData = attackData
	print(attackData.attacker.x)
    table.insert(self.activeAttacks, attackInstance)

end

return EntityManager
