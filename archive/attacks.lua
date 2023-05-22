-- attacks.lua
local Attack = require('attacks.Attack')
local visual_effects = require('visual_effects')
local projectiles = require('projectiles')

local attacks = {
    axeSwing = Attack:new{
        cooldown = 2,
        range = 200,
        damage = 20,
        targetMethod = 'polygon',
        effect = function(self, attacker, x, y)
            local enemiesInRange = self:findTargets(attacker, enemies.list)
            visual_effects:create('axeSwing', x, y, { timer = 0.2, range = self.range, hit = true }, x, y)
            for _, enemy in ipairs(enemiesInRange) do
                enemy:takeDamage(self.damage)
            end
        end,
    },
    lightningStrike = Attack:new{
        cooldown = 2,
        range = 200,
        damage = 20,
        chainRadius = 200,
        targetMethod = 'collision',
        effect = function(self, attacker, x, y)
            local hitEnemy = self:findTargets(attacker, enemies.list)
            if hitEnemy then
                hitEnemy:takeDamage(self.damage)
                visual_effects:create('lightningStrike', hitEnemy.x, hitEnemy.y, { timer = 0.2, range = self.range, hit = true }, x, y)
                -- Now, find nearby enemies using a polygon method
                self.targetMethod = 'polygon'
                local otherEnemiesInRange = self:findTargets(hitEnemy, enemies.list)
                for _, otherEnemy in ipairs(otherEnemiesInRange) do
                    if otherEnemy ~= hitEnemy then
                        otherEnemy:takeDamage(self.damage)
                        visual_effects:create('lightningStrikeLine', hitEnemy.x, hitEnemy.y, { targetX = otherEnemy.x, targetY = otherEnemy.y }, x, y)
                    end
                end
            end
        end
    },
    arrowShoot = Attack:new{
        cooldown = 1,  -- Cooldown in seconds
        range = 500,  -- Travel range of the arrow
        damage = 10,  -- Damage done by the attack
        projectileSpeed = 300,  -- Speed of the projectile
        effect = function(self, attacker, x, y)
            local dirX, dirY = (love.mouse.getX() + camera.x) - x, (love.mouse.getY() + camera.y) - y
            local length = math.sqrt(dirX * dirX + dirY * dirY)
            dirX, dirY = dirX / length, dirY / length  -- normalize the direction vector
            -- Create a new projectile
            projectiles:create('arrowShoot', x, y, dirX, dirY, self.range, self.damage, self.projectileSpeed)
            visual_effects:create('arrowShoot', x, y, { dirX = dirX, dirY = dirY, speed = self.projectileSpeed })
        end,
    },

    -- The same goes for other attacks...
}

return attacks
