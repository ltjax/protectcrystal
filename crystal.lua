local class = require "middleclass"

local Crystal = class "Crystal"

function Crystal:initialize(world)
  self.image = love.graphics.newImage("data/crystal.png")
  self.imageWidth = self.image:getWidth()
  self.imageHeight = self.image:getHeight()
  self.shape = world.collider:addCircle(0, 0, 52)
  self.type = "Crystal"  
  self.maxHealth = 30
  self.health = self.maxHealth
  self.position = {x=0, y=0}
end

function Crystal:receiveDamage(damage)
  self.health = self.health - damage
  if self.health <= 0 and self.onDestroy then
    self.onDestroy()
  end  
end

function Crystal:draw()
  local x, y = self.shape:center()
  love.graphics.setColor(255, 255, 255, 255)
  self.shape:draw("line")
  love.graphics.draw(self.image, -self.imageWidth/2, -self.imageHeight/1.25) 
  
  love.graphics.rectangle("line", - self.imageWidth*0.5, y - self.imageHeight*0.5 - 10, self.imageWidth, 8)
  love.graphics.rectangle("fill", - self.imageWidth*0.5+1, y - self.imageHeight*0.5 - 9, (self.imageWidth-2)*self.health/self.maxHealth, 6)
end

return Crystal
