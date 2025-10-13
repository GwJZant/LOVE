function love.load()
  frames = {}
  
  for i=1,5 do
    table.insert(frames, love.graphics.newImage("jump" .. i .. ".png"))
  end
  
  currentFrame = 1
end

function love.update(dt)
  currentFrame = currentFrame + 10 * dt
  
  if currentFrame >= 6 then
    currentFrame = 1
  end
end

function love.draw()
  love.graphics.draw(frames[math.floor(currentFrame)])
end