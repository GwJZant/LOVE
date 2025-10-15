io.stdout:setvbuf("no")

function love.load()
  lume = require "lume"
  
  screenCanvas = love.graphics.newCanvas(400, 600)
  
  player = {
    x = 100,
    y = 100,
    size = 25,
    speed = 200,
    score = 0,
    image = love.graphics.newImage("face.png")
  }
  
  player2 = {
    x = 500,
    y = 100,
    size = 25,
    speed = 200,
    score = 0,
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
    player.score = data.player.score
    
    player2.x = data.player2.x
    player2.y = data.player2.y
    player2.size = data.player2.size
    player2.speed = data.player2.speed
    player2.score = data.player2.score
    
    for i,v in ipairs(data.coins) do
      coins[i] = {
        x = v.x,
        y = v.y,
        size = 10,
        image = love.graphics.newImage("dollar.png")
      }
    end
  else
    for i=1,50 do
    table.insert(coins,
      {
        x = math.random(-650, 650),
        y = math.random(-450, 450),
        size = 10,
        image = love.graphics.newImage("dollar.png")
      }
    )
    end
  end
  
  shakeDuration = 0
  shakeWait = 0
  shakeOffset = {x = 0, y = 0}
end

function love.update(dt)
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    player.x = player.x - player.speed * dt
  elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    player.x = player.x + player.speed * dt
  end
  
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    player.y = player.y - player.speed * dt
  elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    player.y = player.y + player.speed * dt
  end
  
  if love.keyboard.isDown("j") then
    player2.x = player2.x - player2.speed * dt
  elseif love.keyboard.isDown("l") then
    player2.x = player2.x + player2.speed * dt
  end
  
  if love.keyboard.isDown("i") then
    player2.y = player2.y - player2.speed * dt
  elseif love.keyboard.isDown("k") then
    player2.y = player2.y + player2.speed * dt
  end
  
  for i=#coins,1,-1 do
    if checkCollision(player, coins[i]) then
      table.remove(coins, i)
      player.score = player.score + player.size
      shakeDuration = 0.3
      
      if player.size < 75 then
        player.size = player.size + 1
        player.speed = player.speed + 5
      end
    elseif checkCollision(player2, coins[i]) then
      table.remove(coins, i)
      player2.score = player2.score + player2.size
      shakeDuration = 0.3
      
      if player2.size < 75 then
        player2.size = player2.size + 1
        player2.speed = player2.speed + 5
      end
    end
  end
  
  if #coins == 0 then
    for i=1,50 do
    table.insert(coins,
      {
        x = math.random(-650, 650),
        y = math.random(-450, 450),
        size = 10,
        image = love.graphics.newImage("dollar.png")
      }
    )
    end
  end
  
  if shakeDuration > 0 then
    shakeDuration = shakeDuration - dt
    
    if shakeWait > 0 then
      shakeWait = shakeWait - dt
    else
      shakeOffset.x = love.math.random(-5, 5)
      shakeOffset.y = love.math.random(-5, 5)
      shakeWait = 0.05
    end
  end
end

function love.draw()
  love.graphics.setCanvas(screenCanvas)
  love.graphics.clear()
  drawGame(player)
  love.graphics.setCanvas()
  love.graphics.draw(screenCanvas)
  
  love.graphics.setCanvas(screenCanvas)
  love.graphics.clear()
  drawGame(player2)
  love.graphics.setCanvas()
  love.graphics.draw(screenCanvas, 400)
  
  love.graphics.line(400, 0, 400, 600)
  
  love.graphics.print(player.score, 10, 10)
  love.graphics.print(player2.score, 410, 10)
end

function drawGame(focus)
  love.graphics.push()
    love.graphics.translate(-focus.x + 200, -focus.y + 300)
    
    if shakeDuration > 0 then
      love.graphics.translate(shakeOffset.x, shakeOffset.y)  
    end
    
    love.graphics.circle("line", player.x, player.y, player.size)
    love.graphics.draw(player.image, player.x, player.y, 0, 1, 1, player.image:getWidth()/2, player.image:getHeight()/2)
    
    love.graphics.circle("line", player2.x, player2.y, player2.size)
    love.graphics.draw(player2.image, player2.x, player2.y, 0, 1, 1, player2.image:getWidth()/2, player2.image:getHeight()/2)
    
    for i,v in ipairs(coins) do
      love.graphics.circle("line", v.x, v.y, v.size)
      love.graphics.draw(v.image, v.x, v.y, 0, 1, 1, v.image:getWidth()/2, v.image:getHeight()/2)
    end
  
  --love.graphics.translate(player.x - 400, player.y - 300)
  --love.graphics.origin()
  love.graphics.pop()
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
    speed = player.speed,
    score = player.score
  }
  
  data.player2 = {
    x = player2.x,
    y = player2.y,
    size = player2.size,
    speed = player2.speed,
    score = player2.score
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
    love.event.quit("quit")
  end
end