-- main.lua
love.graphics.setDefaultFilter('nearest', 'nearest')

local gamestate = require('gamestate')

function love.load()
    gamestate:load()
end

function love.update(dt)
	gamestate:update(dt)
end

function love.draw()
    gamestate:draw()
end

function love.keypressed(key)
    if key == 'return' then
        if gamestate.currentState == 'menu' then
            gamestate:changeState('classSelect')
        elseif gamestate.currentState == 'gameover' then
            gamestate:changeState('classSelect')
        elseif gamestate.currentState == 'classSelect' then
            gamestate:changeState('play')
        end
    elseif key == 'escape' then
        if gamestate.currentState == 'play' or gamestate.currentState == 'gameover' then
            gamestate:changeState('menu')
        else
            love.event.quit()
        end
    elseif gamestate.currentState == 'classSelect' then
        if key == 'right' then
            gamestate:selectNextClass()
        elseif key == 'left' then
            gamestate:selectPreviousClass()
        elseif key == 'up' then
            gamestate:confirmClassSelection()
        end
    end
end



