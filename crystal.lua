local class = require "middleclass"

local Crystal = class "Crystal"

function Crystal:initialize(world)
  self.image = love.graphics.newImage("data/crystal.png")
  self.imageWidth = self.image:getWidth()
  self.imageHeight = self.image:getHeight()
  self.body = love.physics.newBody(world, 0, 0, "static")
  self.shape = love.physics.newCircleShape(0, 0, 52)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)  
  self.type = "Crystal"  
end

function Crystal:draw()
  love.graphics.circle("line", self.body:getX(), self.body:getY(), 52, 16)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(self.image, -self.imageWidth/2, -self.imageHeight/1.25)    
end

return Crystal
