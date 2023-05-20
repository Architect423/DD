-- world.lua
local world = {}
local sti = require "sti"

world.tileSize = 16
world.mapWidth = 200  -- Adjust to your desired size
world.mapHeight = 200  -- Adjust to your desired size
world.townAreas = {}
world.walls = {}
world.map = {}
world.npcSpawnPoints = {}
world.enemySpawnPoints = {}  -- Changed from world.enemies


function world:load()
	self.map = sti("map/running_file/map1.lua")
	
	--Load town
	local townLayer = self.map.layers["town"]
	if townLayer then
		for _, object in ipairs(townLayer.objects) do
			table.insert(self.townAreas, { x = object.x, y = object.y, width = object.width, height = object.height })
		end
	end
	
	-- Load walls
    local wallLayer = self.map.layers["Walls"]
    if wallLayer then
        for _, object in ipairs(wallLayer.objects) do
            table.insert(self.walls, { x = object.x, y = object.y, width = object.width, height = object.height })
        end
    end
	
	-- Load enemies
    local enemyLayer = self.map.layers["Enemies"]
    if enemyLayer then
        for _, object in ipairs(enemyLayer.objects) do
            local spawnPoint = {x = object.x, y = object.y, type = object.type or "default"}
            table.insert(self.enemySpawnPoints, spawnPoint)
        end
    end
	
	-- Load NPCs
    local npcsLayer = self.map.layers["NPCs"]
    if npcsLayer then
        for _, object in ipairs(npcsLayer.objects) do
            local npcData = {x = object.x, y = object.y, type = object.type or "default", properties = object.properties}
            table.insert(self.npcSpawnPoints, npcData)
        end
    end

end

function world:draw()
	self.map:draw(-camera.x, -camera.y)
end


return world