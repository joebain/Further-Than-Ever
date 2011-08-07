bird = {}
bird_mt = { __index = bird}

birds = {}

birds.randoms = {2, 1, 1, 1, 1, 3, 1, 1, 6, 2, 1, 9, 1, 1, 10, 1, 1, 5, 2, 1, 9, 1, 2, 1, 1, 2, 3, 1, 1, 6, 2, 2, 9}

birds.random_count = 0

function bird:new()

	return setmetatable( {

		alive = true,

		position = { x = 0, y = 0 },

		velocity = { x = 0, y = 0},

		flap_state = false,

		wings_flap = {
			{{x = 0, y = 0},"b"},
			{{x = 1, y = 0},"a"},
			{{x = 2, y = 0},"a"}},

		wings_no_flap = {
			{{x = 0, y = 0},"b"},
			{{x = 1, y = 1},"b"},
			{{x = 2, y = 0},"a"}}

		} , bird_mt)
end

function birds.get_random(upper)
	if birds.random_count < #birds.randoms then
		birds.random_count = birds.random_count + 1
		return birds.randoms[birds.random_count]
	else
		return math.random(upper)
	end
end

function bird:init()
	self.position.x = 0
	self.velocity.x = 1
	rand = birds.get_random(2)
	--print(rand .. ",")
	self.velocity.y = math.floor(rand) / 2
	rand = birds.get_random(2)
	--print(rand .. ",")
	if rand > 1 then
		self.velocity.y = -self.velocity.y
	end
	if self.velocity.y < 0 then
		rand = birds.get_random(tiles.height/2)
		--print(rand .. ",")
		self.position.y = rand + tiles.height/2
	elseif self.velocity.y > 0 then
		rand = birds.get_random(tiles.height/2)
		--print(rand .. ",")
		self.position.y = rand 
	else
		rand = birds.get_random(tiles.height/2)
		--print(rand .. ",")
		self.position.y = rand + tiles.height/4
	end

	sounds.add_beat_change_cb(bird.flap, self)
end

function bird:flap()

	if not self.alive then
		return
	end



	self.flap_state = not self.flap_state

	old_pos = {}
	old_pos.x = self.position.x
	old_pos.y = self.position.y

	self.position.x = self.position.x + self.velocity.x
	self.position.y = self.position.y + self.velocity.y

	if self.position.x > tiles.width + 3 then
		self.alive = false
		stage_down()
	end

	if self.position.y < 1 or
		self.position.y > tiles.height - 1 then
		self.velocity.y = -self.velocity.y
	end

	if self.flap_state then
		new_wings = self.wings_flap
		old_wings = self.wings_no_flap
	else
		new_wings = self.wings_no_flap
		old_wings = self.wings_flap
	end

	for i,wing in ipairs(old_wings) do
		old_wing = pos.floor(pos.add(old_pos, wing[1]))
		tiles.fill(old_wing, wing[2])
	end

	for i,wing in ipairs(new_wings) do
		new_wing = pos.floor(pos.add(self.position, wing[1]))
		tiles.blank(new_wing, wing[2])
	end
end
