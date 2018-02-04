  --Initialize a table of enemies
  enemy = {}
  enemy_controller = {}
  enemy_controller.enemies = {}

--Initialize values for game scene
local welcomeImage
function love.load()
  welcomeImage = love.graphics.newImage("images/startScreen.jpg")
  player = {}
  player.x = 0
  player.y = 550
  player.bullets = {}
  player.cooldown = 20
  player.speed = 10
  player.fire = function()
    if player.cooldown <= 0 then
      player.cooldown = 20
      bullet = {}
      bullet.x = player.x + 35
      bullet.y = player.y
      table.insert(player.bullets, bullet)
    end
 end
  enemy_controller:spawnEnemy()
end

--Enemy fire code
function enemy:fire()
	--Self allows the class to refer to itself
	if self.cooldown <= 0 then
      self.cooldown = 20
      bullet = {}
      bullet.x = self.x + 35
      bullet.y = self.y
      table.insert(self.bullets, bullet)
    end
end

function enemy_controller:spawnEnemy()
  --Initialize enemy properties
  enemy = {}
  enemy.x = 0
  enemy.y = 0
  enemy.bullets = {}
  enemy.cooldown = 20
  enemy.speed = 10
  table.insert(self.enemies,enemy)
end


--Update timer count for gun cool down
function love.update(dt)
  player.cooldown = player.cooldown - 1

--Handle player controls
  if love.keyboard.isDown("right") then
    player.x = player.x + player.speed
  elseif love.keyboard.isDown("left") then
    player.x = player.x - player.speed
  end

  if love.keyboard.isDown("space") then
  	player.fire()
  end

  for i,b in ipairs(player.bullets) do
    if b.y < -10 then
      table.remove(player.bullets, i)
    end
    b.y = b.y - 10
  end
end

function love.draw()
  --draw the welcome image
  love.graphics.draw(welcomeImage, 54, 54)

  -- draw the player
  love.graphics.setColor(0, 0, 100)
  love.graphics.rectangle("fill", player.x, player.y, 80, 20)


-- Draw bullets
  love.graphics.setColor(255,0,0)
  for _,b in pairs(player.bullets) do
    love.graphics.rectangle("fill", b.x, b.y, 10, 10)
  end
end