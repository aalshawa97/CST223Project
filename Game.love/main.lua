function love.draw()
	--Load welcome message
	love.graphics.print("Welcome To Bit Blaster", 300 ,0)
end

function love.load()
	--Draw homepage
   image = love.graphics.newImage("homepage.jpg")
   love.graphics.setNewFont(12)
   love.graphics.setColor(100,100,0)
   love.graphics.setBackgroundColor(255,255,255)

   --Load the spaceship with bullets
	player = {}
	player.x = 0;
	player.y = 550;
	player.bullets = {}
	--Allow the player's gun to cooldown after 20 ticks
	player.cooldown= 20
	player.speed = 10
	player.fire = function()
		if player.cooldown <= 0 then --We are able to fire a new bullet
			player.cooldown = 20
		    bullet {}
		    --The offest added to the bullet's x value allows the bullet to be shot from the middle of the spaceship
			bullet.x = player.x + 35
			bullet.y = player.y
			table.insert(player.bullets,bullet)
		end
	end
end

function love.update(dt)
	player.cooldown = player.cooldown - 1
	--Handle controls for interactable homepage object
	if love.keyboard.isDown("right") then
		player.x = player.x + player.speed
	elseif love.keyboard.isDown("left") then
		player.x = player.x - player.speed
	end

	if love.keyboard.isDown("up") then
		player.y = player.y - 1
	elseif love.keyboard.isDown("down") then
		player.y = player.y + 1
	end

	if love.keyboard.isDown(" ") then
			player.fire()
	end

		--shoot bullets
		for i,v in ipairs(player.bullets) do
			if v.y < - 10 then
				--Remove the bullets if they are out of the screen
				table.remove(player.bulets, i)
			v.y = v.y - 10
			end	
		end
end

--Interactable object
function love.draw()
	love.graphics.rectangle("fill", player.x, player.y, 80 ,20)

--draw the bullets
	--color the bullets
	love.graphics.setColor(100,100,100)
	for _,v in pairs(player.bullets) do
		love.graphics.rectangle("fill", v.x, v.y, 10, 10)
		end
end
