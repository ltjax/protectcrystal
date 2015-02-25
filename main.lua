local class = require "middleclass"
local Vector = require "vector"

local objectList={}
local world


-- Require entity types
local Crystal = require "crystal"
local Bullet = require "bullet"
local Player = require "player"

function love.load(arg)
  
  -- Enable debugging
  if arg[#arg] == "-debug" then
    require("mobdebug").start()
  end

  love.physics.setMeter(32)
  world = love.physics.newWorld(0, 0, true)
  
  table.insert(objectList, Crystal:new(world))
  table.insert(objectList, Player:new(world, -100, 50, {'w', 'a', 's', 'd', 'up', 'left', 'down', 'right'}))
  table.insert(objectList, Player:new(world, 100, 50))
  
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
  
  -- Update game physics
  world:update(dt)
  -- Update game logic
  local tempObjectList=objectList
  
  objectList={}
  
  for i=1,#tempObjectList do
    local currentObject=tempObjectList[i]
    if currentObject.update then
      if currentObject:update(dt, objectList) then
        table.insert(objectList, currentObject)
      end
    else
      table.insert(objectList, currentObject)
    end
  end

end
