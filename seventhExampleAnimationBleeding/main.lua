function love.load()
  image = love.graphics.newImage("jump_3.png")
  local width = image:getWidth()
  local height = image:getHeight() 
  frames = {}
  local frame_width = 117
  local frame_height = 233
  
  for i=0,1 do
    for j=0,2 do
      table.insert(frames, love.graphics.newQuad(1 + j * (frame_width + 2), 1 + i * (frame_height + 2), frame_width, frame_height, width, height))
    end
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
  love.graphics.draw(image, frames[math.floor(currentFrame)], 100, 100)
end