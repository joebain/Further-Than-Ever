pos = {}

function pos.add(p1, p2)
	p3 = {}
	p3.x = p1.x + p2.x
	p3.y = p1.y + p2.y
	return p3
end

function pos.floor(p1)
	p1.x = math.floor(p1.x)
	p1.y = math.floor(p1.y)
	return p1
end
