local gamestate = {}

-- Require the new state modules
local playState = require('states.playState')
local menuState = require('states.menuState')
local classSelectState = require('states.classSelectState')
local gameoverState = require('states.gameoverState')

gamestate.menuState = menuState
gamestate.classSelectState = classSelectState
gamestate.playState = playState
gamestate.gameoverState = gameoverState

function gamestate:load()
    menuState:load()
    classSelectState:load()
    playState:load()
    gameoverState:load()
    self.currentState = self.menuState
end

function gamestate:update(dt)
    self.currentState:update(dt, self)
end

function gamestate:draw()
    self.currentState:draw()
end

function gamestate:changeState(newState)
    self.currentState = newState
end

return gamestate
