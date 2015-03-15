local class = require "middleclass"
local Vector = require "vector"

local MouseKeyboardInput = class "MouseKeyboardInput"

function MouseKeyboardInput:initialize(keyList, useMouse)
  assert(keyList and #keyList >= 8, "Mouse/keyboard input needs at least 8 keys")
  self.keyList = keyList
  self.useMouse = useMouse
end

function MouseKeyboardInput:update(px, py, camera)
 
  local dx=0
  local dy=0
  
  if love.keyboard.isDown(self.keyList[1]) then
    dy = -1
  end
  if love.keyboard.isDown(self.keyList[2]) then
    dx = -1
  end
  if love.keyboard.isDown(self.keyList[3]) then
    dy = 1
  end
  if love.keyboard.isDown(self.keyList[4]) then
    dx = 1
  end
  
  local sx=0
  local sy=0
  
  if love.keyboard.isDown(self.keyList[5]) then
    sy = -1
  end
  if love.keyboard.isDown(self.keyList[6]) then
    sx = -1
  end
  if love.keyboard.isDown(self.keyList[7]) then
    sy = 1
  end
  if love.keyboard.isDown(self.keyList[8]) then
    sx = 1
  end
  
  -- Try mouse controls
  if self.useMouse and sx==0 and sy==0 and love.mouse.isDown("l") then
    local mx, my = love.mouse.getX(), love.mouse.getY()
    mx, my = camera:screenToWorld(mx, my)
    local delta = {x=mx-px, y=my-py} 
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
    self.move = Vector.normalize {x=dx, y=dy}
  else
    self.move = nil
  end
end

return MouseKeyboardInput
