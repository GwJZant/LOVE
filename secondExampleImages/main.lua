-- Allow debug logging to appear during runtime
io.stdout:setvbuf("no")

function love.load()
  myImage = love.graphics.newImage('sheep.png')
  width = myImage:getWidth()
  height = myImage:getHeight()
  
  love.graphics.setBackgroundColor(1, 1, 1)
end

function love.update(dt)
  
end

function love.draw()
  love.graphics.setColor(255/255, 255/255, 255/255, 127/255)
  love.graphics.draw(myImage, 100, 100, 0, 1, 1, width/2, height/2)
end