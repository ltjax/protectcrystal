local class = require "middleclass"
local Vector = require "vector"
local Timer = require "timer"
local Spider = class "Spider"

function Spider:initialize(world, x, y)
  self.image = love.graphics.newImage("data/spider.png")
  self.imageWidth = self.image:getWidth()
  self.imageHeight = self.image:getHeight()
  self.position = {x=x, y=y}
  self.direction = {x=-x, y=-y}
  self.time = 0.0
  self.shape = world.collider:addCircle(x, y, 32)
  self.shape.object = self
  self.maxHealth = 3.0
  self.health = self.maxHealth
  self.timer = Timer.new()
  self.attacking = false
  self.world = world
end

function Spider:receiveDamage(damage)
  self.health = self.health - damage
end

function Spider:draw()
  local x, y = self.shape:center()
  
  love.graphics.setColor(255, 255, 255, 255)
  self.shape:draw("line")
  love.graphics.draw(self.image, x - self.imageWidth*0.5, y - self.imageHeight*0.5) 
  
  love.graphics.rectangle("line", x - self.imageWidth*0.5, y - self.imageHeight*0.5 - 10, self.imageWidth, 8)
  love.graphics.rectangle("fill", x - self.imageWidth*0.5+1, y - self.imageHeight*0.5 - 9, (self.imageWidth-2)*self.health/self.maxHealth, 6)
end

function Spider:update(dt)
  self.timer.update(dt)
  self.time = self.time + dt           
  
  -- correct target direction after possible collision position
  local x,y = self.shape:center()
  
  local distance = Vector.length({x=-x, y=-y})
  if distance < 70 then
    if not self.attacking then
      self.attacking = true
      self.timer.addPeriodic(1.2, function() self.world.crystal:receiveDamage(1.0) end)
    end
  else
    
    self.direction = Vector.normalize({x=-x, y=-y})
    local delta = Vector.scale(self.direction, dt * 50)
    self.shape:move(delta.x, delta.y)
  end

  if self.health > 0.0 then
    return true
  else
    self.world.collider:remove(self.shape)
    return false
  end
  
end

return Spider
