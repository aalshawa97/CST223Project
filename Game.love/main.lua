function love.draw()
	love.graphics.print("Welcome To Bit Blaster", 300 ,0)
end

--Load the home page picture
function love.load()
   image = love.graphics.newImage("homepage.jpg")
   love.graphics.setNewFont(12)
   love.graphics.setColor(0,0,0)
   love.graphics.setBackgroundColor(255,255,255)
end