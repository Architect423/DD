-- projectile.lua


Projectile = {}
Projectile.__index = Projectile


-- List of active projectiles
Projectile.projectiles = {}


function Projectile.new(attacker, speed, direction, sprite, targets)
    local self = setmetatable({}, Projectile)
    self.x = attacker.x
    self.y = attacker.y
    self.speed = speed
    self.direction = direction
    self.sprite = sprite
	self.targets = targets
    -- When a projectile is created, add it to the list
    table.insert(Projectile.projectiles, self)
    return self
end

function Projectile:remove()
    for i, projectile in ipairs(Projectile.projectiles) do
        if projectile == self then
            table.remove(Projectile.projectiles, i)
            break
        end
    end
end


function Projectile:update(dt, hitTargets)
    -- update the projectile's position based on its speed and direction
    self.x = self.x + self.direction.x * self.speed * dt
    self.y = self.y + self.direction.y * self.speed * dt

    -- If the projectile hits a target, remove the projectile
    if #hitTargets > 0 then
		print('hit')
        self:remove()
    end
	
end

function Projectile:draw()
    -- draw the projectile's sprite at its current position
    love.graphics.draw(self.sprite, self.x, self.y)
	
end

return Projectile
