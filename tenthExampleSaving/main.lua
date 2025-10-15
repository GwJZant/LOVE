io.stdout:setvbuf("no")

function love.load()
  lume = require "lume"
  player = {
    x = 100,
    y = 100,
    size = 25,
    speed = 200,
    image = love.graphics.newImage("face.png")
  }
  
  coins = {}
  
  if love.filesystem.getInfo("savedata.drag") then
    file = love.filesystem.read("savedata.drag")
    data = lume.deserialize(file)
    
    player.x = data.player.x
    player.y = data.player.y
    player.size = data.player.size
    player.speed = data.player.speed
    
    for i,v in ipairs(data.coins) do
      coins[i] = {
        x = v.x,
        y = v.y,
        size = 10,
        image = love.graphics.newImage("dollar.png")
      }
    end
  else
    for i=1,25 do
    table.insert(coins,
      {
        x = math.random(50, 650),
        y = math.random(50, 450),
        size = 10,
        image = love.graphics.newImage("dollar.png")
      }
    )
    end
  end
end

function love.update(dt)
  if love.keyboard.isDown("left") then
    player.x = player.x - player.speed * dt
  elseif love.keyboard.isDown("right") then
    player.x = player.x + player.speed * dt
  end
  
  if love.keyboard.isDown("up") then
    player.y = player.y - player.speed * dt
  elseif love.keyboard.isDown("down") then
    player.y = player.y + player.speed * dt
  end
  
  for i=#coins,1,-1 do
    if checkCollision(player, coins[i]) then
      table.remove(coins, i)
        if player.size < 75 then
          player.size = player.size + 1
          player.speed = player.speed + 5
        end
    end
  end
  
  if #coins == 0 then
    for i=1,25 do
    table.insert(coins,
      {
        x = math.random(50, 650),
        y = math.random(50, 450),
        size = 10,
        image = love.graphics.newImage("dollar.png")
      }
    )
    end
  end
end

function love.draw()
  love.graphics.circle("line", player.x, player.y, player.size)
  love.graphics.draw(player.image, player.x, player.y, 0, 1, 1, player.image:getWidth()/2, player.image:getHeight()/2)
  
  for i,v in ipairs(coins) do
    love.graphics.circle("line", v.x, v.y, v.size)
    love.graphics.draw(v.image, v.x, v.y, 0, 1, 1, v.image:getWidth()/2, v.image:getHeight()/2)
  end
end

function checkCollision(p1, p2)
  local distance = math.sqrt((p1.x - p2.x)^2 + (p1.y - p2.y)^2)
  
  return distance < p1.size + p2.size
end

function saveGame()
  data = {}
  data.player = {
    x = player.x,
    y = player.y,
    size = player.size,
    speed = player.speed
  }
  
  data.coins = {}
  
  for i,v in ipairs(coins) do
    data.coins[i] = {x = v.x, y = v.y}
  end
  
  serialized = lume.serialize(data)
  
  -- Location i C:\Users\user\AppData\Roaming\LOVE	
  love.filesystem.write("savedata.drag", serialized)
end

function love.keypressed(key)
  if key == "f1" then
    saveGame()
  elseif key == "f2" then
    love.filesystem.remove("savedata.drag")
    love.event.quit("restart")
  end
end