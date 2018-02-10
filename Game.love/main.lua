    love.graphics.setDefaultFilter('nearest','nearest')
  --Initialize a table of enemies
  enemy = {}
  enemy_controller = {}
  enemy_controller.enemies = {}
  enemy_controller.image = love.graphics.newImage("images/enemyAlien.jpg")
--Initialize values for game scene
local welcomeImage
function love.load()
  game_over = false
  welcomeImage = love.graphics.newImage("images/startScreen.jpg")
  player = {}
  player.x = 0
  player.y = 550
  player.bullets = {}
  player.cooldown = 20
  player.speed = 10
  player.image = love.graphics.newImage("images/spaceship.png")
  player.fireSound = love.audio.newSource('laserGunNoise.mp3')
  player.fire = function()
    if player.cooldown <= 0 then
      --Laser gun sound
  	  love.audio.play(player.fireSound)
      player.cooldown = 20
      bullet = {}
      bullet.x = player.x + 35
      bullet.y = player.y
      table.insert(player.bullets, bullet)
    end
 end
  
  for i=0, 8 do
  	enemy_controller:spawnEnemy(i*10,0)
  end
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

function onCollision(enemies, bullets)
	for i,e in pairs(enemies)do
		for _,b in pairs(bullets)do
			if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
				--Collison occurred
				table.remove(enemies,i)
			end
		end
	end
end

function enemy_controller:spawnEnemy(x,y)
  --Initialize enemy properties
  enemy = {}
  enemy.x = 0
  enemy.y = 0
  enemy.width = 10
  enemy.height = 10
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

  --Enemy movement
  	for _,e in pairs(enemy_controller.enemies)do
  		if e.y >= love.graphics.getHeight()/4 then
  			game_over = true
  		end
  		e.y = e.y + 1
  	end

  for i,b in ipairs(player.bullets) do
    if b.y < -10 then
      table.remove(player.bullets, i)
    end
    b.y = b.y - 10
  end
  onCollision(enemy_controller.enemies,player.bullets)
end

function love.draw()
   --Check if the game is over
   if game_over then	
	   love.graphics.print("Game Over",300,300,0,2,2,0,0)
	   --Do this so nothing else can be printed on the screen
	   return
   end

  --Draw the welcome image
  --love.graphics.draw(welcomeImage, 54, 54)
 
  --Draw the player
  love.graphics.setColor(0, 0, 100)
  love.graphics.draw(player.image, player.x, player.y,0,.2)

  love.graphics.setColor(255,255,255)
  --Draw enemies onto the screens
  for _,e in pairs(enemy_controller.enemies)do
  	love.graphics.draw(enemy_controller.image, e.x, e.y,0,.2)
  end

-- Draw bullets
  love.graphics.setColor(255,0,0)
  for _,b in pairs(player.bullets) do
    love.graphics.rectangle("fill", b.x-17, b.y, 10, 10)
  end
end