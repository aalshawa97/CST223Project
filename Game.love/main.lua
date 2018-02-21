    love.graphics.setDefaultFilter('nearest','nearest')
  --Initialize a table of enemies
  enemy = {}
  enemy_controller = {}
  enemy_controller.enemies = {}
  enemy_controller.image = love.graphics.newImage("images/enemyAlien.jpg")
--Initialize values for game scene
local backgroundImage
function love.load()
  backgroundImage = love.graphics.newImage("images/startScreen.jpg")
  player = {}
  player.x = 345
  player.y = 540
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
  enemy_controller:spawnEnemy(300,0)
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
			if b.y <= e.y + e.height and b.x >= e.x and b.x <= e.x + e.width then
				--Collison occurred
				table.remove(enemies,i)
					love.draw()
				if # table == 0 then
					backgroundImage = love.graphics.newImage("images/win.png")
					love.draw()
				end

			end
		end
	end
end

function enemy_controller:spawnEnemy(x,y)
  --Initialize enemy properties
  enemy = {}
  enemy.x = x
  enemy.y = x
  enemy.width = 10
  enemy.height = 10
  enemy.bullets = {}
  enemy.cooldown = 20
  enemy.speed = 20
  enemy.movecount = 0
  table.insert(self.enemies,enemy)
end


--Update timer count for gun cool down
function love.update(dt)
  player.cooldown = player.cooldown - 1

--Enemy fires
	--enemy.fire();
  
--Handle player controls
  if ( (love.keyboard.isDown("right") or love.keyboard.isDown("d"))  and (player.x <= love.graphics.getWidth() - 70) )   then
    player.x = player.x + 3
  
  elseif ((love.keyboard.isDown("left") or love.keyboard.isDown("a")) and (player.x >= 10)) then
    player.x = player.x - 3
  end

  if love.keyboard.isDown("space") then
  	player.fire()
  end
  
  if love.keyboard.isDown("return") then
	backgroundImage = love.graphics.newImage("images/stars.jpg")
	love.draw()
  end

  --Enemy movement
  	for _,e in pairs(enemy_controller.enemies)do
      --****straight downward movement***
  		--e.y = e.y + 1
      --****end straight downward movement****
      
      --****below code creates a stairstep movement for enemy****
      --if enemy movecount < 50 move down
      if e.movecount <= 50 then
        e.y = e.y + 1
        e.movecount = e.movecount + 1
      --else if movecount between 50 and 100 move right
      elseif (e.movecount > 50) and  (e.movecount <= 100) then
        e.x = e.x + 1
        e.movecount = e.movecount + 1
      end
      --reset movecount
      if e.movecount > 100 then
        e.movecount = 0
      end
      --****end stairstep movement***
      
      
      --****below code creates an offset zigzag movement for enemy****
      --[[--enemy move down
      if e.movecount <= 20 then
        e.y = e.y + 1
        e.movecount = e.movecount + 1
      --move right
      elseif (e.movecount > 20) and  (e.movecount <= 40) then
        e.x = e.x + 1
        e.movecount = e.movecount + 1
      --move down
      elseif (e.movecount > 40) and  (e.movecount <= 60) then
        e.y = e.y + 1
        e.movecount = e.movecount + 1
      --move left twice as far
      elseif (e.movecount > 60) and  (e.movecount <= 80) then
        e.x = e.x - 2
        e.movecount = e.movecount + 1
      --move down
      elseif (e.movecount > 80) and  (e.movecount <= 100) then
        e.y = e.y + 1
        e.movecount = e.movecount + 1
      --move right
      elseif (e.movecount > 100) and  (e.movecount <= 120) then
        e.x = e.x + 1
        e.movecount = e.movecount + 1
      end
      --reset movecount
      if e.movecount > 120 then
        e.movecount = 0
      end
      --****end offset zigzag movement code****--]]
      
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
  --Draw the background image
  love.graphics.draw(backgroundImage, 54, 54)

  --Draw the player
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(player.image, player.x, player.y,0,.2)

  love.graphics.setColor(255,255,255)
  --Draw enemies onto the screens
  for _,e in pairs(enemy_controller.enemies)do
  	love.graphics.draw(enemy_controller.image, e.x, e.y,0,.2)
  end

-- Draw bullets
  love.graphics.setColor(255,0,0)
  for _,b in pairs(player.bullets) do
    love.graphics.rectangle("fill", b.x, b.y, 10, 10)
  end
end