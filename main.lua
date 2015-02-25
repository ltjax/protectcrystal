local class = require "middleclass"
local Vector = require "vector"

local objectList={}

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

local Bullet = class "Bullet"

function Bullet:initialize(x, y, dx, dy)
  self.position = {x=x, y=y}
  self.direction = {x=dx, y=dy}
  self.time = 1.0
end

function Bullet:update(dt)
  self.position = Vector.add(Vector.scale(self.direction, dt), self.position)
  --self.time = self.time - dt
  
    return true
end

function Bullet:draw()
  love.graphics.setColor(255, 50, 0, 255)
  love.graphics.circle("fill", self.position.x, self.position.y, 12, 8)
end

local Player = class "Player"

function Player:initialize(x, y, keys)
  self.image = love.graphics.newImage("data/man.png")
  self.imageWidth = self.image:getWidth()
  self.imageHeight = self.image:getHeight()
  self.position = {x=x, y=y}
  self.keys = keys
  self.shootDelay=0.0
end

function Player:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(self.image, self.position.x-self.imageWidth/2, self.position.y-self.imageHeight) 
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
    
  local speed=dt*100
  self.position = {x=self.position.x+dx*speed, y=self.position.y+dy*speed}
end

function Player:update(dt)
  self:updateInput(dt)
  
  
  self.shootDelay = math.max(0.0, self.shootDelay-dt)
    
  if self.shooting and self.shootDelay <= 0.0 then
    local bulletSpeed=1300
    local bullet=Bullet:new(self.position.x, self.position.y-20, self.direction.x*bulletSpeed, self.direction.y*bulletSpeed)
    table.insert(objectList, bullet)
    self.shootDelay = 0.2
  end
  
  return true
end

  


function love.load(arg)
  
  -- Enable debugging
  if arg[#arg] == "-debug" then
    require("mobdebug").start()
  end

  
  table.insert(objectList, Crystal:new())
  table.insert(objectList, Player:new(-100, 50, {'w', 'a', 's', 'd', 'up', 'left', 'down', 'right'}))
  table.insert(objectList, Player:new(100, 50))
end


function love.draw()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  love.graphics.translate(width/2, height/2)
  
  love.graphics.setBackgroundColor({128,128,128,255})
  
  for i=1,#objectList do
    objectList[i]:draw()
  end
end

function love.update(dt) 
  
  local tempObjectList=objectList
  objectList={}
  
  for i=1,#tempObjectList do
    local currentObject=tempObjectList[i]
    if currentObject.update then
      if currentObject:update(dt) then
        table.insert(objectList, currentObject)
      end
    else
      table.insert(objectList, currentObject)
    end
  end

end
