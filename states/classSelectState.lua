-- classSelectState.lua

local classSelectState = {}
local ui = require('ui')

-- List of classes
local classes = {
    {name = 'Wizard', color = {0, 0, 1}, basic_attack = 'lightningStrike'},      -- Blue
    {name = 'Barbarian', color = {1, 0, 0}, basic_attack = 'axeSwing'},   -- Red
    {name = 'Ranger', color = {0, 1, 0}, basic_attack = 'arrowShoot'}       -- Green
}

local selectedClassIndex = 1

function classSelectState:load(gamestate, player)
  -- Any 'classSelect' specific load logic goes here.
  self.gamestate = gamestate
  self.player = player
end

local keyDelay = 0.2
local keyTimer = 0
local keyPressed = false

function classSelectState:update(dt, gamestate)
  keyTimer = keyTimer + dt

  if keyTimer >= keyDelay then
    if love.keyboard.isDown('right') then
      selectedClassIndex = (selectedClassIndex % #classes) + 1
      keyTimer = 0
      keyPressed = true
    end

    if love.keyboard.isDown('left') then
      selectedClassIndex = ((selectedClassIndex - 2 + #classes) % #classes) + 1
      keyTimer = 0
      keyPressed = true
    end

    if love.keyboard.isDown('up') then
		 local selectedClass = classes[selectedClassIndex]
		_G.player.class = selectedClass.name
		_G.player.color = selectedClass.color  -- Set the player color
		_G.player.currentAttack = selectedClass.basic_attack
		 gamestate:changeState(gamestate.playState)
		 print("Selected Class: " .. player.class)
		 print("Selected Class Color: " .. selectedClass.color[1] .. ", " .. selectedClass.color[2] .. ", " .. selectedClass.color[3])
    end
  end

  if not love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
    keyPressed = false
  end
end

function classSelectState:draw()
  ui:drawClassSelection(classes, selectedClassIndex)
end

return classSelectState
