local class = require "middleclass"

local Crystal = class "Crystal"

function Crystal:initialize(world)
  self.image = love.graphics.newImage("data/crystal.png")
  self.imageWidth = self.image:getWidth()
  self.imageHeight = self.image:getHeight()
  self.body = love.physics.newBody(world, 0, 0, "static")
  self.shape = love.physics.newCircleShape(26)
  self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Crystal:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(self.image, -self.imageWidth/2, -self.imageHeight)    
end

return Crystal
