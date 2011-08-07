man = {}

man.position = {}
man.position.x = tiles.tile_size * tiles.width * 0.5
man.position.y = 0
man.size = 30
man.speed = 20

man.net = {}
man.net.pos = {}
man.net.pos.x = 0
man.net.pos.y = 0
man.net.size = {}
man.net.size.x = 5
man.net.size.y = 20

man.net.points = {}
man.net.speed = 1
man.net.damping = 0.5
man.net.whip_factor = 2
man.net.spacing = tiles.tile_size
man.net.min_length = 4
man.net.max_length = 25
man.net.length = man.net.min_length

man.net.size = 2
man.net.top = 0
man.net.bottom = 0
man.net.left = 0
man.net.right = 0

function man.init()
    man.position.y = love.graphics.getHeight() - tiles.tile_size * tiles.border.bottom

	man.init_net()

end

function man.init_net()

	love.graphics.setLine(2,"smooth")
	for i = 1,man.net.max_length do
		man.net.points[i] = {}
		man.net.points[i].x = man.position.x
		man.net.points[i].y = man.position.y - man.net.spacing*(i-2)
		man.net.points[i].vx = 0
		man.net.points[i].vy = 0
	end

end

function man.update(dt)

	-- get the birds
	for i,bird in ipairs(all_birds) do
		if not bird.alive then
			table.remove(all_birds, i)
		elseif
			bird.position.y <= man.net.bottom and
			bird.position.y >= man.net.top and
			bird.position.x+1 >= man.net.left and
			bird.position.x-1 <= man.net.right then

			bird.alive = false
			stage_up()
		else
			--		print(
			--	"bottom ".. self.position.y ..",".. man.net.bottom .."\n"..
			--		"top ".. self.position.y ..",".. man.net.top .."\n"..
			--	"left ".. self.position.x ..",".. man.net.left .."\n"..
			--	"right "..	self.position.x ..",".. man.net.right.."\n")
		end
	end

    if love.keyboard.isDown('right') then
        man.move(dt * man.speed)
    end
    if love.keyboard.isDown('left') then
        man.move(-dt * man.speed)
	end

	-- do x velocities
	lowest_point = man.net.max_length - man.net.length
	man.net.points[lowest_point].vx = (man.position.x - man.net.points[1].x) * dt
	for i = lowest_point,man.net.max_length do
		dx = (man.net.points[i-1].x - man.net.points[i].x)
		man.net.points[i].vx = man.net.points[i].vx + dx * man.net.whip_factor * dt
		man.net.points[i].vx = man.net.points[i].vx * (1-(man.net.damping))
--		print(man.net.points[i].vx)
	end

	-- adjust x coords
	man.net.points[lowest_point].x = man.position.x
	for i = lowest_point+1,man.net.max_length do
		man.net.points[i].x = man.net.points[i].x + man.net.points[i].vx * man.net.speed
		dx = man.net.points[i].x - man.net.points[i-1].x
		if math.abs(dx) > man.net.spacing then
			if dx > 0 then sign = 1 else sign = -1 end
			man.net.points[i].x = man.net.points[i-1].x + man.net.spacing * sign
		end
	end

	-- adjust y coords
	man.net.points[lowest_point].y = man.position.y
	for i = lowest_point+1,man.net.max_length do
		dx = math.min(math.abs(man.net.points[i].x - man.net.points[i-1].x), man.net.spacing)
		man.net.points[i].y = man.net.points[i-1].y - math.sqrt(man.net.spacing * man.net.spacing - dx * dx)
	end

	man.net.top = math.floor((man.net.points[man.net.max_length].y-man.net.size) / tiles.tile_size)
	man.net.bottom = math.ceil((man.net.points[man.net.max_length].y+man.net.size) / tiles.tile_size)
	man.net.left = math.floor((man.net.points[man.net.max_length].x-man.net.size) / tiles.tile_size)
	man.net.right = math.ceil((man.net.points[man.net.max_length].x+man.net.size) / tiles.tile_size)

end

function man.draw()
	love.graphics.setColor( 255,255,255, 255 )

--    love.graphics.circle(
--        "fill",
--        man.position.x,
--        man.position.y,
--        man.size * level, level)

	lowest_point = man.net.max_length - man.net.length
	for i = lowest_point,man.net.max_length-1 do
		love.graphics.line(
			man.net.points[i].x,
			man.net.points[i].y,
			man.net.points[i+1].x,
			man.net.points[i+1].y)
	end

	topx = man.net.points[#man.net.points].x
	topy = man.net.points[#man.net.points].y

	if sounds.beat_position%1 > 0.8 or sounds.beat_position%1 < 0.2 then
		love.graphics.circle(
			"line", topx, topy,
			man.size, man.net.length)
	else
		love.graphics.circle(
			"line", topx, topy,
			man.size*0.5, 4)
--	elseif sounds.beat_position < 1 then
--		love.graphics.line(
--			topx-man.size, topy,
--			topx, topy-man.size)
--	elseif sounds.beat_position < 2 then
--		love.graphics.line(
--			topx, topy-man.size,
--			topx+man.size, topy)
--	elseif sounds.beat_position < 3 then
--		love.graphics.line(
--			topx+man.size, topy,
--			topx, topy+man.size)
--	elseif sounds.beat_position < 4 then
--		love.graphics.line(
--			topx-man.size, topy,
--			topx, topy+man.size)
	end
end

function man.move(dir)
    old_man_position = {}
    old_man_position.x = man.position.x
    old_man_position.y = man.position.y
    
    man.position.x = man.position.x + 10*dir
    if man.position.x > love.graphics.getWidth() or man.position.x < 0 then
        man.position.x = old_man_position.x
    end
end
