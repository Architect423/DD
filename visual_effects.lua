-- visual_effects.lua
local visual_effects = {}
visual_effects.list = {}
local projectiles = require 'projectiles'


-- add two parameters (px, py) to represent player's position
function visual_effects:create(effectType, x, y, params, px, py)
    local effect = {type = effectType, x = x, y = y, timer = params.timer or 0.2, px = px, py = py}  -- add px, py to the effect object
    if effectType == 'axeSwing' or effectType == 'lightningStrike' or effectType == 'bulletShoot' or effectType == 'arcRange' then
        effect.range = params.range
    elseif effectType == 'lightningStrikeLine' then
        effect.targetX = params.targetX
        effect.targetY = params.targetY
    end
    table.insert(self.list, effect)
end


function visual_effects:update(dt)
    for i = #self.list, 1, -1 do
        local effect = self.list[i]
        effect.timer = effect.timer - dt

        if effect.timer <= 0 then
            table.remove(self.list, i)
        end
    end
end

function visual_effects:draw()
    for _, effect in ipairs(self.list) do
        if effect.type == 'axeSwing' then
            love.graphics.setColor(1, 1, 1, 0.7)
            love.graphics.circle('line', effect.x, effect.y, effect.range)
            love.graphics.setColor(1, 1, 1)
		elseif effect.type == 'lightningStrike' then
			love.graphics.setColor(1, 1, 0, 0.7)
			local dirX, dirY = effect.px - effect.x, effect.py - effect.y
			local length = math.sqrt(dirX * dirX + dirY * dirY)
			dirX, dirY = dirX / length, dirY / length  -- normalize
			local endX, endY = effect.x + dirX * (effect.hit and length or effect.range), effect.y + dirY * (effect.hit and length or effect.range)
			love.graphics.line(effect.x, effect.y, effect.px, effect.py)
			love.graphics.setColor(1, 1, 1)

		elseif effect.type == 'lightningStrikeLine' then
			
            love.graphics.setColor(1, 1, 0, 0.7)
            love.graphics.line(effect.x, effect.y, effect.targetX, effect.targetY)
            love.graphics.setColor(1, 1, 1)
		elseif effect.type == 'arcRange' then
            love.graphics.setColor(1, 0, 0, 0.5)  -- draw in half-transparent red
            love.graphics.circle('line', effect.x, effect.y, effect.range)
            love.graphics.setColor(1, 1, 1)
        end
    end
	
	for _, projectile in ipairs(projectiles.list) do
        if projectile.type == 'arrowShoot' then
            love.graphics.setColor(1, 1, 0)  -- Yellow color
            love.graphics.circle('fill', projectile.x, projectile.y, 5)  -- Draw a small circle at the projectile's position
        end
    end
end

return visual_effects
