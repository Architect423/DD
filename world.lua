-- world.lua
local world = {}

world.tileSize = 32
world.mapWidth = 200  -- Adjust to your desired size
world.mapHeight = 200  -- Adjust to your desired size

-- Different types of tiles, using RGB color codes
-- Different types of tiles, using RGB color codes
world.tiles = {
    {0, 1, 0},  -- 1, green for grass
    {0.5, 0.35, 0.05},  -- 2, brown for dirt
    {0, 0, 1},  -- 3, blue for water
    {0.75, 0.75, 0.75}  -- 4, light gray for gravel
    -- Add more tiles as necessary
}


world.map = {}

function world:load()
    -- Initialize the map as all grass
    for x = 1, self.mapWidth do
        self.map[x] = {}
        for y = 1, self.mapHeight do
            self.map[x][y] = 1  -- 1 represents grass
        end
    end

    -- Add some patches of dirt
    for i = 1, 100 do
        local x = love.math.random(self.mapWidth)
        local y = love.math.random(self.mapHeight)
        self.map[x][y] = 2  -- 2 represents dirt
    end

    -- Add some water
    for i = 1, 50 do
        local x = love.math.random(self.mapWidth)
        local y = love.math.random(self.mapHeight)
        self.map[x][y] = 3  -- 3 represents water
    end
	
	-- Place a 3x3 square of gravel in the center of the map
	local centerX = math.floor(self.mapWidth / 2)
	local centerY = math.floor(self.mapHeight / 2)
	for dx = -5, 5 do
		for dy = -5, 5 do
			self.map[centerX + dx][centerY + dy] = 4  -- 4 represents gravel
		end
end

end

function world:draw()
    for x = 1, self.mapWidth do
        for y = 1, self.mapHeight do
            local tile = self.tiles[self.map[x][y]]
            if tile then
                love.graphics.setColor(tile)
                love.graphics.rectangle('fill', (x - 1) * self.tileSize, (y - 1) * self.tileSize, self.tileSize, self.tileSize)
            end
        end
    end
    -- Reset color to white for other draws
    love.graphics.setColor(1, 1, 1)
end

return world
