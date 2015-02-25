local class = require "middleclass"
local Spider = class "Spider"

function Spider:initialize(x, y, crystalX, crystalY)
  self.image = love.graphics.newImage("data/spider.png")
  self.imageWidth = self.image:getWidth()
  self.imageHeight = self.image:getHeight()
  self.position = {x=x, y=y}
  self.direction = {x=-x, y=-y}
  self.time = 0.0
end

function Spider:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(self.image, self.position.x-self.imageWidth/2, self.position.y-self.imageHeight) 
end

function Spider:update(dt)
  self.time = self.time + dt
  self.position = self.position + Vector.add(Vector.scale(self.direction, dt), self.position)
  return true
end

return Spider
