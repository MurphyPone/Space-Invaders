require('player')
require('pal')
require('bullets')
require('powerup')
require('enemy')
--require('SFX')
require('waves')
camShake = require('shake')

function love.load()
	WIDTH, HEIGHT = love.graphics.getDimensions()

	--Create player 
	player = LOAD_player()

	--create pals
	pals = LOAD_pals()

	--more globals 
	xPad = (player.w/2 * player.scale) + 10 	--Dist to keep ship in bounds
	yPad = (player.h/2 * player.scale) + 10 

	--bullets 	--Should move to own file
	bullets = LOAD_bullets()

	--Camshake
	camShake.reset()

	--Powerups
	powerups = LOAD_powerups()

	--Enemies
	enemies = {}
	wave = 1
	for i = 1, 1 do 
		table.insert(enemies, Enemy:new(WIDTH/2))
	end

	--SFX 
	--SFX = LOAD_SFX()

	--Other util stuff
	love.mouse.setVisible(false)
	font_big = love.graphics.setNewFont('assets/Square.ttf', 30)
	font_main = love.graphics.setNewFont('assets/Square.ttf', 12)
	love.graphics.setBackgroundColor(50, 50, 50)
end
	
function love.draw()
	if(player.hp > 0) then 
		
		--draw pals
		DRAW_pals()

		--draw bullets
		DRAW_bullets()

		--draw powerup
		for i,v in ipairs(powerups) do 
			v:draw()
		end 

		--draw enemies 
		DRAW_enemies()
		--draw player
		DRAW_player(dt)
		--
	else 
		text = "YOU MADE IT TO ROUND "..tostring(wave)
		love.graphics.setFont(font_big)
		love.graphics.print(text, WIDTH/2 - font_big:getWidth(text)/2, HEIGHT/3)
		love.graphics.setFont(font_main)
		love.graphics.print('press R to restart', WIDTH/2- font_main:getWidth('press R to restart')/2, HEIGHT/2)
	end 

	--draw cursor
	love.graphics.rectangle('fill', love.mouse.getX(), love.mouse.getY(), 3, 3)
	--draw info
	DRAW_wave()
end

function love.update(dt)
	if(player.hp > 0) then 
		--update player
		UPDATE_player(dt)
		
		--calc pals
		for i,v in ipairs(pals) do 
			pals[i]:update(dt)
		end 

		--update bullets 
		UPDATE_bullets(dt)

		--update powerup 
		for i,v in ipairs(powerups) do 
			v:update(dt)
		end 

		--update enemies
		UPDATE_enemies(dt)

		--update camShake
		camShake.update(dt)
	else 
		if(love.keyboard.isDown('r')) then 
			RESET()
		end 
	end 
end

function love.mousepressed(x, y, button)
	FIRE_bullets(x, y, button)
end

--should really move to a util file

function dist( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

function RESET()
	love.load()
end 

--color stuff
function HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

