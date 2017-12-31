require('anAL')
require('waves')

Enemy = {} --Represents whole object 

function Enemy:new(offset)
  	enemy = {}
		enemy.o = offset
		enemy.x, enemy.y = spawn()
		enemy.size = 30	--treat as radius*2
		enemy.angle = math.atan2(player.y - enemy.y, player.x - enemy.x)
		enemy.speed = 70 + wave 
		enemy.hp = 20 + wave 
		enemy.alive = true
		enemy.alpha = 255
		enemy.dmg = 1 --attack damage to player

		--anim stuff
		enemy.img = love.graphics.newImage('imgs/skullsheet.png')
		enemy.anim = newAnimation(enemy.img, enemy.size, enemy.size, .07, 0)

		--[[hit anim stuff
		enemy.hit = {}
			enemy.hit.alpha = 0
			enemy.hit.x, enemy.hit.y = enemy.x, enemy.y
			enemy.hit.a = 0]]

		--Particle system
		enemy.hit = {}
			enemy.hit.img = love.graphics.newImage('imgs/playerhit.png') 
			enemy.hit.p = love.graphics.newParticleSystem(player.hit.img, 5)
			enemy.hit.p:setParticleLifetime(1,1.5)
			enemy.hit.p:setLinearAcceleration(0, 0, 100, 100)
			enemy.hit.p:setSpeed(20)
			enemy.hit.p:setSpin(-2, 10)
			enemy.hit.p:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to black.



	setmetatable(enemy, { __index = Enemy })
  	return enemy
end


function Enemy:update(dt)
	if(self.alive) then 
		self:move(dt)

		self.angle = math.atan2(player.y - enemy.y, player.x - enemy.x)
		self.anim:update(dt)
		self:isHit()

		if(self.hp <= 0) then 
			self.alive = false
		end 

		--HP anim
		--if(self.hit.alpha > 0) then self:hitCalc(dt) end 
		self.hit.p:update(dt)
	else --is dead 
		self.size = self.size + 100 *dt 
		self.angle = self.angle + 20 * dt --spin die anim
		self.alpha = self.alpha - 1000 * dt
	end 
end 

function Enemy:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.rotate(self.angle - math.pi/2)

		if(self.alive == true) then 
			self.anim:draw(0,0, -math.pi/2, 1, 1, 13, 16)	--manual offset
			--draw psystem
			--draw particle system
			love.graphics.setColor(255,255,255)
			love.graphics.rotate(-1 * (self.angle - math.pi/2) )
			love.graphics.draw(self.hit.p, 10, self.size)

		elseif self.alpha > 0 then  	--is dead 
			camShake.preDraw()
			love.graphics.setColor(self.alpha, self.alpha, self.alpha, self.alpha) --fade to black
			self.anim:draw(0,0, -math.pi/2, 1, 1, 13, 16)	--manual offset 13, 16 
			camShake.postDraw()
		end
	love.graphics.pop()
	love.graphics.setColor(255, 255, 255)
	
	--draw hp
	if(self.alive) then 
		love.graphics.print(self.hp, self.x, self.y + 15)
		--[[draw hit anim
		if(self.hit.alpha > 0) then 
			self:hitAnim()
		end ]]

	end 
end

function Enemy:isHit()
	local radius = self.size/2

	for i,v in ipairs(bullets) do 
		if dist(self.x, self.y, v.x, v.y) < radius then 
			self.hp = self.hp - v.dmg 
			--[[self.hit.x, self.hit.y = self.x, self.y 
			self.hit.alpha = 255
			self.hit.val = v.dmg]]--
			self.hit.p:emit(v.dmg)
			love.audio.stop(v.s)	--this is bad
			love.audio.play(v.s)
			
			table.remove(bullets, i)
		end 
	end 
end 

function Enemy:move(dt)	--tracks player
	if(self.x < player.x) then self.x = self.x + (self.speed * dt) end
	if(self.x > player.x) then self.x = self.x - (self.speed * dt) end
	if(self.y < player.y) then self.y = self.y + (self.speed * dt) end
	if(self.y > player.y) then self.y = self.y - (self.speed * dt) end
end 

function Enemy:hitAnim()
	love.graphics.setColor(0, 255, 0, self.hit.alpha)
	love.graphics.push()
		love.graphics.translate(self.hit.x, self.hit.y)
		love.graphics.rotate(self.hit.a)
		love.graphics.print("-"..tostring(self.hit.val), 0, 0)
	love.graphics.pop()
	love.graphics.setColor(255, 255, 255)
end 	

function Enemy:hitCalc(dt)
	self.hit.x = self.hit.x + 30 * dt
	self.hit.y = self.hit.y + 30 * dt
	self.hit.alpha = self.hit.alpha - 1000 *dt 
	self.hit.a = self.hit.a + dt
end 

function spawn()
	local side = love.math.random(1,4) --top, left, bottom, right
	local x, y 
	
	if(side == 1) then 
		x = love.math.random(0, WIDTH)
		y = -love.math.random(0, 50)
	elseif(side == 2) then 
		x = -love.math.random(0, 50)
		y = love.math.random(0, HEIGHT)
	elseif(side == 3) then 
		x = love.math.random(0, WIDTH)
		y = love.math.random(HEIGHT, HEIGHT + 50)
	elseif(side == 4) then 
		x = love.math.random(WIDTH, WIDTH + 50)
		y = love.math.random(0, HEIGHT)
	end 

	return x, y 
end 

--Static functions
function LOAD_enemies()
	local enemies = {}
	for i = 1, 10 do 
		table.insert(enemies, Enemy:new())
	end
end

function DRAW_enemies() 
	for i,v in ipairs(enemies) do 
		v:draw()
	end 
end 

function UPDATE_enemies(dt)
	for i,v in ipairs(enemies) do 
		v:update(dt)
	end 

	RESET_enemies()
end 


