local class = require "middleclass"
local Vector = require "vector"
local Timer = require "timer"
local Spider = class "Spider"

function Spider:initialize(world, x, y)
  self.image = love.graphics.newImage("data/spider_4.png")
  self.image:setFilter("nearest", "nearest")
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
  
  local tileSize=32
  self.tileSize=tileSize
  
  self.anim = {}
  local i=1
  for y=1,4 do
    self.anim[y]={}
    for x=1,6 do
      self.anim[y][x] = love.graphics.newQuad(
        (x-1)*tileSize, (y-1)*tileSize, tileSize, tileSize,
        self.imageWidth, self.imageHeight)
      
      i=i+1
    end
  end
  
  self.spriteFrame = 1
  self.spriteFrameTime = 0  
end

function Spider:receiveDamage(damage)
  self.health = self.health - damage
end

function Spider:draw()
  local x, y = self.shape:center()
  
  love.graphics.setColor(255, 255, 255, 255)
  --self.shape:draw("line")
  
  local spriteDirection=1 -- down
  if self.direction then
    local dx, dy = self.direction.x, self.direction.y
    if math.abs(dx) > math.abs(dy) then
      if dx < 0 then
        spriteDirection = 2 -- left
      else
        spriteDirection = 3 -- right
      end
    else
      if dy < 0 then
        spriteDirection = 4 -- up
      else
        spriteDirection = 1 -- down
      end
      
    end
    
  end
  
  
  love.graphics.draw(self.image, self.anim[spriteDirection][self.spriteFrame], x - self.tileSize, y - self.tileSize, 0, 2, 2)
  --love.graphics.draw(self.image, x - self.imageWidth*0.5, y - self.imageHeight*0.5) 
  
  -- Draw health
  if self.health ~= self.maxHealth then
    local barWidth=self.tileSize*1.6
    local heightOffset=self.tileSize+10
    love.graphics.rectangle("line", x - barWidth*0.5, y - heightOffset, barWidth, 8)
    love.graphics.rectangle("fill", x - barWidth*0.5+1, y - heightOffset + 1, (barWidth-2)*self.health/self.maxHealth, 6)
  end
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
    self.spriteFrameTime = self.spriteFrameTime + dt
    if self.spriteFrameTime > 0.1 then
      self.spriteFrameTime = 0.0
      self.spriteFrame = self.spriteFrame + 1
      if self.spriteFrame > 6 then
        self.spriteFrame = 1
      end
    end    
    
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
