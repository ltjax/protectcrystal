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
  self.body = love.physics.newBody(world, x, y, "dynamic") 
  self.shape = love.physics.newCircleShape(32)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.doUpdate = true
  self.type ="Spider"
end

function Spider:setDoUpdate (value)
  self.doUpdate = value
end

function Spider:draw()
  pos = {x=self.body:getX(), y=self.body:getY()}
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.circle("line", pos.x, pos.y, 32, 16 )
  love.graphics.draw(self.image, pos.x - self.imageWidth, pos.y - self.imageHeight) 
end

function Spider:update(dt)  
  if self.doUpdate then
    
    self.time = self.time + dt           
    
    -- correct target direction after possible collision position
    pos = {x=self.body:getX(), y=self.body:getY()}
    self.direction = Vector.normalize({x=-pos.x, y=-pos.y})
    pos = Vector.add(Vector.scale(self.direction, dt * 0.1), pos)      
    self.body:setPosition (pos.x, pos.y)
    self.body:setLinearVelocity(self.direction.x * 100, self.direction.y * 100)
  else
    self.body:setLinearVelocity(0,0)
  end
  return true
end

return Spider
