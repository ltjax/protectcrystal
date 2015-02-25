local class = require "middleclass"
local Vector = require "vector"

local Bullet = class "Bullet"

function Bullet:initialize(x, y, dx, dy)
  self.position = {x=x, y=y}
  self.direction = {x=dx, y=dy}
  self.time = 1.0
end

function Bullet:update(dt, objectList)
  self.position = Vector.add(Vector.scale(self.direction, dt), self.position)
  self.time = self.time - dt
  
  return self.time > 0
end

function Bullet:draw()
  love.graphics.setColor(255, 50, 0, 255)
  love.graphics.circle("fill", self.position.x, self.position.y, 12, 8)
end

return Bullet
