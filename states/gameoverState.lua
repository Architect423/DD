--gameoverState.lua

local gameoverState = {}
local ui = require('ui')

function gameoverState:load()
  -- Any 'gameover' specific load logic goes here. This might include preparing
  -- final scores, game over messages or any other variables that this state will use.
end

function gameoverState:update(dt)
  -- 'gameover' specific update logic. This could include checking for player 
  -- input to restart the game or return to main menu, updating any animations, etc.
  -- You might use something like:
  -- if player pressed restart then gamestate:changeState(menuState) end
end

function gameoverState:draw()
  -- 'gameover' specific draw logic. This is where you would draw the gameover
  -- screen to the screen.
  ui:drawGameOver()
end

return gameoverState
