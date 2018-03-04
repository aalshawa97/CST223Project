  love.graphics.setDefaultFilter('nearest','nearest')
  --Initialize a table of enemies
  enemy = {}
  enemy_controller = {}
  enemy_controller.enemies = {}
  enemy_controller.image = love.graphics.newImage("images/enemyAlien2.png")
  --Load the titlebar name
  love.window.setTitle( "Bit Shooter" )
--Initialize values for game scene
local backgroundImage,gameOn
function love.load()
  -- Timer for the text displayed to fade
  alpha = 255
  backgroundImage = love.graphics.newImage("images/startScreen.jpg")
  gameWinScore = 0
  gameOn = false;
  player = {}
  player.x = 345
  player.y = 540
  player.score = 0
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

enemy = {}
enemy.x = 345
enemy.y = 540
enemy.bullets = {}
enemy.cooldown = 20
enemy.speed = 10
  
   enemy.fire = function()
		if enemy.cooldown <= 0 then
		  --Laser gun sound
		  love.audio.play(player.fireSound)
		  enemy.cooldown = 20
		  bullet = {}
		  bullet.x = enemy.x + 35
		  bullet.y = enemy.y
		  table.insert(enemy.bullets, bullet)
		end
	end
	
	--Spawn Enemies
	for i=1,2 do
		if gameOn == true then
			gameWinScore = gameWinScore + 1;
		end
		enemy_controller:spawnEnemy(300 + i*50,0)
	end
		
	for i=1,1 do 
		if gameOn == true then
			gameWinScore = gameWinScore + 1;
		end
		enemy_controller:spawnEnemy(100 + i*100,0)
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
			if b.y <= e.y + e.height and b.x >= e.x and b.x <= e.x + e.width then
				--Collison occurred
				if gameOn == true then
					gameWinScore = gameWinScore - 1;
					player.score = player.score + 1
				end
				table.remove(enemies,i)
					love.draw()
				if #enemy_controller.enemies == 0 and gameOn == true then
					backgroundImage = love.graphics.newImage("images/win.png")
					--Notify the user of which button to press to begin the game
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
  enemy.y = y
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

--Check if we have won the game
	if #enemy_controller.enemies == 0 then
	end
 
-- so it takes 3 seconds to remove text on this screen
	alpha = alpha - (dt * (255 / 3)) 
	
-- Ensure that a 0 is the lowest value we get	
	if alpha < 0 then alpha = 0 end 
	
  player.cooldown = player.cooldown - 1
  
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
	gameOn = true;
	backgroundImage = love.graphics.newImage("images/stars.jpg")
	
	--Spawn enemies when the game begins
	for i=1,2 do 
		gameWinScore = gameWinScore + 1;
		enemy_controller:spawnEnemy(0 + i*100,i*10)
	end
	
	--Spawn blue aliens
	--enemy_controller.image = love.graphics.newImage("images/enemyAlien.jpg")
	for i=2,4 do 
		gameWinScore = gameWinScore + 1;
		enemy_controller:spawnEnemy(0 + i*100,i*10)
	end

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
  	end

  for i,b in ipairs(player.bullets) do
    if b.y < -10 then
      table.remove(player.bullets, i)
    end
    b.y = b.y - 10
  end
  
    for i,b in ipairs(enemy.bullets) do
    if b.y < -10 then
      table.remove(enemy.bullets, i)
    end
    b.y = b.y - 10
  end
  
  onCollision(enemy_controller.enemies,player.bullets)
end

function love.draw()
  --Draw the background image
  love.graphics.draw(backgroundImage, 54, 54)
  
  --Welcome the user to the game
  love.graphics.setColor(0, 255, 0, alpha)
  love.graphics.print("Welcome!",320, 0, 0, 2,2)
  
  --Notify the user of which button to press to begin the game
  love.graphics.print("Destroy All Enemies,Press Enter To Spawn Enemies",0, 50, 0, 2,2)

  --Draw the player
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(player.image, player.x, player.y,0,.2)

  love.graphics.setColor(255,255,255)
  --Draw enemies onto the screens
  for _,e in pairs(enemy_controller.enemies)do
  	love.graphics.draw(enemy_controller.image, e.x, e.y,0,.2)
  end

  --Draw bullets
  love.graphics.setColor(255,0,0)
  for _,b in pairs(player.bullets) do
    love.graphics.rectangle("fill", b.x, b.y, 10, 10)
  end
  
    --love.graphics.setColor(0, 255, 0, alpha + 10)
  --Load score board
	love.graphics.print("Score: " .. player.score, 16, 16)
end