local class = require "middleclass"
local Gamestate = require "gamestate"
local Vector = require "vector"

local objectList={}
local world

local inGameState = {}
local logoState = {}




-- Require entity types
local Crystal = require "crystal"
local Bullet = require "bullet"
local Player = require "player"
local Spider = require "spider"

function beginContact(a, b, contact)
  if a:getUserData().type == "Spider" and b:getUserData().type == "Crystal" then
    spider = a:getUserData()
  elseif a:getUserData().type == "Crystal" and b:getUserData().type == "Spider" then 
    spider = b:getUserData()
  end
  
  if spider then
    spider:setDoUpdate (false)
  end
end

function love.load(arg)
  
  -- Enable debugging
  if arg[#arg] == "-debug" then
    require("mobdebug").start()
  end
  
  Gamestate.registerEvents()
  Gamestate.switch(logoState)
end

function logoState:init()
  self.image = love.graphics.newImage("data/logo.png")
end

function logoState:enter()
  love.graphics.setBackgroundColor(0, 0, 0, 255)
end


function logoState:draw()
  local windowWidth = love.window.getWidth()
  local windowHeight = love.window.getHeight()
  local imageWidth = self.image:getWidth()
  local imageHeight = self.image:getHeight()
  
  love.graphics.draw(self.image, (windowWidth-imageWidth)/2, (windowHeight-imageHeight)/2)
end

function logoState:keypressed()
  Gamestate.switch(inGameState)
end

function inGameState:init()
  love.physics.setMeter(32)
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(beginContact)
  
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  
  table.insert(objectList, Crystal:new(world))
  table.insert(objectList, Player:new(world, -100, 50, {'w', 'a', 's', 'd', 'up', 'left', 'down', 'right'}))
  table.insert(objectList, Player:new(world, 100, 50))
  table.insert(objectList, Spider:new(-width / 3, -height / 3, world))
end


function inGameState:draw()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  love.graphics.translate(width/2, height/2)
  
  love.graphics.setBackgroundColor({128,128,128,255})
  
  for i=1,#objectList do
    objectList[i]:draw()
  end
end

function inGameState:update(dt) 
  
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
