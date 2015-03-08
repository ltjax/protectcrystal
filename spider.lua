local class = require "middleclass"
local Vector = require "vector"
local Spider = class "Spider"

function Spider:initialize(x, y, world)
  self.image = love.graphics.newImage("data/spider.png")
  self.imageWidth = self.image:getWidth() * 0.5
  self.imageHeight = self.image:getHeight() * 0.5
  self.position = {x=x, y=y}
  self.direction = {x=-x, y=-y}
  self.time = 0.0
  self.shape = world:addCircle(x, y, 32)
end

function Spider:setDoUpdate (value)
  self.doUpdate = value
end

function Spider:draw()
  local x, y = self.shape:center()
  
  love.graphics.setColor(255, 255, 255, 255)
  self.shape:draw("line")
  love.graphics.draw(self.image, x - self.imageWidth, y - self.imageHeight) 
end

function Spider:update(dt)  
  if self.doUpdate then
    
    self.time = self.time + dt           
    
    -- correct target direction after possible collision position
    local x,y = self.shape:center()
    self.direction = Vector.normalize({x=-x, y=-y})
    local delta = Vector.scale(self.direction, dt * 0.1)
    self.shape.move(delta.x, delta.y)
  else
  end
  return true
end

return Spider
