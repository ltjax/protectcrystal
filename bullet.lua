local class = require "middleclass"
local Vector = require "vector"

local Bullet = class "Bullet"

function Bullet:initialize(world, x, y, dx, dy)
  self.position = {x=x, y=y}
  self.direction = {x=dx, y=dy}
  self.time = 0.6
  self.world = world
end

function Bullet:update(dt, objectList)
  local delta=Vector.scale(self.direction, dt)
  self.time = self.time - dt
  
  local traceResult = self.world:segmentTrace(self.position.x, self.position.y, delta.x, delta.y)
  
  if traceResult and traceResult.object and traceResult.object.receiveDamage then
    traceResult.object:receiveDamage(1.0)
    -- Add explosion
    return false
  end  
  
  self.position = Vector.add(delta, self.position)
  
  return self.time > 0
end

function Bullet:draw()
  love.graphics.setColor(255, 50, 0, 255)
  love.graphics.circle("fill", self.position.x, self.position.y, 12, 8)
end

return Bullet
