local SFX = {}

function LOAD_SFX()
	SFX.hit1 = love.audio.newSource('sfx/hit1.mp3', 'static') --static for sfx, stream for bgm

	SFX.smallhits = { love.audio.newSource('sfx/small_hit1.mp3', 'static'), love.audio.newSource('sfx/small_hit2.mp3', 'static') }

	return SFX
end 

function SFX:play(sound)
	love.audio.stop(sound)
	love.audio.play(sound)
end 

function SFX:playTable(sound)
	local index = math.random(0, #sound)
	for i, v in ipairs(sound) do 
		love.audio.stop(v)
	end 

	love.audio.play(sound[index])
end  