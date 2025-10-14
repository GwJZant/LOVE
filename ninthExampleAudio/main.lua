io.stdout:setvbuf("no")

function love.load()
  song = love.audio.newSource("song.ogg", "stream")
  song:setLooping(true)
  song:play()
  
  sfx = love.audio.newSource("sfx.ogg", "static")
  
  circle = {x = 100, y = 100}
  bullets = {}
end

function love.update(dt)
  for i,v in ipairs(bullets) do
    v.x = v.x + 400 * dt
    print(v.x)
  end
end

function love.draw()
  love.graphics.circle("fill", circle.x, circle.y, 50)
  
  for i,v in ipairs(bullets) do
    love.graphics.circle("fill", v.x, v.y, 10)
  end
end

function love.keypressed(key)
  if key == "space" then
    --sfx:play()
    shoot()
  end
end

function shoot()
  table.insert(bullets, {x = circle.x, y = circle.y})
end