local class = require "middleclass"
local Vector = require "vector"

local ControllerInput = class "ControllerInput"

local function unitSquareToUnitCircle(x, y)
  -- Use max-norm as target
  local targetLength = math.max(math.abs(x), math.abs(y))
  
  -- And euclidean norm as actual
  local currentLength = Vector.length({x=x, y=y})
  
  local scale = targetLength / currentLength
  return x*scale, y*scale
end

function ControllerInput:initialize(joystick)
  assert(joystick, "Need a joystick")
  self.joystick=joystick
  self.threshold=0.4
  self.move={x=0, y=0}
end

function ControllerInput:update(x, y, camera)
  local t = self.threshold
  local dx=self.joystick:getAxis(1)
  local dy=self.joystick:getAxis(2)
  
  local adx = math.abs(dx)
  local ady = math.abs(dy)
  
  if adx > t or ady > t then
    dx, dy = unitSquareToUnitCircle(dx, dy)
    self.move.x, self.move.y = dx, dy
  else
    self.move.x, self.move.y = 0, 0
  end
  
  local sx=self.joystick:getAxis(3)
  local sy=self.joystick:getAxis(4)
  
  if math.abs(sx) > t or math.abs(sy) > t then
    self.direction=Vector.normalize({x=sx, y=sy})
    self.shooting=true
  else
    self.shooting=false
  end 
  
end


return ControllerInput
