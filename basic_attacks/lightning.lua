local lightning = {}
lightning.strikes = {}

function lightning:update(dt, x, y)
    for i = #self.strikes, 1, -1 do
        local strike = self.strikes[i]
        strike.life = strike.life - dt
        if strike.life <= 0 then
            table.remove(self.strikes, i)
        end
    end
end

function lightning:draw(x, y)
    for i, strike in ipairs(self.strikes) do
        love.graphics.setColor(0, 0, 1, strike.life * 5)  -- The *5 makes the strike fade out quickly
        if i < #self.strikes then
            local nextStrike = self.strikes[i + 1]
            love.graphics.line(strike.x, strike.y, nextStrike.x, nextStrike.y)
        end
    end
end

return lightning
