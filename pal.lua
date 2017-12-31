Pal = {} --Represents whole object 

--FIX THIS
dmgMod = 3

function Pal:new(offset)
  	pal = {}
		pal.size = 10
		pal.dist = 0
		pal.maxDist = 50
		pal.o = offset
		pal.angle = pal.o * 2*math.pi/#pals
		pal.x = player.x + math.sin(pal.angle) * pal.dist 
		pal.y = player.y + math.cos(pal.angle) * pal.dist 
		pal.dmg = dmgMod 
		pal.sound = {}
			pal.sound.cannon = love.audio.newSource('sfx/small_hit1.mp3')	--this is inefficient, loads the sound over and over for each enemy

	setmetatable(pal, { __index = Pal })
  	return pal
end


function Pal:update(dt)
	if(self.dist < self.maxDist ) then 
		self.dist = self.dist + 100 * dt
	end 
	--pal calculations acc to player's loc
	self.angle = self.angle + (2*dt)
	self.x = player.x + math.sin(self.angle) * self.dist 
	self.y = player.y + math.cos(self.angle) * self.dist 
	self.dmg = dmgMod 
end 

function Pal:draw()
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.rotate(self.angle)
		love.graphics.circle('line', 0, 0, 5, 3)
	love.graphics.pop()
end 

--Static functions
function LOAD_pals()
	local pals = {}
	--[[numPals = 0
	for i=1, 0 do 
		 table.insert(pals, Pal:new(i))
	end ]]--
	return pals 
end 

function DRAW_pals() 
	for i,v in ipairs(pals) do 
		pals[i]:draw()
	end 
end 

function UPDATE_allPals()
	for i,v in ipairs(pals) do 
		v.angle = v.o * (2*math.pi/#pals ) 
	end 
end 



