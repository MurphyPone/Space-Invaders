require('pal')

Powerup = {}

Powerup.sound = love.audio.newSource('sfx/coin1.wav')

types = {'pal', 'hp', 'dmg', 'dmg+'} --ADD A SHEILD TYPE

function Powerup:new(t) --t = type

  	pup = {}
		pup.size = 10
		pup.t = t or (types[love.math.random(1, #types)]) --type "dmg", "pal", 'hp'?
		pup.angle = 0
		pup.x = love.math.random(pup.size, WIDTH - pup.size)
		pup.y = love.math.random(pup.size, HEIGHT - pup.size)
		pup.speed = 20
		pup.alive = true

		--for collect anim
		pup.alpha = 255
		pup.grow = 0

		self.dest = { x = love.math.random(pup.size, WIDTH - pup.size), y = love.math.random(pup.size, HEIGHT - pup.size) } --

	setmetatable(pup, { __index = Powerup })
  	return pup
end

function Powerup:draw()
	love.graphics.setColor(255, 255, 0)
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.rotate(self.angle)
		
		if(self.alive == true) then 
			love.graphics.rectangle("line", -self.size/2, -self.size/2, self.size, self.size)
			love.graphics.print(self.t, -self.size/2, self.size )
		elseif self.alpha > 0 then  	--is dead 
			camShake.preDraw()
			love.graphics.setColor(self.alpha, 255, 0, self.alpha)
			love.graphics.rectangle("line", -self.size/2, -self.size/2, self.size, self.size)
			camShake.postDraw()
		end
	love.graphics.pop()
	love.graphics.setColor(255, 255, 255)
end 


function Powerup:update(dt)
	if(self.alive) then 
		if(self:collision() ~= true ) then 
			self.angle = self.angle + 1*dt
			self:moveToDest(dt)
		else --collides
			self.alive = false
			self:upgrade()			
		end 
	else --is dead 
		self.size = self.size + 100 *dt 
		self.alpha = self.alpha - 1000 * dt
	end 
end 

function Powerup:moveToDest(dt)
	if(self.x < self.dest.x) then 
		self.x = self.x + self.speed * dt 
	elseif (self.x > self.dest.x) then 
		self.x = self.x - self.speed * dt 
	end 

	if(self.y < self.dest.y) then 
		self.y = self.y + self.speed * dt 
	elseif (self.y > self.dest.y) then 
		self.y = self.y - self.speed * dt 
	end 
end 

function Powerup:collision()	--only checks for collisions with the player, so no params
	return (self.x < player.x+player.w/2 and self.x > player.x - player.w/2
		and self.y < player.y+player.h/2 and self.y > player.y - player.h/2) 	
end 

function Powerup:upgrade()
	love.audio.stop(Powerup.sound)
	love.audio.play(Powerup.sound)
	if(self.t == 'pal') then 
		table.insert(pals, Pal:new(#pals) )	--adds a new pal to the pals table with the param length 
		UPDATE_allPals()
	elseif(self.t == 'dmg') then 
		player.dmg = player.dmg + 1 
	elseif(self.t == 'hp') then 
		player.hp = player.hp + 5--5 = health boost amt
	elseif(self.t == 'dmg+') then 
		dmgMod = dmgMod + 1
	end 
end 

--Statics functions 
function LOAD_powerups()
	powerups = {}	--table keeping track of all

	table.insert(powerups, Powerup:new())
	table.insert(powerups, Powerup:new())
	table.insert(powerups, Powerup:new())

	return powerups
end 








