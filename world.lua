-- world.lua
local world = {}

function world:load()
    self.tileSize = 32
    self.mapWidth = love.graphics.getWidth() / self.tileSize
    self.mapHeight = love.graphics.getHeight() / self.tileSize
    self.map = {}
    
    for x = 1, self.mapWidth do
        self.map[x] = {}
        for y = 1, self.mapHeight do
            self.map[x][y] = 1
        end
    end
end

function world:draw()
    for x = 1, self.mapWidth do
        for y = 1, self.mapHeight do
            if self.map[x][y] == 1 then
                love.graphics.rectangle('line', (x - 1) * self.tileSize, (y - 1) * self.tileSize, self.tileSize, self.tileSize)
            end
        end
    end
end

return world
