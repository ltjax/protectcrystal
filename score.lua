local class=require "middleclass"

local Score = class "Score"

function Score:initialize(world)
  self.world = world
  self.currentScore = 0
  self.time = 1.0
  self.doAnimation = false
  self.minFontSize = 40
  self.fontSize = self.minFontSize
  self.maxFontSizeOffset = 24
  self.fontColor = {r = 0.0, g = 0.0, b = 0.0, a = 0.5}
end

function Score:draw()
  local dims = {x = 0, y = love.window.getHeight () / 2}
  love.graphics.push()
  love.graphics.setFont(love.graphics.newFont(self.fontSize))      
  love.graphics.printf(self.world.killScore, 0, -dims.y + 20, dims.x, 'center')
  love.graphics.pop()
end

function Score:update(dt)
  
  if self.world.killScore > self.currentScore then
    self.doAnimation = true
    self.currentScore = self.world.killScore
    self.time = 1.0
  end
  
  if self.doAnimation then
    self.fontSize = self.minFontSize + self.maxFontSizeOffset * self.time
    self.time = self.time - dt
    
    if self.time <= 0 then 
      self.time = 1.0
      self.doAnimation = false
    end
  end
  return true
end

return Score