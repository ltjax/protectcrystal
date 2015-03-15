local class = require "middleclass"
local Vector = require "vector"
local Bullet = require "bullet"
local Player = class "Player"

function Player:initialize(world, x, y, inputHandler)
  self.image = love.graphics.newImage("data/man.png")
  self.imageWidth = self.image:getWidth()
  self.imageHeight = self.image:getHeight()
  self.inputHandler = inputHandler
  self.shootDelay=0.0
  self.shape = world.collider:addCircle(x, y, 32)
  self.shape.object = self
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
  
  -- Try mouse controls
  if sx==0 and sy==0 and love.mouse.isDown("l") then
    local mx, my = love.mouse.getX(), love.mouse.getY()
    mx, my = self.world.camera:screenToWorld(mx, my)
    local x, y = self:getPosition()
    local delta = {x=mx-x, y=my-y} 
    local l = Vector.length(delta)
    if l > 1 then
      sx, sy = delta.x/l, delta.y/l
    end
  end

  if sx~=0 or sy~=0 then
    self.shooting = true
    self.direction = Vector.normalize {x=sx, y=sy} 
  else
    self.shooting = false
  end
  
  if dx~=0 or dy~=0 then
    local speed=300*dt
    local move = Vector.normalize {x=dx, y=dy} 
    self.shape:move(move.x*speed, move.y*speed)
  end
end

function Player:getPosition()
  return self.shape:center()
end

function Player:update(dt, objectList)
  self:updateInput(dt)
  
  if self.inputHandler then
    local px, py = self.shape:center()
    self.inputHandler:update(px, py, self.world.camera)
    
    -- Do movement
    local move = self.inputHandler.move
    if move then
      local speed=300*dt
      self.shape:move(move.x*speed, move.y*speed)
    end
    
    -- Do shooting
    if self.inputHandler.shooting and self.shootDelay <= 0.0 then
      local bulletSpeed=1300
      local x, y=self.shape:center()
      local bullet=Bullet:new(self.world, x, y-20, self.inputHandler.direction.x*bulletSpeed, self.inputHandler.direction.y*bulletSpeed)
      table.insert(objectList, bullet)
      self.shootDelay = 0.2
    end  
  end
    
  self.shootDelay = math.max(0.0, self.shootDelay-dt)    
  
  return true
end

return Player
