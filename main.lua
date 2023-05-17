-- main.lua
love.graphics.setDefaultFilter('nearest', 'nearest')

local world = require('world')
local player = require('player')
local enemies = require('enemies')
local bullets = require('basic_attacks.bullets')
local gamestate = require('gamestate')

function love.load()
    gamestate:load()
end

local keyDelay = 0.2  -- Adjust this value to set the desired delay in seconds
local keyTimer = 0
local keyPressed = false

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



