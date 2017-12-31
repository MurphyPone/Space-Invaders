local Player = {}

function LOAD_player() 
	player = {}
		player.x = WIDTH/2
		player.y = HEIGHT/2
		player.img = love.graphics.newImage('imgs/ship2.png')
		player.scale = 1
		player.r = 0
		player.vel = 300
		player.w = player.img:getWidth()  
		player.h = player.img:getHeight() 
		player.size = 34 --hitbox 
		player.dmg = 8 --starting cannon size 
		player.hp = 32
		player.sound = {}
			player.sound.cannon = love.audio.newSource('sfx/hit1.mp3')
			player.sound.chomp = love.audio.newSource('sfx/chomp.wav')

		--hit anim stuff
		--[[player.hit = {}
			player.hit.val = 0
			player.hit.alpha = 0
			player.hit.x, player.hit.y = player.x, player.y
			player.hit.a = 0]]

		--particle system damage
		player.hit = {}
			player.hit.img = love.graphics.newImage('imgs/playerhit.png') 
			player.hit.p = love.graphics.newParticleSystem(player.hit.img, 5)
			player.hit.p:setParticleLifetime(1,1.5)
			player.hit.p:setLinearAcceleration(-5, -5, 50, 100)
			player.hit.p:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to black.

		player.damageEffect = love.graphics.newImage('imgs/damaged.png')
		player.damagedEffectAlpha = 0

	return player
end 

function UPDATE_player(dt)
	if(love.keyboard.isDown('a') and player.x > xPad) 			then player.x = player.x - player.vel * dt end 
	if(love.keyboard.isDown('d') and player.x < WIDTH - xPad) 	then player.x = player.x + player.vel * dt end 
	if(love.keyboard.isDown('w') and player.y > yPad) 			then player.y = player.y - player.vel * dt end 
	if(love.keyboard.isDown('s') and player.y < HEIGHT - yPad) 	then player.y = player.y + player.vel * dt end 

	--calculate angle from player to mouse
	local startX = player.x --+ player.w/2
	local startY = player.y --+ player.h/2
	local mouseX, mouseY = love.mouse.getPosition()
	player.r = math.atan2((mouseY - startY), (mouseX - startX)) + math.pi/2	--Point ship towards cursor

	
	--FIX HERE 
	--collision
	--if(player.hit.alpha > 0) then hitCalc(dt) end 
	player.hit.p:update(dt)
	if(player.damagedEffectAlpha > 0) then player.damagedEffectAlpha = player.damagedEffectAlpha - 200*dt end

	for i,v in ipairs(enemies) do 
		if(isHit(v)) then 
			--bounce enemy away?
			v.x = v.x - love.math.random(-1,1) * 35
			v.y = v.y - love.math.random(-1,1) * 35
			player.hp = player.hp - v.dmg 
			player.hit.p:emit(1)
			player.damagedEffectAlpha = 255
			love.audio.stop(player.sound.chomp)
			love.audio.play(player.sound.chomp)

			--[[player.hit.x, player.hit.y = player.x, player.y 
			player.hit.alpha = 255
			player.hit.val = v.dmg]]
		end 
	end 
end 

function DRAW_player()
	love.graphics.draw(player.img, player.x, player.y, player.r, player.scale, player.scale, player.w/2, player.h/2)
	--draw health 
	if(player.hp > 10) then love.graphics.setColor(0, 200, 0) else love.graphics.setColor(255, 0, 0) end 

	love.graphics.push()
		love.graphics.translate(player.x, player.y)
		love.graphics.print(tostring(player.hp), 0, player.h)
		
		--draw particle system
		love.graphics.setColor(255,255,255)
		love.graphics.draw(player.hit.p, 10, player.h)

	love.graphics.pop()
	love.graphics.setColor(255,255,255)

	love.graphics.setColor(255, 255, 255, player.damagedEffectAlpha)
	love.graphics.draw(player.damageEffect, 0, 0)

	love.graphics.setColor(255, 255, 255)


			--[[draw hit anim
	if(player.hit.alpha > 0) then 
		hitAnim()
	end ]]
end 

function isHit(enemy)
	local radius = player.size/2
	return dist(player.x, player.y, enemy.x, enemy.y) < radius
end 

--
function hitAnim()
	love.graphics.setColor(255, 0, 0, player.hit.alpha)

	love.graphics.push()
		love.graphics.translate(player.hit.x + 20, player.hit.y + player.h)
		love.graphics.rotate(player.hit.a)
		love.graphics.print("-"..tostring(player.hit.val), 0, 0)
	love.graphics.pop()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(player.damageEffect, 0, 0)
end 	

function hitCalc(dt)
	player.hit.x = player.hit.x + 100 * dt
	player.hit.y = player.hit.y + 60 * dt
	player.hit.alpha = player.hit.alpha - 1000 *dt 
	player.hit.a = player.hit.a + dt
	player.damagedEffectAlpha = player.damagedEffectAlpha - 10 * dt
end 