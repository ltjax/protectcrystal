local class=require "middleclass"

local Spawner=class "Spawner"

function Spawner:initialize(classList, objectList, world, crystal)
  self.objectList = objectList
  self.classList=classList
  self.world = world
  self.crystal = crystal
  self.time = 0.0
end

function Spawner:update(dt)
  self.time = self.time + dt
  if self.time > 2.0 then
    local selectedClass = self.classList[love.math.random(1, #self.classList)]
    local angle=love.math.random()*math.pi*2.0
    local distance=500+love.math.random()*200
    local x, y = math.cos(angle)*distance, math.sin(angle)*distance
    table.insert(self.objectList, selectedClass:new(self.world, x, y, self.crystal))
    self.time = 0.0
  end
  return true
end

return Spawner