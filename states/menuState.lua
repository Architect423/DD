-- menuState.lua

local menuState = {}
local ui = require('ui')

local gamestateRef -- Declare the gamestate reference variable

function menuState:load(gamestate)
    gamestateRef = gamestate -- Store the gamestate reference
end

function menuState:update(dt, gamestate)
    -- 'menu' specific update logic
    if love.keyboard.isDown('return') then
        gamestate:changeState(gamestate.classSelectState)
    end
end

function menuState:draw()
    -- 'menu' specific draw logic
    ui:drawMenu()
end

return menuState
