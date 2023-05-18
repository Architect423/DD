-- attacks.lua
local visual_effects = require('visual_effects')

local attacks = {
    axeSwing = {
        cooldown = 2,  -- Cooldown in seconds
		range = 200,  -- Attack range
		damage = 20,  -- Damage done by the attack
        effect = function(self, enemies, x, y)
			visual_effects:create('axeSwing', x, y, { timer = 0.2, range = self.range, hit = true }, x, y)			
            for _, enemy in ipairs(enemies.list) do
                local dx = enemy.x - x
                local dy = enemy.y - y
                local distance = math.sqrt(dx * dx + dy * dy)

                -- Only affect enemies within the attack range
                if distance <= self.range then
                    enemy:takeDamage(self.damage)
                end
            end
        end,
    },

    lightningStrike = {
		cooldown = 2,  -- Cooldown in seconds
		range = 200,  -- Attack range
		damage = 20,  -- Damage done by the attack
		chainRadius = 200,
		effect = function(self, enemies, x, y)
			local hitEnemy = nil
			local minDistance = self.range
			-- Calculate line end point
			local dirX, dirY = love.mouse.getX() - x, love.mouse.getY() - y
			local length = math.sqrt(dirX * dirX + dirY * dirY)
			dirX, dirY = dirX / length, dirY / length  -- normalize the direction vector
			local endX, endY = x + dirX * self.range, y + dirY * self.range
			-- Find the enemy that is closest to the player within the attack range
			for _, enemy in ipairs(enemies.list) do
				local box = {
					left = enemy.x - enemies.size / 2,
					right = enemy.x + enemies.size / 2,
					top = enemy.y - enemies.size / 2,
					bottom = enemy.y + enemies.size / 2,
				}
				if lineBoxCollision(x, y, endX, endY, box) then
					local dx = enemy.x - x
					local dy = enemy.y - y
					local distance = math.sqrt(dx * dx + dy * dy)
					if distance < minDistance then
						minDistance = distance
						hitEnemy = enemy
					end
				end
			end

			-- Damage the hit enemy and chain to nearby enemies
			if hitEnemy then
				print('U STRUCK')
				hitEnemy:takeDamage(self.damage)
				visual_effects:create('lightningStrike', hitEnemy.x, hitEnemy.y, { timer = 0.2, range = self.range, hit = true }, x, y)			
				visual_effects:create('arcRange', hitEnemy.x, hitEnemy.y, { timer = 0.2, range = self.chainRadius }, x, y)  -- pass x and y (player position)
				for _, otherEnemy in ipairs(enemies.list) do
					if otherEnemy ~= hitEnemy then
						local dx = otherEnemy.x - hitEnemy.x
						local dy = otherEnemy.y - hitEnemy.y
						local distance = math.sqrt(dx * dx + dy * dy)
						print("Distance to other enemy: " .. distance)
						-- Damage other enemies within the chain radius
						if distance <= self.chainRadius then
							local otherEnemyHit = true
							otherEnemy:takeDamage(self.damage)
							visual_effects:create('lightningStrikeLine', hitEnemy.x, hitEnemy.y, { targetX = otherEnemy.x, targetY = otherEnemy.y }, x, y)  -- pass x and y (player position)
						end
					end
				end
			else
				visual_effects:create('lightningStrike', endX, endY, { timer = 0.2, range = self.range, hit = false }, x, y)
		
			end
		end,
	},



    arrowShoot = {

    }

    -- ...
}

function lineBoxCollision(x1, y1, x2, y2, box)
    -- Check if line segment is completely to the left, right, above, or below the box
    if (x1 < box.left and x2 < box.left) or
        (x1 > box.right and x2 > box.right) or
        (y1 < box.top and y2 < box.top) or
        (y1 > box.bottom and y2 > box.bottom) then
        return false
    end
    -- Calculate line parameters
    local m = (y2 - y1) / (x2 - x1)
    local b = y1 - m * x1
    -- Check for intersection with each side of the box
    local y = m * box.left + b
    if y >= box.top and y <= box.bottom then
        return true
    end
    y = m * box.right + b
    if y >= box.top and y <= box.bottom then
        return true
    end
    local x = (box.top - b) / m
    if x >= box.left and x <= box.right then
        return true
    end
    x = (box.bottom - b) / m
    if x >= box.left and x <= box.right then
        return true
    end
    -- No intersection
    return false
end

return attacks
