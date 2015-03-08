local class = require "middleclass"
local Vector = require "vector"
local Bullet = require "bullet"
local Player = class "Player"

function Player:initialize(world, x, y, keys)
  self.image = love.graphics.newImage("data/man.png")
  self.imageWidth = self.image:getWidth()
  self.imageHeight = self.image:getHeight()
  self.keys = keys
  self.shootDelay=0.0
  self.shape = world:addCircle(x, y, 32)
  self.world = world
end

function Player:draw()
  love.graphics.setColor(255, 255, 255, 255)
  local x, y = self.shape:center()
  
  love.graphics.draw(self.image, x-self.imageWidth/2, y-self.imageHeight/2) 
  
  self.shape:draw("line") 
  
end

function Player:updateInput(dt)
  if not self.keys then
    return
  end
  
  local dx=0
  local dy=0
  
  if love.keyboard.isDown(self.keys[1]) then
    dy = -1
  end
  if love.keyboard.isDown(self.keys[2]) then
    dx = -1
  end
  if love.keyboard.isDown(self.keys[3]) then
    dy = 1
  end
  if love.keyboard.isDown(self.keys[4]) then
    dx = 1
  end
  
  local sx=0
  local sy=0
  
  if love.keyboard.isDown(self.keys[5]) then
    sy = -1
  end
  if love.keyboard.isDown(self.keys[6]) then
    sx = -1
  end
  if love.keyboard.isDown(self.keys[7]) then
    sy = 1
  end
  if love.keyboard.isDown(self.keys[8]) then
    sx = 1
  end
  
  if sx~=0 or sy~=0 then
    self.shooting = true
    self.direction = Vector.normalize {x=sx, y=sy} 
  else
    self.shooting = false
  end
  
  local speed=300*dt
  self.shape:move(dx*speed, dy*speed)
end

function Player:getPosition()
  return self.shape:center()
end

function Player:update(dt, objectList)
  self:updateInput(dt)
  
  
  self.shootDelay = math.max(0.0, self.shootDelay-dt)
    
  if self.shooting and self.shootDelay <= 0.0 then
    local bulletSpeed=1300
    local x, y=self.shape:center()
    local bullet=Bullet:new(self.world, x, y-20, self.direction.x*bulletSpeed, self.direction.y*bulletSpeed)
    table.insert(objectList, bullet)
    self.shootDelay = 0.2
  end
  
  return true
end

return Player
