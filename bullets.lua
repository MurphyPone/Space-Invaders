require('anAL')
require('pal')

function LOAD_bullets()
	bullets = {}
	bulletSpeed = 250
	bulletImg = love.graphics.newImage('imgs/bulletSheet3.png')
	frameW, frameH = 12, 24

	bulletAnim = newAnimation(bulletImg, frameW, frameH, .5, 0)

	return bullets 
end 

function DRAW_bullets()
	for i,v in ipairs(bullets) do
	love.graphics.setColor(255, 50, 100)
		--bulletAnim:draw(v.x, v.y, v.a, .8, .8, frameW/2, frameH/2)
		love.graphics.push()
			love.graphics.translate(v.x, v.y)
			love.graphics.rotate(v.a)

			local att = 9
			local style
			if(v.dmg < att) then 
				att = v.dmg 
				style = "fill"
			else 
				love.graphics.setColor(HSL(40 +v.dmg *5, 500, 50, 255))
				 style = "line"
			end  
			
			love.graphics.circle(style, 0, 0, att, att)
		love.graphics.pop()
	end
	love.graphics.setColor(255, 255, 255)
end 

function UPDATE_bullets(dt)
	for i,v in ipairs(bullets) do
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)

		if(v.x > WIDTH or v.x < 0 or v.y < 0 or v.y > HEIGHT) then table.remove(bullets, i) end
		bulletAnim:update(dt)
	end
end 

function FIRE_bullets(x, y, button)
	if button == 1 then
		local startX = player.x --* player.scale
		local startY = player.y --* player.scale
		local mouseX = x
		local mouseY = y
 
		local angle = math.atan2((mouseY - startY), (mouseX - startX))
 
		local bulletDx = bulletSpeed * math.cos(angle)
		local bulletDy = bulletSpeed * math.sin(angle)
 
		table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy, a = angle + math.pi/2, dmg = player.dmg, s = player.sound.cannon})

		for i,v in ipairs(pals) do
			startX = v.x --* player.scale
			startY = v.y --* player.scale
	 
			angle = math.atan2((mouseY - startY), (mouseX - startX))	--ENABLE/DISABLE THIS FOR POINTED or STRAIGHT FIRING MODe
	 
			bulletDx = bulletSpeed * math.cos(angle)
			bulletDy = bulletSpeed * math.sin(angle)
	 
			table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy, a = angle + math.pi/2, dmg = pal.dmg, s = pal.sound.cannon})
		end 
	end
end 