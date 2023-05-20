-- enemy.lua
local collisions = require('collisions')
local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, size, health, damage, speed, animations)
    local enemy = {
        x = x,
        y = y,
        size = size,
        health = health,
        damage = damage,
        speed = speed,
        state = 'idle',
        aggroRange = 200,
        deaggroRange = 500,
        primeLocation = {x = x, y = y},
        animations = animations or {},  -- If animations parameter is nil, use empty table
        takeDamage = function(self, amount)
            self.health = self.health - amount
        end,
        checkCollision = function(self, other)
            return collisions.checkRectangleCollision(
                self.x, self.y, self.size, self.size, 
                other.x, other.y, other.size, other.size
            )
        end
    }
    enemy.current_animation = enemy.animations.walking
    setmetatable(enemy, Enemy)
    return enemy
end

return Enemy
