-- world.lua
local world = {}
local sti = require "sti"

world.tileSize = 16
world.mapWidth = 200  -- Adjust to your desired size
world.mapHeight = 200  -- Adjust to your desired size

world.map = {}

function world:load()
	self.map = sti("map1.lua")
end

function world:draw()
	self.map:draw(-camera.x, -camera.y)
end


return world