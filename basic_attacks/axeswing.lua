local axeswing = {}
axeswing.swings = {}

function axeswing:swing(x, y, range)
    table.insert(self.swings, {x = x, y = y, life = 0.2, range = range})  -- life in seconds
    -- Handle logic for dealing damage with axe swing here
end

function axeswing:update(dt, x, y)
    for i = #self.swings, 1, -1 do
        local swing = self.swings[i]
        swing.life = swing.life - dt
        if swing.life <= 0 then
            table.remove(self.swings, i)
        end
    end
end

function axeswing:draw()
    for _, swing in ipairs(self.swings) do
        love.graphics.setColor(1, 1, 1, swing.life * 5)  -- The *5 makes the swing fade out quickly
        love.graphics.circle('line', swing.x, swing.y, swing.range)
    end
end


return axeswing
