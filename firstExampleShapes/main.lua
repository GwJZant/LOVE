-- Allow debug logging to appear during runtime
io.stdout:setvbuf("no")

require("example")

-- Run once at startup
function love.load()
  require "shape"
  local Rectangle = require "rectangle"
  local Circle = require "circle"
  
  r1 = Rectangle(100, 100, 200, 50)
  r2 = Circle(350, 80, 40)
end

function love.update(dt)
  r1:update(dt)
  r2:update(dt)
end

function love.draw()
  r1:draw()
  r2:draw()
end

function love.keypressed(key)
  
end