local class = require "middleclass"

local Crystal = class "Crystal"

function Crystal:initialize()
  self.image = love.graphics.newImage("data/crystal.png")
  self.imageWidth = self.image:getWidth()
  self.imageHeight = self.image:getHeight()
end

function Crystal:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(self.image, -self.imageWidth/2, -self.imageHeight)    
end

return Crystal
