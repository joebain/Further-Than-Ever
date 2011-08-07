tiles = {}

tiles.data = {}
tiles.width = 40
tiles.height = 20
tiles.tile_size = 20
tiles.border = {}
tiles.border.left = 0
tiles.border.top = 0
tiles.border.bottom = 2.5
tiles.border.right = 0

tiles.brightness_down_speed = 0.4
tiles.minor_brightness_down_speed = 0.1
tiles.darkness = 0.6
tiles.minor_darkness = 0.2
tiles.darkness_upper = 255
tiles.darkness_lower = 127
tiles.lightness = 2.0
tiles.random_variance = 2.0

tiles.finishing = false

function tiles.init()
    for i = 1,tiles.width do
        tiles.data[i] = {}
        for j = 1,tiles.height do
			tiles.data[i][j] = {}
			tiles.data[i][j].a = {}
			tiles.data[i][j].b = {}
			tiles.data[i][j]["a"].r = math.random(127,255)
			tiles.data[i][j]["a"].g = math.random(127,255)
			tiles.data[i][j]["a"].b = math.random(127,255)
			tiles.data[i][j]["a"].a = tiles.minor_darkness
			tiles.data[i][j]["b"].r = math.random(127,255)
			tiles.data[i][j]["b"].g = math.random(127,255)
			tiles.data[i][j]["b"].b = math.random(127,255)
			tiles.data[i][j]["b"].a = tiles.minor_darkness
        end
    end
end

function random_channel(channel)
	if channel <= tiles.darkness_upper and channel >= tiles.darkness_lower then
		channel = channel + math.random(-tiles.random_variance,tiles.random_variance)
	end
	if channel < tiles.darkness_lower then channel = tiles.darkness_lower end
	if channel > tiles.darkness_upper then channel = tiles.darkness_upper end
	return channel
end

function alter_colour(col)
	col.r = random_channel(col.r)
	col.g = random_channel(col.g)
	col.b = random_channel(col.b)
	return col
end

function tiles.draw()
    for i = 1,tiles.width do
        for j = 1,tiles.height do
			x = i + tiles.border.left - 1
			y = j + tiles.border.top - 1
			if not tiles.is_blank({x = i, y = j}, "a") then
				col = tiles.data[i][j].a
				col = alter_colour(col)
				tiles.data[i][j].a = col
				love.graphics.setColor(
					math.min(col.r * col.a, 255),
					math.min(col.g * col.a, 255),
					math.min(col.b * col.a, 255)
					, 255 )
				love.graphics.polygon('fill',
					tiles.tile_size * x, tiles.tile_size * y,
					tiles.tile_size * (x+1), tiles.tile_size * (y+1),
					tiles.tile_size * x, tiles.tile_size * (y+1))

			end

			if not tiles.is_blank({x = i, y = j}, "b") then
				col = tiles.data[i][j].b
				col = alter_colour(col)
				tiles.data[i][j].b = col
				love.graphics.setColor(
					math.min(col.r * col.a, 255),
					math.min(col.g * col.a, 255),
					math.min(col.b * col.a, 255)
					, 255 )
				love.graphics.polygon('fill',
					tiles.tile_size * x, tiles.tile_size * y,
					tiles.tile_size * (x+1), tiles.tile_size * (y+1),
					tiles.tile_size * (x+1), tiles.tile_size * y)
			
			end
        end
    end
end

function tiles.update(dt)
    for i = 1,tiles.width do
        for j = 1,tiles.height do
			x = i + tiles.border.left - 1
			y = j + tiles.border.top - 1
			if tiles.finishing then
				tiles.data[i][j].a = tiles.increase(tiles.data[i][j].a, dt)
				tiles.data[i][j].b = tiles.increase(tiles.data[i][j].b, dt)
			else
				if not tiles.is_blank({x = i, y = j}, "a") then
					tiles.data[i][j].a.a = tiles.diminish(tiles.data[i][j].a.a, dt)
				end
				if not tiles.is_blank({x = i, y = j}, "b") then
					tiles.data[i][j].b.a = tiles.diminish(tiles.data[i][j].b.a, dt)
				end
			end
		end
	end
end

function tiles.diminish(value, dt)
	if value > tiles.darkness then
		return value - tiles.brightness_down_speed * dt
--    elseif value > tiles.minor_darkness then
--        return value - tiles.minor_brightness_down_speed * dt
	end
	return value
end

function tiles.increase(value, dt)
	value.r = value.r + tiles.minor_brightness_down_speed * dt
	value.g = value.g + tiles.minor_brightness_down_speed * dt
	value.b = value.b + tiles.minor_brightness_down_speed * dt
	value.a = value.a + tiles.minor_brightness_down_speed * dt

	value.r = math.min(value.r, 255)
	value.g = math.min(value.g, 255)
	value.b = math.min(value.b, 255)
	value.a = math.min(value.a, 255)

	return value
end

function tiles.fill(position, half)
	i = position.x
	j = position.y

	if i < 1 or i > tiles.width then return end
	if j < 1 or j > tiles.height then return end

--	print("fill " .. i .. ", " .. j .. ", " .. half)

--	if tiles.data[i][j][half].r > 64 then
--		tiles.data[i][j][half].r = tiles.data[i][j][half].r - 191
--		tiles.data[i][j][half].g = tiles.data[i][j][half].g - 191
--		tiles.data[i][j][half].b = tiles.data[i][j][half].b - 191
--	end
end

function tiles.blank(position, half)
	i = position.x
	j = position.y

	if i < 1 or i > tiles.width then return end
	if j < 1 or j > tiles.height then return end

	tiles.data[i][j][half].a = tiles.lightness
end

function tiles.is_blank(position, half)
	i = position.x
	j = position.y

	if i < 1 or i > tiles.width then return end
	if j < 1 or j > tiles.height then return end

	return tiles.data[i][j][half].a == 0
end
