function RESET_enemies() 
	if(waveComplete()) then
		wave = wave + 1
		for i = 0, wave do 
			table.insert(enemies, Enemy:new())
		end 
	end 
end  

function DRAW_wave()
	love.graphics.print("Wave: "..tostring(wave), 10, 10)
end 

function waveComplete()
	for i,v in ipairs(enemies) do 
		if(v.alive == true) then
			return false
		else 
			table.remove(enemies, i)
			if(love.math.random(1,10) == 10) then table.insert(powerups, Powerup:new()) end --chance to spawn a powerup
		end 
	end 
	return true 
end 

