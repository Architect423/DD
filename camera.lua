--camera.lua

camera = {}
camera.x = 0
camera.y = 0

function camera:set(x, y)
    self.x = x
    self.y = y
end

function camera:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

return camera