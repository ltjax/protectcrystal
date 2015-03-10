

local gameOverState = {}

function gameOverState:init()
  --self.font = love.graphics.newFont(36)
end

function gameOverState:enter()
end

function gameOverState:draw()
  love.graphics.setBackgroundColor(0, 0, 0, 255)
  love.graphics.printf("Game Over", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), 'center')
end

return gameOverState
