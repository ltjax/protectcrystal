
local Vector = require "vector"
local HadronCollider = require "hadroncollider"
assert(HadronCollider, "Unable to load hadron collider")

local inGameState = {}

-- Require entity types
local Crystal = require "crystal"
local Bullet = require "bullet"
local Player = require "player"
local Spider = require "spider"
local Spawner = require "spawner"

local function segmentTrace(world, x, y, dx, dy)
  local ax, ay=x ,y
  local bx, by=ax+dx, ay+dy
  
  if ax > bx then
    ax, bx = bx, ax
  end
  
  if ay > by then
    ay, by = by, ay
  end
  
  local result=nil
  local bestLambda=1.0
  for shape in pairs(world:shapesInRange(ax,ay,bx,by)) do
    local intersecting, lambda = shape:intersectsRay(x, y, dx, dy)
    if intersecting and lambda < bestLambda then
      result = shape
      bestLambda = lambda
    end
  end

  return result
end


function inGameState:contactCallback(dt, shape_one, shape_two, dx, dy)
end

function inGameState:init()
  -- Create and empty list for all game objects
  self.objectList = {}
  
  self.world = HadronCollider(100, function(...) self:contactCallback(...) end)
  self.world.segmentTrace = segmentTrace
  
  
  
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  
  local crystal = Crystal:new(self.world)
  table.insert(self.objectList, crystal)
  table.insert(self.objectList, Player:new(self.world, -100, 50, {'w', 'a', 's', 'd', 'up', 'left', 'down', 'right'}))
  table.insert(self.objectList, Player:new(self.world, 100, 50))
  --table.insert(self.objectList, Spider:new(self.world, -width / 3, -height / 3, crystal))
  table.insert(self.objectList, Spawner:new({Spider}, self.objectList, self.world, crystal))
end

function inGameState:draw()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  love.graphics.translate(width/2, height/2)
  
  love.graphics.setBackgroundColor({128,128,128,255})
  
  for i=1,#self.objectList do
    if self.objectList[i].draw then
      self.objectList[i]:draw()
    end
  end
end

function inGameState:update(dt) 
  
  -- Update game physics
  self.world:update(dt)
  
  -- Temporary object list for new objects
  local newObjectList={}
  
  -- Update and move alive entities to the front
  local dst=1
  local N = #self.objectList
  for i=1,N do
    local currentObject=self.objectList[i]
    
    if (not currentObject.update) or currentObject:update(dt, newObjectList) then
      self.objectList[dst] = currentObject
      dst = dst + 1
    end
  end

  for i=dst,N do
    table.remove(self.objectList)
  end
  
  for i=1, #newObjectList do
    table.insert(self.objectList, newObjectList[i])
  end
end

return inGameState