local class = require "middleclass"
local Vector = require "vector"

local objectList={}

-- Require entity types
local Crystal = require "crystal"
local Bullet = require "bullet"
local Player = require "player"
local Spider = require "spider"

function love.load(arg)
  
  -- Enable debugging
  if arg[#arg] == "-debug" then
    require("mobdebug").start()
  end

  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  
  table.insert(objectList, Crystal:new())
  table.insert(objectList, Player:new(-100, 50, {'w', 'a', 's', 'd', 'up', 'left', 'down', 'right'}))
  table.insert(objectList, Player:new(100, 50))
  table.insert(objectList, Spider:new(-width / 3, -height / 3))
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
  
  local tempObjectList=objectList
  objectList={}
  
  for i=1,#tempObjectList do
    local currentObject=tempObjectList[i]
    if currentObject.update then
      if currentObject:update(dt) then
        table.insert(objectList, currentObject)
      end
    else
      table.insert(objectList, currentObject)
    end
  end

end
