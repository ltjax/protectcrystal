local class = require "middleclass"

local Camera = class "Camera"

function Camera:initialize()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  self.x = -width/2
  self.y = -height/2
end

function Camera:setupDrawing()
  love.graphics.translate(-self.x, -self.y)
end

function Camera:worldToScreen(x, y)
  local sx = x - self.x
  local sy = y - self.y
  return sx, sy
end

function Camera:screenToWorld(x, y)
  return x + self.x, y + self.y  
end

return Camera
