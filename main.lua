local class = require "middleclass"
local Gamestate = require "gamestate"

function love.load(arg)
  
  -- Enable debugging
  if arg[#arg] == "-debug" then
    require("mobdebug").start()
  end
  
  -- Start the gamestate manager and move to the logo state
  Gamestate.registerEvents()
  Gamestate.switch(require "logostate")
end

