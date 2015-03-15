local Gamestate = require "gamestate"
local logoState = {}

function logoState:init()
  self.image = love.graphics.newImage("data/logo.png")
end

function logoState:enter()
  love.graphics.setBackgroundColor(0, 0, 0, 255)
end


function logoState:draw()
  local windowWidth = love.window.getWidth()
  local windowHeight = love.window.getHeight()
  local imageWidth = self.image:getWidth()
  local imageHeight = self.image:getHeight()
  
  love.graphics.draw(self.image, (windowWidth-imageWidth)/2, (windowHeight-imageHeight)/2)
end

function logoState:keypressed()
  Gamestate.switch(require "ingamestate")
end

function logoState:joystickpressed()
  Gamestate.switch(require "ingamestate")
end


return logoState
