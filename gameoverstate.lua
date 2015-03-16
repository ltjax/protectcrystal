

local gameOverState = {}

function gameOverState:init()
  --self.font = love.graphics.newFont(36)
end

function gameOverState:enter(oldstate, score)
  self.score = score
end

function gameOverState:draw()
  love.graphics.setBackgroundColor(0, 0, 0, 255)
  love.graphics.printf("Game Over", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), 'center')
  love.graphics.printf("Final Score: " .. self.score, 0, love.graphics.getHeight()/2 + 20, love.graphics.getWidth(), 'center')
end

return gameOverState

